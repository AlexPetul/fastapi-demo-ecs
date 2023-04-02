from typing import Callable, Type

from db.adapters.repositories.base import BaseRepository
from db.config import get_session
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession


def get_repository(repo_type: Type[BaseRepository]) -> Callable[[AsyncSession], BaseRepository]:
    def _get_repo(conn: AsyncSession = Depends(get_session)) -> BaseRepository:
        return repo_type(conn)

    return _get_repo
