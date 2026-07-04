# Architecture Documentation

## Technology Stack

### Backend
- **Framework:** .NET 8 LTS
- **Architecture:** Clean Architecture
- **Patterns:** CQRS (MediatR), Repository Pattern
- **Database:** PostgreSQL with EF Core
- **API:** RESTful with Swagger/OpenAPI

### Mobile
- **Framework:** Flutter (Material 3)
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **Local DB:** Drift (SQLite)
- **Networking:** Dio

## Project Organization

The project follows a Clean Architecture approach:
- **Domain:** Enterprise logic and entities.
- **Application:** Application-specific business rules.
- **Infrastructure:** External concerns (Database, Identity).
- **Api:** Entry point and controllers.
