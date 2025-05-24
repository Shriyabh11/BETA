from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any
import asyncio
from common.utils.logger import setup_logger
from common.utils.thread_pool import ThreadPool
from .models.entity_extractor import extract_entities
from .config.settings import API_PREFIX, API_TITLE, API_DESCRIPTION

# Initialize logger
logger = setup_logger("logging_agent")

# Initialize thread pool
thread_pool = ThreadPool(max_workers=4)

app = FastAPI(
    title=API_TITLE,
    description=API_DESCRIPTION,
    prefix=API_PREFIX
)

class LogEntry(BaseModel):
    text: str
    timestamp: str
    user_id: str

class ProcessedLog(BaseModel):
    entities: List[Dict[str, Any]]
    timestamp: str
    user_id: str

@app.post("/process_log", response_model=ProcessedLog)
async def process_log(log_entry: LogEntry):
    """
    Process a log entry to extract health-related entities.
    Uses thread pool for concurrent processing.
    """
    try:
        logger.info(f"Processing log entry for user {log_entry.user_id}")
        
        # Submit entity extraction to thread pool
        future = thread_pool.submit(
            extract_entities,
            log_entry.text
        )
        
        # Wait for result
        entities = await asyncio.wrap_future(future)
        
        logger.info(f"Successfully extracted {len(entities)} entities")
        
        return ProcessedLog(
            entities=entities,
            timestamp=log_entry.timestamp,
            user_id=log_entry.user_id
        )
    except Exception as e:
        logger.error(f"Error processing log: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    """Health check endpoint."""
    logger.debug("Health check requested")
    return {"status": "healthy"} 