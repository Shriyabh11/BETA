import os
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

# Base paths
BASE_DIR = Path(__file__).resolve().parent.parent  # Changed to point to app directory
MODELS_DIR = BASE_DIR / "models"

# Create models directory if it doesn't exist
MODELS_DIR.mkdir(parents=True, exist_ok=True)

# Model settings
MODEL_NAME = "biobert_t1d_ner_model"
MODEL_PATH = str(MODELS_DIR / MODEL_NAME)
HUGGINGFACE_TOKEN = os.getenv("HUGGINGFACE_TOKEN", "")

# Validate model path
if not os.path.exists(MODEL_PATH):
    logger.warning(
        f"Model not found at {MODEL_PATH}. "
        "Please ensure the model files are present in the app/models directory. "
        f"The directory has been created at: {MODELS_DIR}"
    )
    # Don't raise an error, let the service start and handle the error when trying to use the model

# API settings
API_PREFIX = "/api/v1"
API_TITLE = "Health Log Processor"
API_DESCRIPTION = "API for processing health-related logs and extracting entities" 