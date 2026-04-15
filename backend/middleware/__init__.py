from fastapi import FastAPI

from .cors import configure_cors


def configure_middlewares(app: FastAPI) -> None:
    configure_cors(app)
