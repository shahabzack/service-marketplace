from app.db.session import SessionLocal
from app.models.user import User


db = SessionLocal()

user = db.query(User).filter(
    (User.email == "testuser@example.com") |
    (User.phone == "9876543210")
).first()

print(user)

db.close()