from fastapi import FastAPI, Response
from sqlalchemy.exc import OperationalError

from core.database import engine
from models.base import Base
from routes.api import router as api_router
from middleware import configure_middlewares

app = FastAPI(title="BioPulse API")

configure_middlewares(app)
app.include_router(api_router)


@app.on_event("startup")
async def on_startup():
    try:
        Base.metadata.create_all(bind=engine)
    except OperationalError as exc:
        raise RuntimeError(
            "Database startup failed. Check backend/.env or DATABASE_URL: \n"
            "- Provide a valid MySQL URL with username/password.\n"
            "- Example: mysql+pymysql://root:password@localhost:3306/bio_pulse"
        ) from exc


@app.options("/api/{path:path}", include_in_schema=False)
async def preflight(path: str):
    return Response(status_code=200)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
