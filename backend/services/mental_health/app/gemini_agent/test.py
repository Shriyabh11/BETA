import google.generativeai as genai

genai.configure(api_key=API_KEY)

for model in genai.list_models():
    print(model.name, model.supported_generation_methods)
