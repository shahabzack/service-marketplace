from datetime import datetime
from uuid import UUID

from pydantic import BaseModel

from app.models.provider_application import ProviderApplicationStatus


class ProviderApplicationCreate(BaseModel):
    pass


class ProviderApplicationResponse(BaseModel):
    id: UUID
    user_id: UUID
    status: ProviderApplicationStatus
    submitted_at: datetime
    reviewed_at: datetime | None
    reviewed_by: UUID | None

    model_config = {
        "from_attributes": True,
    }