from concurrent.futures import ThreadPoolExecutor
from typing import Callable, Any
from .logger import setup_logger

logger = setup_logger(__name__)

class ThreadPool:
    """Simple thread pool for handling concurrent tasks."""
    
    def __init__(self, max_workers: int = 4):
        """Initialize thread pool with a reasonable default of 4 workers."""
        self.executor = ThreadPoolExecutor(max_workers=max_workers)
        logger.info(f"Thread pool initialized with {max_workers} workers")
    
    def submit(self, fn: Callable, *args, **kwargs) -> Any:
        """Submit a task to the thread pool."""
        return self.executor.submit(fn, *args, **kwargs)
    
    def shutdown(self):
        """Shutdown the thread pool."""
        self.executor.shutdown()
        logger.info("Thread pool shutdown complete") 