from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel
from typing import Dict
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI(title="Keyra API Server")

# Simulated API key storage (in production, use a database)
API_KEYS = {
    "books_api_key": os.getenv("BOOKS_API_KEY", "default_key"),
    # Add other API keys as needed
}

# Basic security setup
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

class ApiKeyResponse(BaseModel):
    key: str
    service: str

@app.get("/")
async def root():
    return {"message": "Welcome to Keyra API Server"}

@app.get("/api/keys/{service_name}", response_model=ApiKeyResponse)
async def get_api_key(service_name: str, token: str = Depends(oauth2_scheme)):
    """
    Get API key for a specific service.
    In production, implement proper authentication and authorization.
    """
    if service_name not in API_KEYS:
        raise HTTPException(status_code=404, detail="Service not found")
    
    return ApiKeyResponse(
        key=API_KEYS[service_name],
        service=service_name
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
