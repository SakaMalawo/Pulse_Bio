from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from core import ids, security
from config.settings import settings
from models import models
from core.database import get_db
from schemas.schemas import ForgotPasswordRequest, Token, User, UserCreate

router = APIRouter()


@router.post("/register", response_model=User)
def register(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    existing_ids = {row[0] for row in db.query(models.User.id).all()}
    user_id = ids.generate_unique_user_id(existing_ids)
    hashed_password = security.get_password_hash(user.password)
    new_user = models.User(
        id=user_id,
        full_name=user.full_name,
        email=user.email,
        password=hashed_password,
        age=user.age,
        weight=user.weight,
        height=user.height,
        medical_history=user.medical_history,
        activity_level=user.activity_level,
        dietary_goal=user.dietary_goal,
        diet_type=user.diet_type,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@router.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == form_data.username).first()
    if not user or not security.verify_password(form_data.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/forgot-password")
def forgot_password(request: ForgotPasswordRequest):
    return {"message": "Si cet email existe, un lien de récupération a été envoyé."}
