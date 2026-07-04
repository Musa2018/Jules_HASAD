# HASAD - Authentication Documentation

## Overview
Secure authentication system supporting offline access via cached credentials.

## Backend Logic
- **Identity**: ASP.NET Core Identity with PostgreSQL.
- **JWT**: JSON Web Tokens for API authorization.
- **Refresh Tokens**: Long-lived tokens for session persistence.
- **Roles**: SuperAdmin, Administrator, AgriculturalEngineer, FieldSurveyor, Farmer, ReadOnly.

## Mobile Logic
- **Secure Storage**: `flutter_secure_storage` for tokens and sensitive data.
- **Auto-Login**: Application checks for valid local tokens on startup.
- **Biometrics**: Architecture supports biometric unlock (FaceID/Fingerprint).
