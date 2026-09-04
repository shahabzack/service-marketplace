"""add admin role

Revision ID: 4fcdec8ccd7f
Revises: 296bdc286235
Create Date: 2026-09-04 11:13:19.303416

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '4fcdec8ccd7f'
down_revision: Union[str, Sequence[str], None] = '296bdc286235'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.execute("ALTER TYPE user_role ADD VALUE 'admin'")


def downgrade() -> None:
    """Downgrade schema."""
    pass
