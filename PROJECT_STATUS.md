# HASAD Project Status

> Living document — updated at the end of every sprint.

- **Current Version**: v0.3.0-alpha (first end-to-end login flow; prerelease published)
- **Current Sprint**: Sprint 3 — Testing & Code Coverage (in review)
- **Current Branch**: `sprint/3-testing-and-coverage`
- **Last Updated**: 2026-07-08

## Sprint 0 — COMPLETED
Complete production-ready authentication subsystem delivered and merged
(PR #31, tag `sprint-0`, GitHub Release published): secure configuration,
JWT hardening (issuer/audience, 1h tokens, externalized key), persisted
refresh tokens with rotation and family revocation, login hardening
(401 semantics, rate limiting, lockout), configurable seed admin.
Verification: unit tests, full auth E2E, both CI workflows green on the PR
and on `main` post-merge. Milestone closed (5/5 issues).

## Sprint 1 — COMPLETED
- MediatR pinned to 12.5.0 (Apache-2.0) per approved Option B (ADR 0008).
- C7 (#17): InMemory-safe database initialization with explicit
  migration/seeding logging and fail-fast error reporting.
- H1 (#18): migration history squashed into a single verified `InitialCreate`.
- H3 (#20): FluentValidation pipeline behavior + Login/Refresh/Logout
  validators; validation failures return `400` with error details.
- M2 (#25): ITokenService extraction verified complete (delivered in Sprint 0).
- Tests: 25 backend unit tests (11 added this sprint).
- Delivered via PR #33, tag `sprint-1`, GitHub Release published.

## Sprint 2 — COMPLETED
- C6 (#16): fail-fast `EnvironmentConfig` initialized in `main()` before
  `runApp()`; login-time crash eliminated.
- M1 (#24): LoginScreen rewritten — proper controller lifecycle, client-side
  validation, localized (en/ar) errors, loading state.
- M3 (#26): logout with server-side revocation, single-flight token refresh
  with rotation, transparent 401 retry via `AuthInterceptor`, session
  restoration on app start. (Drift sync-queue remains a post-remediation
  epic per the issue.)
- L3 (#30): auth-guarded GoRouter with `/login`, `/home`, splash, and
  auth-state-driven redirects.
- Tests: 22 mobile unit/widget tests + opt-in live E2E auth lifecycle test.
- Delivered via PR #34 (tag `sprint-2`, Release published) plus follow-up
  PR #35 hardening auth error handling against malformed backend payloads
  (fixes both post-merge review findings). First alpha tagged: `v0.3.0-alpha`.

## Sprint 3 — Testing & Code Coverage (this sprint)
- #19: expanded `Hasad.Application.Tests` — LogoutCommandHandler tests and
  DbInitializer seeding tests (roles idempotency, SuperAdmin creation/skip,
  password-policy failure); 31 backend tests total (6 added this sprint).
- #29: Flutter widget-test suite expanded — LoginScreen loading state and
  Arabic/RTL rendering + localized validation, HomeScreen (welcome, logout,
  RTL), and router auth-guard tests (splash hold, login redirect, session
  restoration to home, login navigation, logout return); 38 mobile tests
  total (11 added this sprint).
- No production code changes; tests only.

## Open Issues (remediation backlog)
- Sprint 4 (CI/CD Hardening): #22, #23
- Sprint 5 (Repository Cleanup): #21, #28
- Sprint 6 (Documentation Sync): #27

## Completed Issues
- Sprint 0: #11, #12, #13, #14, #15 — closed via PR #31.
- Sprint 1: #17, #18, #20, #25 — closed via PR #33.
- Sprint 2: #16, #24, #26, #30 — closed via PR #34 (+ hardening PR #35).
- Sprint 3: #19, #29 — closing via this sprint's PR.

## Current Risks
- Sessions issued before the JWT key rotation are invalidated (expected; users
  must log in again).
- Rate limiting is per-instance in-memory; multi-instance deployments need a
  distributed limiter (tracked for the production roadmap).

## Technical Debt
- No backend integration-test project yet (unit + live E2E coverage only;
  a dedicated WebApplicationFactory-based suite remains future work).
- Drift sync-queue (offline persistence) not implemented — post-remediation
  epic per issue #26.
- Junk files (`Class1.cs`, `build_output.txt`) outstanding (Sprint 5).

## CI Status
- Green: .NET CI and Flutter CI on `main` and on the Sprint 3 branch.

## Next Sprint
- Sprint 4 — CI/CD Hardening (requires explicit user approval).
