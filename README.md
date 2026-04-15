# BioPulse - Application de Suivi Nutritionnel

BioPulse est une application moderne de suivi nutritionnel permettant aux utilisateurs de gérer leur alimentation quotidienne. Cette version a été reconstruite avec un frontend **Flutter** et un backend **FastAPI**.

## Architecture

- **Frontend** : Flutter (Compatible Windows, Android, iOS, macOS)
- **Backend** : FastAPI (Python 3.11+)
- **Base de données** : SQLite (par défaut) ou MySQL

## Fonctionnalités

- **Authentification** : Inscription et connexion sécurisées via JWT.
- **Gestion des repas** : Ajout et consultation des repas avec calcul des calories.
- **Multi-plateforme** : Une seule base de code pour mobile et bureau.

## Installation

### Backend (FastAPI)

1. Allez dans le dossier `backend` :
   ```bash
   cd backend
   ```
2. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```
3. Lancez le serveur :
   ```bash
   python main.py
   ```
   Le serveur sera accessible sur `http://localhost:8000`.

### Frontend (Flutter)

1. Allez dans le dossier `frontend` :
   ```bash
   cd frontend
   ```
2. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```
3. Lancez l'application :
   ```bash
   flutter run
   ```

## Sécurité

- Les mots de passe sont hashés avec **BCrypt**.
- L'authentification est gérée par des tokens **JWT** (JSON Web Tokens) avec une expiration de 24 heures.
- Les endpoints des repas sont protégés et nécessitent une authentification.
