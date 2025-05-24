from fastapi import APIRouter, Request, HTTPException, Query
from app.utils.response_handler import (
    classify_and_respond,
    store_user_query_log,
    get_user_logs
)
from transformers import AutoTokenizer, AutoModelForTokenClassification

router = APIRouter()

# Define model path - use your actual model repository name
model_path = "logging_agent/app/models/biobert_t1d_ner_model"  # Replace 'your-username' with your Hugging Face username

@router.post("/ask")
async def ask_question(request: Request):
    try:
        data = await request.json()
        user_id = data.get("user_id")
        query = data.get("query")

        if not user_id or not query:
            raise HTTPException(status_code=400, detail="Missing user_id or query")

        # Use Gemini and category-specific logic
        response_data = classify_and_respond(user_id=user_id, query=query)

        # Store the query and response
        store_user_query_log(
            user_id=user_id,
            query=query,
            response=response_data["response"],
            category=response_data["category"]
        )

        return {
            "response": response_data["response"],
            "category": response_data["category"]
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/history")
async def get_history(user_id: str = Query(..., description="User ID to fetch logs for")):
    try:
        logs = get_user_logs(user_id)
        return {"logs": logs}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

tokenizer = AutoTokenizer.from_pretrained(
    model_path,
    token=""  # Replace with your actual token here
)
model = AutoModelForTokenClassification.from_pretrained(
    model_path,
    token=""  # Replace with your actual token here
)
