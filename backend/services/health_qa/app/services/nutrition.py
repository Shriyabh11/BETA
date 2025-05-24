import pandas as pd
import os

FOOD_DB_PATH = os.path.join(os.path.dirname(__file__), '../data/food_database.csv')

# Simple food extraction (for demo)
def extract_food(query):
    words = query.lower().split()
    # In real use, use NLP/NER
    for word in words:
        if word in ["rice", "bread", "banana", "apple", "potato", "soda", "juice", "candy"]:
            return word
    return None

def answer_nutrition(query):
    food = extract_food(query)
    if not food:
        return ("Sorry, I couldn't identify a food in your question.", "nutrition-extract-fail")
    # Try local DB (stub: always miss)
    # Try CSV
    try:
        df = pd.read_csv(FOOD_DB_PATH)
        row = df[df['food'].str.lower() == food]
        if not row.empty:
            gi = row.iloc[0]['gi']
            if gi >= 70:
                advice = f"{food.title()} has a high glycemic index ({gi}). It's best avoided for diabetics."
            elif gi >= 56:
                advice = f"{food.title()} has a medium glycemic index ({gi}). Consume in moderation."
            else:
                advice = f"{food.title()} has a low glycemic index ({gi}). It's generally safe for diabetics."
            return (advice, "nutrition-csv")
        else:
            return (f"I couldn't find {food} in the database. Please consult a nutritionist.", "nutrition-not-found")
    except Exception as e:
        return (f"Nutrition database error: {str(e)}", "nutrition-db-error") 