from fastapi import APIRouter, HTTPException, Depends, Request
from pydantic import BaseModel
from ..services.classifier import classify_query
from ..services.nutrition import answer_nutrition
from ..services.general_health import answer_general_health
from ..services.web_search import answer_web_search
from ..services.gemini_service import paraphrase, save_to_memory, get_gemini_response
from ..utils.cache import cache_response, get_cached_response
from ..middleware.auth import verify_token

router = APIRouter()

class QARequest(BaseModel):
    query: str

class QAResponse(BaseModel):
    response: str
    category: str
    source: str

@router.post("/ask", response_model=QAResponse)
async def ask_question(request: Request, data: QARequest, user: dict = Depends(verify_token)):
    # Use a temporary session ID
    session_id = user.get('uid', 'default_user')
    
    # Check cache first (cache key includes session_id for context)
    cache_key = f"{session_id}:{data.query}"
    cached = get_cached_response(cache_key)
    if cached:
        return cached

    try:
        # 1. Paraphrase the query with memory
        preprocessed_query = paraphrase(data.query, mode="query", session_id=session_id)
        # 2. Classify the paraphrased query
        category = classify_query(preprocessed_query)
        # 3. Get the answer (raw)
        if category == "nutrition":
            raw_answer, source = answer_nutrition(preprocessed_query)
        elif category == "general_health":
            raw_answer, source = answer_general_health(preprocessed_query)
        else:
            raw_answer, source = answer_web_search(preprocessed_query)
        # 4. Use Gemini to generate the final answer with context
        final_response = get_gemini_response(raw_answer, session_id=session_id)
        # 5. Save to memory
        save_to_memory(session_id, data.query, final_response)
        result = {"response": final_response, "category": category, "source": source}
        cache_response(cache_key, result)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
