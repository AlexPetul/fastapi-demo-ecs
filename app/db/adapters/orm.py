from db.adapters.meta import metadata
from db.adapters.tables.user import user_table
from db.domain.models.user import User
from sqlalchemy.orm import clear_mappers, registry


mapper_registry = registry(metadata=metadata)


def start_mappers():
    # Clear existing mappers, useful for testing
    clear_mappers()

    mapper_registry.map_imperatively(User, user_table)
