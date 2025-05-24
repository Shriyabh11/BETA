from fastapi import HTTPException, Request
# from ..config.firebase_config import verify_firebase_token

async def verify_token(request: Request):
    """
    Simple token verification that accepts any Bearer token for testing.
    In production, this should be replaced with proper authentication.
    """
    auth_header = request.headers.get('Authorization')
    
    # For testing, accept any Bearer token or no token at all
    if not auth_header:
        return {"uid": "test_user"}  # Allow requests without auth header for testing
        
    if not auth_header.startswith('Bearer '):
        raise HTTPException(status_code=401, detail='Invalid authorization header format')
    
    # For testing, accept any token
    return {"uid": "test_user"}

# security = HTTPBearer()

# async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
#     """
#     Verify Firebase token and return user info.
#     
#     Args:
#         credentials: HTTP authorization credentials containing the token
#         
#     Returns:
#         dict: User information from the token
#         
#     Raises:
#         HTTPException: If token is invalid or missing
#     """
#     try:
#         token = credentials.credentials
#         user = await verify_firebase_token(token)
#         return user
#     except Exception as e:
#         raise HTTPException(
#             status_code=401,
#             detail="Invalid authentication credentials"
#         ) 