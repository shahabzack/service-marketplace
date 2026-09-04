from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.dependencies import get_current_user, require_role
from app.db.session import get_db
from app.models.user import User, UserRole
from app.schemas.provider import ProviderApplicationResponse
from app.services.provider_service import (
    create_provider_application,
    approve_provider_application,
    get_provider_application,
)


router = APIRouter(
    prefix="/provider",
    tags=["Provider"],
)


@router.post(
    "/apply",
    response_model=ProviderApplicationResponse,
    status_code=status.HTTP_201_CREATED,
)
def apply_as_provider(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        return create_provider_application(
            db,
            current_user,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(exc),
        ) from exc


@router.post(
    "/applications/{application_id}/approve",
    response_model=ProviderApplicationResponse,
)
def approve_application(
    application_id: UUID,
    admin_user: User = Depends(
        require_role(UserRole.ADMIN)
    ),
    db: Session = Depends(get_db),
):
    try:
        return approve_provider_application(
            db,
            application_id,
            admin_user,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

@router.get(
    "/status",
    response_model=ProviderApplicationResponse | None,
)
def provider_status(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return get_provider_application(
        db,
        current_user,
    )