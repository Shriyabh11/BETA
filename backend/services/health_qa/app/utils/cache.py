_qa_cache = {}

def cache_response(query, result):
    _qa_cache[query] = result

def get_cached_response(query):
    return _qa_cache.get(query) 