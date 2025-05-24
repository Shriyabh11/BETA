from langchain_google_genai import GoogleGenerativeAI
from langchain.memory import ConversationBufferMemory

llm = GoogleGenerativeAI(model="models/gemini-1.5-flash-latest", google_api_key=API_KEY)

# Simple in-memory session memory (dict keyed by session_id)
_session_memories = {}

def get_memory(session_id: str):
    if session_id not in _session_memories:
        _session_memories[session_id] = ConversationBufferMemory()
    return _session_memories[session_id]

def save_to_memory(session_id: str, user_input: str, answer: str):
    memory = get_memory(session_id)
    memory.save_context({"input": user_input}, {"output": answer})

def get_history(session_id: str):
    memory = get_memory(session_id)
    return memory.load_memory_variables({})["history"]

def get_gemini_response(query: str, session_id: str = None) -> str:
    """
    Get a response from Gemini for a user query
    Args:
        query: The user's question
        session_id: The session ID
    Returns:
        The model's response
    """
    try:
        # Simple welcome message for first interaction
        if not query or query.strip().lower() in ['hi', 'hello', 'hey', '']:
            return (
                "Hi! I'm your diabetes assistant. I can help you with blood sugar management, "
                "nutrition, exercise, medications, and general diabetes care. What would you like to know? "
                "Remember to consult your healthcare provider for medical advice."
            )

        # Build context-aware prompt
        prompt = "You are a helpful and friendly diabetes assistant. "
        
        if session_id:
            history = get_history(session_id)
            if history:
                prompt += f"\n\nPrevious conversation:\n{history}"
                prompt += "\n\nBased on our conversation so far, "
            else:
                prompt += "\n\n"
        else:
            prompt += "\n\n"

        prompt += f"User: {query}\n\nAssistant:"
        response = llm.invoke(prompt)
        return response
    except Exception as e:
        raise Exception(f"Error generating response: {str(e)}")

def paraphrase(text: str, mode: str = "query", session_id: str = None) -> str:
    prompt = ""
    if mode == "query":
        prompt = (
            "Rephrase this question to be clear and conversational, "
            "while keeping the main point: {text}"
        )
    else:
        prompt = (
            "Make this answer friendly and easy to understand, "
            "while keeping it accurate: {text}"
        )
    if session_id:
        history = get_history(session_id)
        if history:
            prompt = f"Previous conversation:\n{history}\n\n{prompt}"
    return llm.invoke(prompt).strip() 