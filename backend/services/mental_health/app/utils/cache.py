import redis
import json
from typing import Optional
import os

# Initialize Redis client
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'localhost'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    db=0,
    decode_responses=True
)

def cache_response(query: str, response: str, expiry: int = 3600) -> None:
    """
    Cache a response for a given query
    Args:
        query: The user query
        response: The response to cache
        expiry: Cache expiry time in seconds (default 1 hour)
    """
    try:
        redis_client.setex(
            f"query:{query}",
            expiry,
            json.dumps(response)
        )
    except Exception as e:
        print(f"Error caching response: {str(e)}")

def get_cached_response(query: str) -> Optional[str]:
    """
    Get a cached response for a query if it exists
    Args:
        query: The user query
    Returns:
        The cached response or None if not found
    """
    try:
        cached = redis_client.get(f"query:{query}")
        if cached:
            return json.loads(cached)
        return None
    except Exception as e:
        print(f"Error retrieving cached response: {str(e)}")
        return None 