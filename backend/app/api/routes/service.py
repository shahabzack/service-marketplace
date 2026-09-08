from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.dependencies import require_approved_provider
from app.db.session import get_db
from app.models.user import User
from app.schemas.service import ServiceCreate, ServiceResponse
from app.services.service_service import (
    create_service,
    get_my_services,
)

router = APIRouter(
    prefix="/services",
    tags=["Services"],
)


@router.post(
    "",
    response_model=ServiceResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_my_service(
    data: ServiceCreate,
    current_user: User = Depends(require_approved_provider),
    db: Session = Depends(get_db),
):
    try:
        return create_service(
            db=db,
            current_user=current_user,
            title=data.title,
            description=data.description,
            category=data.category,
            price=data.price,
        )
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Unable to create service",
        ) from exc


@router.get(
    "/my",
    response_model=list[ServiceResponse],
)
def get_my_services_list(
    current_user: User = Depends(require_approved_provider),
    db: Session = Depends(get_db),
):
    return get_my_services(
        db=db,
        current_user=current_user,
    )