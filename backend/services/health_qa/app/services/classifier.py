from langchain_google_genai import GoogleGenerativeAI

import os



llm = GoogleGenerativeAI(model="models/gemini-1.5-flash-latest", google_api_key=API_KEY)

CLASSIFY_PROMPT = (
    "Hey! I need your help categorizing this question about diabetes. "
    "Could you tell me if it's mainly about 'nutrition' (like food, diet, or eating habits), "
    "'general_health' (like symptoms, medications, or general diabetes management), "
    "or 'other' (anything else)? Just respond with the category name.\n"
    "Here's the question: {query}"
)

def classify_query(query: str) -> str:
    prompt = CLASSIFY_PROMPT.format(query=query)
    result = llm(prompt).strip().lower()
    # Clean up and ensure only allowed categories are returned
    if "nutrition" in result:
        return "nutrition"
    elif "general_health" in result or "general health" in result:
        return "general_health"
    else:
        return "other" 