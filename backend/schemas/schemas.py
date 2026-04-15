from pydantic import BaseModel, EmailStr
from datetime import datetime, date, time
from typing import Optional


class UserBase(BaseModel):
    full_name: str
    email: EmailStr
    age: Optional[int] = None
    weight: Optional[float] = None
    height: Optional[float] = None
    medical_history: Optional[str] = None
    activity_level: Optional[str] = None
    dietary_goal: Optional[str] = None
    diet_type: Optional[str] = None


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    age: Optional[int] = None
    weight: Optional[float] = None
    height: Optional[float] = None
    medical_history: Optional[str] = None
    activity_level: Optional[str] = None
    dietary_goal: Optional[str] = None
    diet_type: Optional[str] = None


class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class User(UserBase):
    id: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None


class MealBase(BaseModel):
    food: str
    calories: float
    protein: Optional[float] = None
    carbohydrates: Optional[float] = None
    fats: Optional[float] = None
    meal_time: Optional[datetime] = None
    eaten_at: Optional[datetime] = None


class MealCreate(MealBase):
    pass


class Meal(MealBase):
    id: int
    user_id: str

    class Config:
        from_attributes = True


class PhysicalActivityBase(BaseModel):
    activity_type: str
    duration_minutes: int
    calories_burned: Optional[float] = None
    activity_date: date


class PhysicalActivityCreate(PhysicalActivityBase):
    pass


class PhysicalActivity(PhysicalActivityBase):
    id: int
    user_id: str

    class Config:
        from_attributes = True


class MedicationReminderBase(BaseModel):
    medication_name: str
    dosage: Optional[str] = None
    reminder_time: time
    is_taken: Optional[bool] = False
    reminder_date: date


class MedicationReminderCreate(MedicationReminderBase):
    pass


class MedicationReminder(MedicationReminderBase):
    id: int
    user_id: str

    class Config:
        from_attributes = True
