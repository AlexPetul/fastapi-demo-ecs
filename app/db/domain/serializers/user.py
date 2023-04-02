from pydantic import constr
from pydantic.main import BaseModel


class UserCreate(BaseModel):
    username: constr(max_length=80)

    class Config:
        orm_mode = True


class UserDetailed(UserCreate):
    id: int

    class Config:
        orm_mode = True
