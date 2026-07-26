# Implementation Plan - UAT-002 & UAT-003: Deep Authorization & Authentication Hardening

This plan addresses unauthorized farm creation via nested workflows (UAT-002) and a critical security flaw where disabled users can still log in or refresh sessions (UAT-003). We apply the **Defense-in-Depth** principle across UI, Router, and Application layers.

## User Review Required

> [!CRITICAL]
> **UAT-003** is a critical security fix. We are introducing mandatory `IsActive` checks in both the login and token refresh pipelines. This will immediately prevent disabled users from obtaining or extending sessions.

> [!IMPORTANT]
> **UAT-002** reinforces the Defense-in-Depth strategy. We are auditing and guarding all entry points to Farm creation, ensuring read-only roles cannot bypass visibility rules through nested navigation.

## Proposed Changes

### 1. Farm Creation Entry Points (UAT-002)

We will audit and secure every path leading to farm mutation.

#### [MODIFY] [FarmsListScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/farms_list_screen.dart)
- Guard the `floatingActionButton` (+) with `authService.canManageFarms()`.
- Ensure the button is completely removed from the widget tree for unauthorized users.

#### [MODIFY] [FarmerDetailsScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_details_screen.dart)
- *Investigation*: The "Farms" button at the bottom navigates to the list. This is allowed for Read-Only access.
- *Fix*: Ensure no direct "Add Farm" shortcut exists here that bypasses the list guard (none found currently, but will verify).

#### [VERIFY] [AppRouter](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/router/app_router.dart)
- Confirm `addFarm` and `editFarm` routes have the `redirect` guard using `AuthorizationService`.

#### [VERIFY] [OfflineFirstFarmRepository](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/data/offline_first_farm_repository.dart)
- Confirm `createFarm`, `updateFarm`, and `deleteFarm` explicitly check `_authService.canManageFarms()`.

---

### 2. Backend Authentication Hardening (UAT-003)

We will ensure the `IsActive` flag is a hard gate in the identity pipeline.

#### [MODIFY] [LoginCommandHandler](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Accounts/Commands/Login/LoginCommand.cs)
- Add `if (!user.IsActive)` check immediately after password validation.
- Return `Result.Failure` with "Your account is disabled. Please contact your administrator."

#### [MODIFY] [RefreshTokenCommandHandler](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Accounts/Commands/Refresh/RefreshTokenCommand.cs)
- Add `if (!user.IsActive)` check after retrieving the user for rotation.
- Return `Result.Failure`. This prevents a user who was disabled *after* their last login from extending their session.

---

### 3. Automated Regression Testing

#### [NEW] [farms_list_authorization_test.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/test/features/farms/farms_list_authorization_test.dart)
- Test: TechnicalReviewer cannot see the FAB (+) on the Farms list.
- Test: AgriculturalEngineer can see the FAB (+).

#### [MODIFY] [LoginCommandHandlerTests.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application.Tests/LoginCommandHandlerTests.cs)
- Test: Login fails for a user with `IsActive = false`.

#### [MODIFY] [RefreshTokenCommandHandlerTests.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application.Tests/RefreshTokenCommandHandlerTests.cs)
- Test: Token refresh fails for a user with `IsActive = false`.

## Verification Plan

### Automated Tests
- Run new/modified tests for both Mobile and Backend.
- Run full suite (`flutter test` and `dotnet test`) to ensure no regressions in existing auth/farm logic.

### Manual Verification
- **UAT-002**: Log in as `TechnicalReviewer`. Go to Farmer Details -> Farms. Verify the "+" button is missing.
- **UAT-003**:
    1. Manually set `IsActive = false` for a user in the database.
    2. Attempt login. Verify failure.
    3. Login as another user, get token, then set `IsActive = false` for that user. Attempt refresh. Verify failure.
