from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field, ConfigDict


class ServiceCreate(BaseModel):
    title: str = Field(min_length=2, max_length=150)
    description: str = Field(min_length=10)
    category: str = Field(min_length=2, max_length=100)
    price: float = Field(gt=0)


class ServiceResponse(BaseModel):
    id: UUID
    provider_id: UUID
    title: str
    description: str
    category: str
    price: float
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)