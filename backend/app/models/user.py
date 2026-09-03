from datetime import datetime,timezone

from sqlalchemy import Boolean, DateTime,Enum, String
from sqlalchemy.orm import Mapped, mapped_column
from uuid import UUID, uuid4

from sqlalchemy import Uuid
from app.db.base import Base
from enum import Enum as PyEnum


class UserRole(str, PyEnum):
    CUSTOMER = "customer"
    PROVIDER = "provider"

class User(Base):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(
    Uuid,
    primary_key=True,
    default=uuid4,
)
    name: Mapped[str] = mapped_column(
    String(100),
    nullable=False,
)
    email: Mapped[str] = mapped_column(
    String(255),
    unique=True,
    nullable=False,
)
    phone: Mapped[str] = mapped_column(
    String(20),
    unique=True,
    nullable=False,
)
    password_hash: Mapped[str] = mapped_column(
    String(255),
    nullable=False,
)
    role: Mapped[str] = mapped_column(
    Enum(UserRole, name="user_role"),
    nullable=False,
    default=UserRole.CUSTOMER,
)
    is_active: Mapped[bool] = mapped_column(
    Boolean,
    nullable=False,
    default=True,
)
    created_at: Mapped[datetime] = mapped_column(
    DateTime(timezone=True),
    nullable=False,
    default=lambda: datetime.now(timezone.utc),
)

    updated_at: Mapped[datetime] = mapped_column(
    DateTime(timezone=True),
    nullable=False,
    default=lambda: datetime.now(timezone.utc),
    onupdate=lambda: datetime.now(timezone.utc)
    )


    