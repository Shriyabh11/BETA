from .get_logs import _fake_logs

def store_log(text, depressed):
    # Optionally, add a timestamp for summary stats
    import datetime
    _fake_logs.append({
        "text": text,
        "depressed": depressed,
        "timestamp": datetime.datetime.now().isoformat()
    })
