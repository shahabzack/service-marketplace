from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.dependencies import get_db
from app.schemas.auth import RegisterRequest, UserResponse,LoginRequest,LoginResponse
from app.services.auth_service import register_user, login_user

from app.models.user import User,UserRole
from app.models.provider_application import ProviderApplication
from app.db.session import get_db
from app.api.dependencies import get_current_user,require_role


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
    db: Session = Depends(get_db),
):
    application = (
        db.query(ProviderApplication)
        .filter(
            ProviderApplication.user_id == current_user.id
        )
        .first()
    )

    return {
        "id": current_user.id,
        "name": current_user.name,
        "email": current_user.email,
        "phone": current_user.phone,
        "role": current_user.role,
        "is_active": current_user.is_active,
        "provider_status": (
            application.status.value
            if application
            else None
        ),
    }

@router.get("/customer-test")
def customer_test(
    current_user: User = Depends(
        require_role(UserRole.CUSTOMER)
    ),
):
    return {
        "message": "Customer access granted",
        "user_id": str(current_user.id),
        "role": current_user.role,
    }


@router.get("/provider-test")
def provider_test(
    current_user: User = Depends(
        require_role(UserRole.PROVIDER)
    ),
):
    return {
        "message": "Provider access granted",
        "user_id": str(current_user.id),
        "role": current_user.role,
    }


@router.get("/admin-test")
def admin_test(
    current_user: User = Depends(
        require_role(UserRole.ADMIN)
    ),
):
    return {
        "message": "Admin access granted",
        "user_id": str(current_user.id),
        "role": current_user.role,
    }