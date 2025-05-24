from typing import List, Dict, Any
import torch
from transformers import AutoTokenizer, AutoModelForTokenClassification
from ..data.models import Entity
from ..config.settings import MODEL_PATH, HUGGINGFACE_TOKEN
import logging
import os
from pathlib import Path

logger = logging.getLogger(__name__)

# Initialize model and tokenizer as None
loaded_model = None
loaded_tokenizer = None

def load_model():
    """
    Load the NER model and tokenizer.
    
    Returns:
        tuple: (model, tokenizer) or (None, None) if loading fails
    """
    try:
        if not os.path.exists(MODEL_PATH):
            logger.warning(
                f"Model not found at {MODEL_PATH}. "
                "Please ensure the model files are present in the models directory."
            )
            return None, None

        tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)
        model = AutoModelForTokenClassification.from_pretrained(MODEL_PATH)
        logger.info("Model and tokenizer loaded successfully")
        return model, tokenizer
    except Exception as e:
        logger.error(f"Error loading model: {str(e)}")
        return None, None

def get_labels():
    base_labels = ["O"]
    types = ["blood_sugar", "insulin_dose", "food", "sleep", "exercise", "medication"]
    labels = base_labels[:]
    for t in types:
        labels.append(f"B-{t}")
        labels.append(f"I-{t}")
    return labels

labels_list = get_labels()
id_to_label = {i: l for i, l in enumerate(labels_list)}

def extract_entities(text: str) -> List[Dict[str, Any]]:
    """
    Extract health-related entities from the input text using the BioBERT T1D NER model.
    
    Args:
        text (str): The input text to process
        
    Returns:
        List[Dict[str, Any]]: List of extracted entities with their types, values, and details
    """
    global loaded_model, loaded_tokenizer
    
    # Try to load model if not already loaded
    if loaded_model is None or loaded_tokenizer is None:
        loaded_model, loaded_tokenizer = load_model()
        
    if loaded_model is None or loaded_tokenizer is None:
        logger.warning("Model not loaded. Returning empty entity list.")
        return []

    try:
        # Tokenize the input text
        inputs = loaded_tokenizer(
            text,
            return_tensors="pt",
            padding="max_length",
            truncation=True,
            max_length=128,
            return_offsets_mapping=True
        )

        # Store offset mapping and word_ids
        offset_mapping = inputs["offset_mapping"][0].tolist()
        word_ids = inputs.word_ids(batch_index=0)

        # Move input tensors to device
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        model_inputs = {key: val.to(device) for key, val in inputs.items() if key != 'offset_mapping'}

        # Get predictions
        with torch.no_grad():
            outputs = loaded_model(**model_inputs)
            predictions = torch.argmax(outputs.logits, dim=-1)
            predictions = predictions[0].cpu().numpy()

        # Convert token predictions to word-level labels
        words = text.split()
        word_level_labels = ['O'] * len(words)
        previous_word_idx = None

        for token_idx, word_idx in enumerate(word_ids):
            if word_idx is None:
                continue
            if word_idx < len(words):
                if word_idx != previous_word_idx:
                    if token_idx < len(predictions):
                        token_prediction_id = predictions[token_idx]
                        if token_prediction_id != -100 and token_prediction_id < len(id_to_label):
                            word_level_labels[word_idx] = id_to_label[token_prediction_id]
                        elif token_prediction_id != -100:
                            word_level_labels[word_idx] = 'O'
            previous_word_idx = word_idx

        # Extract entities
        entities = []
        current_entity = None

        for idx, (word, label) in enumerate(zip(words, word_level_labels)):
            if label.startswith("B-"):
                if current_entity:
                    entities.append(current_entity)

                entity_type = label[2:]
                current_entity = {
                    "type": entity_type,
                    "value": word,
                    "start_idx": idx,
                    "end_idx": idx
                }

            elif label.startswith("I-") and current_entity and current_entity["type"] == label[2:]:
                current_entity["value"] += " " + word
                current_entity["end_idx"] = idx

            elif label == "O":
                if current_entity:
                    entities.append(current_entity)
                    current_entity = None

        if current_entity:
            entities.append(current_entity)

        return entities

    except Exception as e:
        logger.error(f"Error extracting entities: {str(e)}")
        return []

# Try to load model and tokenizer on module import
try:
    loaded_model, loaded_tokenizer = load_model()
except Exception as e:
    logger.error(f"Failed to initialize model: {str(e)}")
    loaded_model = None
    loaded_tokenizer = None 