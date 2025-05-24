import google.generativeai as genai
import os
from dotenv import load_dotenv

# Set your Gemini API key directly here

genai.configure(api_key=API_KEY)

model = genai.GenerativeModel("models/gemini-1.5-flash-latest")
  # or "gemini-pro-vision" if using images

SYSTEM_PROMPT = """
You are an empathetic mental health assistant specializing in support for Type 1 diabetics.
Respond with care, avoid clinical diagnoses, and encourage self-care and reflection.
"""

def get_context():
    return [
        {
            "role": "user",
            "parts": [{"text": SYSTEM_PROMPT}]
        }
    ]

chat = model.start_chat(history=get_context())

def get_memory_response(context, query):
    try:
        prompt = f"Context: {context}\nQuestion: {query}"
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        raise Exception(f"Error generating memory response: {str(e)}")

