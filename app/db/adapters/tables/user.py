# Base user model declaration
from db.adapters.meta import metadata
from sqlalchemy import Column, Integer, String, Table


user_table = Table(
    "user",
    metadata,
    Column("id", Integer, primary_key=True, autoincrement=True),
    Column("username", String(80), unique=True, index=True, nullable=False),
)
