from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from core import security
from models import models
from core.database import get_db
from schemas.schemas import User, UserUpdate

router = APIRouter()


@router.get("/profile", response_model=User)
def get_profile(email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur introuvable")
    return user


@router.put("/profile", response_model=User)
def update_profile(profile: UserUpdate, email: str = Depends(security.get_current_user_email), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur introuvable")

    for field, value in profile.dict(exclude_unset=True).items():
        setattr(user, field, value)
    db.commit()
    db.refresh(user)
    return user
