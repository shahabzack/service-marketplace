from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.models.provider_application import (
    ProviderApplication,
    ProviderApplicationStatus,
)
from app.models.user import User


def create_provider_application(
    db: Session,
    current_user: User,
) -> ProviderApplication:

    existing_application = (
        db.query(ProviderApplication)
        .filter(ProviderApplication.user_id == current_user.id)
        .first()
    )

    if existing_application:
        raise ValueError("Provider application already exists")

    application = ProviderApplication(
        user_id=current_user.id,
        status=ProviderApplicationStatus.PENDING,
    )

    db.add(application)

    try:
        db.commit()
        db.refresh(application)
    except Exception:
        db.rollback()
        raise

    return application


def approve_provider_application(
    db: Session,
    application_id,
    admin_user: User,
) -> ProviderApplication:

    application = (
        db.query(ProviderApplication)
        .filter(ProviderApplication.id == application_id)
        .first()
    )

    if not application:
        raise ValueError("Provider application not found")

    if application.status != ProviderApplicationStatus.PENDING:
        raise ValueError("Provider application is not pending")

    application.status = ProviderApplicationStatus.APPROVED
    application.reviewed_at = datetime.now(timezone.utc)
    application.reviewed_by = admin_user.id

    try:
        db.commit()
        db.refresh(application)
    except Exception:
        db.rollback()
        raise

    return application

def get_provider_application(
    db: Session,
    current_user: User,
) -> ProviderApplication | None:

    return (
        db.query(ProviderApplication)
        .filter(
            ProviderApplication.user_id == current_user.id
        )
        .first()
    )