from sqlalchemy import Column, BigInteger, Integer, String, DateTime, ForeignKey, Float, Text, Boolean, Time, Date
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from datetime import datetime

from models.base import Base


class User(Base):
    __tablename__ = "users"

    id = Column(String(12), primary_key=True, index=True, unique=True, nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password = Column(String(255), nullable=False)
    full_name = Column(String(255), nullable=True)
    age = Column(Integer, nullable=True)
    weight = Column(Float, nullable=True)
    height = Column(Float, nullable=True)
    medical_history = Column(Text, nullable=True)
    activity_level = Column(String(100), nullable=True)
    dietary_goal = Column(String(255), nullable=True)
    diet_type = Column(String(100), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=True)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=True)

    meals = relationship("Meal", back_populates="user")
    physical_activities = relationship("PhysicalActivity", back_populates="user")
    medication_reminders = relationship("MedicationReminder", back_populates="user")


class Meal(Base):
    __tablename__ = "meals"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(12), ForeignKey("users.id"), nullable=False)
    food_name = Column(String(255), nullable=False)
    calories = Column(Float, nullable=True)
    protein = Column(Float, nullable=True)
    carbohydrates = Column(Float, nullable=True)
    fats = Column(Float, nullable=True)
    meal_time = Column(DateTime, nullable=False, default=datetime.utcnow)
    eaten_at = Column(DateTime, nullable=True)
    food = Column(String(255), nullable=True)

    user = relationship("User", back_populates="meals")


class PhysicalActivity(Base):
    __tablename__ = "physical_activities"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(12), ForeignKey("users.id"), nullable=False)
    activity_type = Column(String(255), nullable=False)
    duration_minutes = Column(Integer, nullable=False)
    calories_burned = Column(Float, nullable=True)
    activity_date = Column(Date, nullable=False)

    user = relationship("User", back_populates="physical_activities")


class MedicationReminder(Base):
    __tablename__ = "medication_reminders"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(12), ForeignKey("users.id"), nullable=False)
    medication_name = Column(String(255), nullable=False)
    dosage = Column(String(100), nullable=True)
    reminder_time = Column(Time, nullable=False)
    is_taken = Column(Boolean, nullable=True, default=False)
    reminder_date = Column(Date, nullable=False)

    user = relationship("User", back_populates="medication_reminders")
