# HASAD Project Status

> Living document — updated at the end of every sprint.

- **Current Version**: v0.2.0-alpha (next: v0.3.0-alpha after Sprint 2, per release strategy)
- **Current Sprint**: Sprint 0 COMPLETED (merged, tag `sprint-0`); Sprint 1 awaiting approval
- **Current Branch**: `main` (stable baseline at merge commit `3a2c416`)
- **Last Updated**: 2026-07-06

## Sprint 0 — COMPLETED
Complete production-ready authentication subsystem delivered and merged
(PR #31, tag `sprint-0`, GitHub Release published): secure configuration,
JWT hardening (issuer/audience, 1h tokens, externalized key), persisted
refresh tokens with rotation and family revocation, login hardening
(401 semantics, rate limiting, lockout), configurable seed admin.
Verification: 14/14 unit tests, full auth E2E, both CI workflows green on
the PR and on `main` post-merge.

## Open Issues (remediation backlog)
- Sprint 1 (Backend Stabilization): #16, #17, #18, #25
- Sprint 2 (Flutter Stabilization): #19, #20, #21
- Sprint 3 (Testing & Coverage): #22, #23
- Sprint 4 (CI/CD Hardening): #24, #26
- Sprint 5 (Repository Cleanup): #27, #28
- Sprint 6 (Documentation Sync): #29, #30

## Completed Issues
- Sprint 0: #11, #12, #13, #14, #15 — closed via PR #31.

## Current Risks
- Sessions issued before the JWT key rotation are invalidated (expected; users
  must log in again).
- Rate limiting is per-instance in-memory; multi-instance deployments need a
  distributed limiter (tracked for the production roadmap).
- MediatR licensing decision (Option A/B/C) still pending — required before
  Sprint 1.

## Technical Debt
- No backend integration-test project yet (Sprint 3).
- Mobile `EnvironmentConfig` late-initialization crash outstanding (Sprint 2, #19).
- `MigrateAsync` vs InMemory provider seeding issue outstanding (Sprint 1, #16).
- Junk files (`Class1.cs`, `build_output.txt`) outstanding (Sprint 5).

## CI Status
- Green: .NET CI and Flutter CI passing on `main` (post-merge run).

## Next Sprint
- Sprint 1 — Backend Stabilization (requires user approval and the MediatR
  licensing decision).
