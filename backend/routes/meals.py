from datetime import datetime
from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core import security
from models import models
from core.database import get_db
from schemas.schemas import Meal, MealCreate

router = APIRouter()


@router.get("/", response_model=List[Meal])
def get_meals(email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    return db.query(models.Meal).filter(models.Meal.user_id == user.id).all()


@router.post("/", response_model=Meal)
def add_meal(meal: MealCreate, email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    new_meal = models.Meal(
        food_name=meal.food,
        food=meal.food,
        calories=meal.calories,
        protein=meal.protein,
        carbohydrates=meal.carbohydrates,
        fats=meal.fats,
        meal_time=meal.meal_time or datetime.utcnow(),
        eaten_at=meal.eaten_at or datetime.utcnow(),
        user_id=user.id,
    )
    db.add(new_meal)
    db.commit()
    db.refresh(new_meal)
    return new_meal
