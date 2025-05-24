from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime

class Entity(BaseModel):
    type: str
    value: Optional[str] = None
    details: Optional[Dict[str, Any]] = None

class LogEntry(BaseModel):
    text: str
    entities: List[Entity]
    timestamp: Optional[datetime] = None
    created_at: datetime = datetime.now() 