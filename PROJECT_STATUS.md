# HASAD Project Status

> Living document — updated at the end of every sprint.

- **Current Version**: v0.2.0-alpha (next: v0.3.0-alpha after Sprint 2, per release strategy)
- **Current Sprint**: Sprint 1 — Backend Stabilization (in review)
- **Current Branch**: `sprint/1-backend-stabilization`
- **Last Updated**: 2026-07-06

## Sprint 0 — COMPLETED
Complete production-ready authentication subsystem delivered and merged
(PR #31, tag `sprint-0`, GitHub Release published): secure configuration,
JWT hardening (issuer/audience, 1h tokens, externalized key), persisted
refresh tokens with rotation and family revocation, login hardening
(401 semantics, rate limiting, lockout), configurable seed admin.
Verification: unit tests, full auth E2E, both CI workflows green on the PR
and on `main` post-merge. Milestone closed (5/5 issues).

## Sprint 1 — Backend Stabilization (this sprint)
- MediatR pinned to 12.5.0 (Apache-2.0) per approved Option B (ADR 0008).
- C7 (#17): InMemory-safe database initialization with explicit
  migration/seeding logging and fail-fast error reporting.
- H1 (#18): migration history squashed into a single verified `InitialCreate`.
- H3 (#20): FluentValidation pipeline behavior + Login/Refresh/Logout
  validators; validation failures return `400` with error details.
- M2 (#25): ITokenService extraction verified complete (delivered in Sprint 0).
- Tests: 25 backend unit tests (11 added this sprint).

## Open Issues (remediation backlog)
- Sprint 2 (Flutter Stabilization): #16, #24, #26, #30
- Sprint 3 (Testing & Coverage): #19, #29
- Sprint 4 (CI/CD Hardening): #22, #23
- Sprint 5 (Repository Cleanup): #21, #28
- Sprint 6 (Documentation Sync): #27

## Completed Issues
- Sprint 0: #11, #12, #13, #14, #15 — closed via PR #31.
- Sprint 1: #17, #18, #20, #25 — closing via this sprint's PR.

## Current Risks
- Sessions issued before the JWT key rotation are invalidated (expected; users
  must log in again).
- Rate limiting is per-instance in-memory; multi-instance deployments need a
  distributed limiter (tracked for the production roadmap).

## Technical Debt
- No backend integration-test project yet (Sprint 3).
- Mobile `EnvironmentConfig` late-initialization crash outstanding (Sprint 2, #16).
- Mobile refresh-token flow not yet wired to the new endpoints (Sprint 2).
- Junk files (`Class1.cs`, `build_output.txt`) outstanding (Sprint 5).

## CI Status
- Green: .NET CI and Flutter CI on `main` and on the Sprint 1 branch.

## Next Sprint
- Sprint 2 — Flutter Stabilization (requires explicit user approval).
