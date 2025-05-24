import logging
from typing import List, Dict, Any
from transformers import AutoTokenizer, AutoModelForTokenClassification
from ..config.settings import MODEL_PATH, HUGGINGFACE_TOKEN
import os

logger = logging.getLogger(__name__)

class EntityExtractor:
    def __init__(self):
        self.model = None
        self.tokenizer = None
        self._load_model()

    def _load_model(self) -> None:
        """Load the NER model and tokenizer."""
        try:
            if not os.path.exists(MODEL_PATH):
                logger.error(
                    f"Model not found at {MODEL_PATH}. "
                    "Please ensure the model files are present in the models directory."
                )
                return

            self.tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)
            self.model = AutoModelForTokenClassification.from_pretrained(MODEL_PATH)
            logger.info("Model and tokenizer loaded successfully")
        except Exception as e:
            logger.error(f"Error loading model: {str(e)}")
            self.model = None
            self.tokenizer = None

    def extract_entities(self, text: str) -> List[Dict[str, Any]]:
        """
        Extract entities from the given text using the NER model.
        
        Args:
            text (str): The input text to extract entities from
            
        Returns:
            List[Dict[str, Any]]: List of extracted entities with their types and positions
        """
        if not self.model or not self.tokenizer:
            logger.error("Model not loaded. Cannot extract entities.")
            return []

        try:
            # Tokenize the text
            inputs = self.tokenizer(
                text,
                return_tensors="pt",
                truncation=True,
                max_length=512,
                padding=True
            )

            # Get predictions
            outputs = self.model(**inputs)
            predictions = outputs.logits.argmax(dim=-1)

            # Convert predictions to entities
            entities = []
            current_entity = None

            for idx, (token, pred) in enumerate(zip(inputs["input_ids"][0], predictions[0])):
                token_text = self.tokenizer.decode([token])
                
                if pred != 0:  # Not O (Outside) tag
                    if current_entity is None:
                        current_entity = {
                            "text": token_text,
                            "type": self.model.config.id2label[pred.item()],
                            "start": idx,
                            "end": idx + 1
                        }
                    else:
                        current_entity["text"] += token_text
                        current_entity["end"] = idx + 1
                else:
                    if current_entity is not None:
                        entities.append(current_entity)
                        current_entity = None

            if current_entity is not None:
                entities.append(current_entity)

            return entities

        except Exception as e:
            logger.error(f"Error extracting entities: {str(e)}")
            return [] 