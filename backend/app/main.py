from fastapi import FastAPI
from app.api.routes.auth import router as auth_router
from app.api.routes import provider


app = FastAPI(title="Service Marketplace API")
app.include_router(auth_router)
app.include_router(provider.router)

@app.get("/")
def root():
    return {"message": "Service Marketplace API is running"}