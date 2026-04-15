from fastapi import APIRouter

from routes import activities, auth, meals, users

router = APIRouter(prefix="/api")
router.include_router(auth.router, prefix="/auth", tags=["auth"])
router.include_router(meals.router, prefix="/meals", tags=["meals"])
router.include_router(activities.router, prefix="/activities", tags=["activities"])
router.include_router(users.router, prefix="/users", tags=["users"])
