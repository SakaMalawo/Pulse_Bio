from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from core import security
from models import models
from core.database import get_db
from schemas.schemas import PhysicalActivity, PhysicalActivityCreate

router = APIRouter()


@router.get("/", response_model=List[PhysicalActivity])
def get_activities(email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    return db.query(models.PhysicalActivity).filter(models.PhysicalActivity.user_id == user.id).all()


@router.post("/", response_model=PhysicalActivity)
def add_activity(activity: PhysicalActivityCreate, email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    new_activity = models.PhysicalActivity(**activity.dict(), user_id=user.id)
    db.add(new_activity)
    db.commit()
    db.refresh(new_activity)
    return new_activity
