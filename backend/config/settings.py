from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    DATABASE_URL: str
    SECRET_KEY: str = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 1440
    CORS_ORIGINS: List[str] = [
        "http://localhost:52181",
        "http://127.0.0.1:52181",
        "http://localhost:56659",
        "http://127.0.0.1:56659",
        "http://localhost:8000",
        "http://127.0.0.1:8000",
        "https://localhost:56659",
        "https://127.0.0.1:56659",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://10.0.2.2:8000",
        "http://localhost:54610",
        "http://127.0.0.1:54610",
        # Ports Flutter web communs
        "http://localhost:3000",
        "http://localhost:8080",
        "http://localhost:5500",
        "http://localhost:5000",
        "http://localhost:4000",
        "http://localhost:9000",
    ]

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()
