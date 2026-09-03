from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

from datetime import datetime, timedelta, timezone

import jwt

from app.core.config import settings


password_hasher = PasswordHasher()

def hash_password(password: str) -> str:
    return password_hasher.hash(password)

def verify_password(password:str,password_hash: str) ->bool:
    try:
        return password_hasher.verify(password_hash,password)
    except VerifyMismatchError:
        return False
    

def create_access_token(user_id: str) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )

    payload = {
        "sub": user_id,
        "exp": expires_at,
    }

    return jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm,
    )


def verify_access_token(token: str) -> dict:
    try:
        payload = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm],
        )
        return payload
    except jwt.InvalidTokenError:
        raise ValueError("Invalid or expired access token")

    
    