import pickle
import os
from datetime import datetime
import joblib
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

# Get the base directory
BASE_DIR = Path(__file__).resolve().parent.parent  # Changed to point to app directory
MODEL_PATH = BASE_DIR / "ml" / "logistic_model.pkl"
VECTORIZER_PATH = BASE_DIR / "ml" / "tfidf_vectorizer.pkl"

# Create models directory if it doesn't exist
MODEL_PATH.parent.mkdir(parents=True, exist_ok=True)
VECTORIZER_PATH.parent.mkdir(parents=True, exist_ok=True)

# Initialize model and vectorizer as None
model = None
vectorizer = None

# Try to load the model and vectorizer if they exist
try:
    if os.path.exists(MODEL_PATH) and os.path.exists(VECTORIZER_PATH):
        model = joblib.load(MODEL_PATH)
        vectorizer = joblib.load(VECTORIZER_PATH)
        logger.info("Model and vectorizer loaded successfully")
    else:
        logger.warning(
            f"Model files not found at {MODEL_PATH} or {VECTORIZER_PATH}. "
            "Please ensure the model files are present in the app/ml directory."
        )
except Exception as e:
    logger.error(f"Error loading model files: {str(e)}")

def predict_depression(text: str) -> float:
    """
    Predict depression score for given text.
    
    Args:
        text (str): Input text to analyze
        
    Returns:
        float: Depression score between 0 and 1
    """
    try:
        if model is None or vectorizer is None:
            logger.warning(
                "Model or vectorizer not loaded. "
                "Please ensure the model files are present in the ml directory."
            )
            return 0.0  # Return neutral score if model is missing
            
        X = vectorizer.transform([text])
        pred = model.predict(X)
        return float(pred[0])
    except Exception as e:
        logger.error(f"Error in prediction: {str(e)}")
        return 0.0  # Return neutral score on error
