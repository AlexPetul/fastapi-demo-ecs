from typing import List

from api.dependencies.database import get_repository
from db.adapters.repositories.users import UsersRepository
from db.domain.serializers.user import UserDetailed, UserCreate
from fastapi import APIRouter, Depends, Body

router = APIRouter()


@router.get(path="", name="users:list", response_model=List[UserDetailed])
async def get_users(users_repository: UsersRepository = Depends(get_repository(UsersRepository))):
    return await users_repository.list()


@router.post(path="", name="users:create", response_model=UserDetailed)
async def create_user(
    data: UserCreate = Body(),
    users_repository: UsersRepository = Depends(get_repository(UsersRepository))
):
    return await users_repository.create(data.username)
