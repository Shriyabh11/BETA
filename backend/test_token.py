import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get token
token = os.getenv("HUGGINGFACE_TOKEN")

if token:
    print("✅ Hugging Face token found!")
    print(f"Token starts with: {token[:4]}...")
else:
    print("❌ Hugging Face token not found!")
    print("Please add your token to the .env file") 