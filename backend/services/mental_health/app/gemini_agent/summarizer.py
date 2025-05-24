import google.generativeai as genai
import os
from dotenv import load_dotenv


genai.configure(api_key=API_KEY)

model = genai.GenerativeModel("models/gemini-1.5-pro-latest")


def generate_summary(logs):
    try:
        prompt = f"Summarize the following logs: {logs}"
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        raise Exception(f"Error generating summary: {str(e)}")
