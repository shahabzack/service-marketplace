from sqlalchemy.orm import Session

from app.models.service import Service
from app.models.user import User


def create_service(
    db: Session,
    current_user: User,
    title: str,
    description: str,
    category: str,
    price: float,
) -> Service:
    service = Service(
        provider_id=current_user.id,
        title=title,
        description=description,
        category=category,
        price=price,
    )

    db.add(service)

    try:
        db.commit()
        db.refresh(service)
    except Exception:
        db.rollback()
        raise

    return service


def get_my_services(
    db: Session,
    current_user: User,
) -> list[Service]:
    return (
        db.query(Service)
        .filter(Service.provider_id == current_user.id)
        .order_by(Service.created_at.desc())
        .all()
    )