from api.main import router as api_router
from db.adapters.orm import start_mappers
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware


def get_application() -> FastAPI:
    application = FastAPI()

    start_mappers()

    # Middleware settings
    application.add_middleware(
        CORSMiddleware,
        allow_origins=[
            "http://localhost:8000",
            "http://fargate-frontend-lb-c757335280cc1340.elb.us-east-1.amazonaws.com",
        ],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
        expose_headers=["*"],
    )

    application.include_router(api_router, prefix="/api")

    return application


app = get_application()
