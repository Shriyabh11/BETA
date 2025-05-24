from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from ..models.entity_extractor import extract_entities
from ..data.storage import save_log_entry

router = APIRouter()

class LogEntry(BaseModel):
    text: str
    timestamp: Optional[str] = None

class Entity(BaseModel):
    type: str
    value: Optional[str] = None
    details: Optional[Dict[str, Any]] = None

class LogResponse(BaseModel):
    entities: List[Entity]
    message: str

@router.post("/process-log", response_model=LogResponse)
async def process_log(log_entry: LogEntry):
    try:
        # Extract entities using the custom NER model
        entities = extract_entities(log_entry.text)
        
        # Save the log entry and extracted entities
        save_log_entry(log_entry.text, entities, log_entry.timestamp)
        
        return LogResponse(
            entities=entities,
            message="Log processed successfully"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 