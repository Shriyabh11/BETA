import logging
import os
from pathlib import Path
from logging.handlers import RotatingFileHandler
from ..config.settings import LOG_LEVEL, LOG_FORMAT, BASE_DIR

def setup_logger(name: str, log_file: str = None) -> logging.Logger:
    """
    Set up a logger with both console and file handlers.
    
    Args:
        name: Name of the logger
        log_file: Optional specific log file name. If not provided, uses the logger name
    """
    logger = logging.getLogger(name)
    logger.setLevel(LOG_LEVEL)
    
    # Create logs directory if it doesn't exist
    logs_dir = os.path.join(BASE_DIR, "logs")
    os.makedirs(logs_dir, exist_ok=True)
    
    # Use provided log file or create one based on logger name
    if not log_file:
        log_file = f"{name}.log"
    log_path = os.path.join(logs_dir, log_file)
    
    # File handler with rotation (max 5 files of 5MB each)
    file_handler = RotatingFileHandler(
        log_path,
        maxBytes=5*1024*1024,  # 5MB
        backupCount=5
    )
    file_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    
    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    
    # Add handlers if they don't exist
    if not logger.handlers:
        logger.addHandler(file_handler)
        logger.addHandler(console_handler)
    
    return logger 