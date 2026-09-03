from sqlalchemy.orm import Session

from app.models.user import User
from app.schemas.auth import RegisterRequest,LoginRequest
from app.core.security import hash_password,create_access_token,verify_password


def register_user(db: Session, data: RegisterRequest) -> User:
    existing_email = db.query(User).filter(
    User.email == data.email
).first()

    if existing_email:
        raise ValueError("Email already registered")

    existing_phone = db.query(User).filter(
    User.phone == data.phone
).first()

    if existing_phone:
        raise ValueError("Phone already registered")
    
    password_hash = hash_password(data.password)

    

    user = User(
    name=data.name,
    email=data.email,
    phone=data.phone,
    password_hash=password_hash,
)
    db.add(user)
    try:
        db.commit()
        db.refresh(user)
    except Exception:
        db.rollback()
        raise
    return user


def login_user(db: Session, data: LoginRequest) -> str:
    user = db.query(User).filter(
    User.email == data.email
).first()

    if not user:
        raise ValueError("Invalid email or password")

    if not verify_password(data.password, user.password_hash):
        raise ValueError("Invalid email or password")

    if not user.is_active:
        raise ValueError("Account is inactive")

    access_token = create_access_token(
        user_id =str(user.id)
    )

    return access_token
    