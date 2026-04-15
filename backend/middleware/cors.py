from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config.settings import settings


def configure_cors(app: FastAPI) -> None:
    # En développement, autoriser toutes les origines localhost
    if True:  # TODO: utiliser une variable d'environnement pour la prod
        app.add_middleware(
            CORSMiddleware,
            allow_origins=["*"],  # Permettre toutes les origines en développement
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )
    else:
        app.add_middleware(
            CORSMiddleware,
            allow_origins=settings.CORS_ORIGINS,
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )
