from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from .api.routes import router as qa_router
from .middleware.auth import verify_token

app = FastAPI(title="Diabetes Q&A Agent (LangChain)")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include router with authentication
app.include_router(qa_router, prefix="/qa", tags=["Q&A"], dependencies=[Depends(verify_token)])

@app.get("/")
async def root():
    return {"message": "Diabetes Q&A Agent (LangChain)"} 