from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .api.routes import router as mental_health_router
from .utils.error_handlers import setup_exception_handlers

app = FastAPI(title="Diabetes Assistant API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(mental_health_router, prefix="/mental-health", tags=["Mental Health"])

# Setup exception handlers
setup_exception_handlers(app)

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
