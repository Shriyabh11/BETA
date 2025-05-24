import google.generativeai as genai
from .memory import get_context


genai.configure(api_key=API_KEY)

model = genai.GenerativeModel("models/gemini-1.5-flash-latest")
chat = model.start_chat(history=get_context())  # maintains context

def get_gemini_response(query: str) -> str:
    try:
        prompt = f"You are a helpful diabetes assistant. Question: {query}"
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        raise Exception(f"Error generating response: {str(e)}")
