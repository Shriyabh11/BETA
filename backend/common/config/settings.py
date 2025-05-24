import os
from pathlib import Path

# Base paths
BASE_DIR = Path(__file__).resolve().parent.parent.parent
MODELS_DIR = os.path.join(BASE_DIR, "models")

# Common settings
HUGGINGFACE_TOKEN = os.getenv("HUGGINGFACE_TOKEN", "")

# API settings
API_PREFIX = "/api/v1"
API_VERSION = "1.0.0"

# Logging settings
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s" 