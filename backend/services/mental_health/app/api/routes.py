from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..models.model import predict_depression
from ..gemini_agent.chat import get_gemini_response
from ..gemini_agent.summarizer import generate_summary
from ..utils.cache import cache_response, get_cached_response

router = APIRouter()

class ChatRequest(BaseModel):
    query: str

class ChatResponse(BaseModel):
    response: str

class SummaryResponse(BaseModel):
    summary: str
    stats: dict

@router.post("/chat", response_model=ChatResponse)
async def get_response(data: ChatRequest):
    try:
        response = get_gemini_response(data.query)
        return {"response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/summary", response_model=SummaryResponse)
async def summary():
    try:
        # Temporary mock data until we implement proper storage
        mock_logs = [
            {"text": "Feeling good today", "timestamp": "2024-05-21T09:00:00", "depressed": False},
            {"text": "Not feeling great", "timestamp": "2024-05-21T10:00:00", "depressed": True}
        ]
        summary_text = generate_summary(mock_logs)
        stats = {
            "total_entries": len(mock_logs),
            "depression_count": sum(1 for log in mock_logs if log.get("depressed", False)),
            "last_updated": mock_logs[-1]["timestamp"] if mock_logs else None
        }
        return {"summary": summary_text, "stats": stats}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
        
