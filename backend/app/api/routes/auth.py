from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.dependencies import get_db
from app.schemas.auth import RegisterRequest, UserResponse,LoginRequest,LoginResponse
from app.services.auth_service import register_user, login_user

from app.models.user import User
from app.api.dependencies import get_current_user


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)

@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)

def register(
    data: RegisterRequest,
    db: Session = Depends(get_db),
):
    try:
        return register_user(db, data)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(exc),
        ) from exc

@router.post(
    "/login",
    response_model=LoginResponse,
    status_code=status.HTTP_200_OK,
)
def login(
    data: LoginRequest,
    db: Session = Depends(get_db),
):
    try:
        access_token = login_user(db, data)

        return LoginResponse(
            access_token=access_token,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(exc),
        )from exc


@router.get("/me", response_model=UserResponse)
def get_me(
    current_user: User = Depends(get_current_user),
):
    return current_user