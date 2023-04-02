from typing import List

from db.adapters.repositories.base import BaseRepository
from db.domain.models.user import User
from sqlalchemy import select


class UsersRepository(BaseRepository):
    async def list(self) -> List[User]:
        result = await self.session.execute(select(User))

        return result.scalars().all()

    async def create(self, username: str) -> User:
        instance = User(username=username)

        self.session.add(instance)
        await self.session.flush()
        await self.session.commit()

        return instance
