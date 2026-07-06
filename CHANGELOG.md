# Changelog

## [Unreleased] — Sprint 0: Security Hardening & Complete Authentication Subsystem

### Security
- Removed the committed JWT signing key from all configuration files; the key
  is now loaded only from environment variables or user secrets
  (`JwtSettings__Key`) and startup fails fast if it is missing or shorter than
  32 characters. **The previously committed key must be considered
  compromised and must not be reused.**
- Replaced the broken `${VAR}` placeholders in `appsettings.Production.json`
  (never substituted by .NET) with standard environment-variable
  configuration; Production now boots from environment variables alone.
- Seed admin account is no longer created unconditionally with hardcoded
  credentials; it is created only when `SeedAdmin__Email` and
  `SeedAdmin__Password` are configured.
- JWT validation now enforces issuer and audience; access-token lifetime
  reduced from 7 days to 60 minutes; zero clock skew;
  `RequireHttpsMetadata = true` outside Development.
- Login failures (unknown email, wrong password, lockout) now return a generic
  `401 Unauthorized` (previously `400`), preventing account enumeration.
- Auth endpoints rate limited: 10 requests/minute per client IP (`429`).
- Identity hardening: 12-character minimum password policy with complexity
  requirements; lockout after 5 failed attempts for 15 minutes.

### Added
- Persisted refresh tokens (`RefreshTokens` table, EF migration
  `AddRefreshTokens`): SHA-256 hashed storage, 14-day lifetime, rotation on
  every refresh, family revocation on token reuse, and revoke-on-logout.
- `POST /api/v1/accounts/refresh` and `POST /api/v1/accounts/logout` endpoints.
- `ITokenService` / `IRefreshTokenStore` abstractions with Infrastructure
  implementations; strongly-typed `JwtOptions`.
- `Hasad.Application.Tests` project (xUnit + NSubstitute): 14 tests covering
  the token service, refresh-token store, and login/refresh handlers.
- Architecture Decision Records `docs/adr/0001`–`0007`.
- `PROJECT_STATUS.md` living status document and a pull request template.

## [v0.2.0-alpha] - 2024-05-24
### Added
- Clean Architecture implementation for Backend (.NET 8) and Mobile (Flutter).
- Authentication system with JWT and Identity.
- Offline-first foundation and synchronization models.
- Environment configuration (Dev, Staging, Prod).
- Secure storage service for mobile.
- Comprehensive documentation (Architecture, Domain, Auth, Sync, Security).

## [v0.1.0-alpha] - 2024-05-23
### Added
- Initial project setup.
- Basic folder structure.
- Localization (Arabic/English).
- Theme configuration.
