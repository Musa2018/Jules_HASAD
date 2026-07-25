# Implementation Plan - UAT-001: Farm Creation Authorization Guard

This plan addresses the unauthorized access to farm creation from the `FarmerCard` for roles like `TechnicalReviewer` and `FieldSurveyor`.

## User Review Required

> [!IMPORTANT]
> This change strictly enforces the Authorization Matrix defined in the UAT baseline. Roles designated as "Read Only" for Farms (FieldSurveyor, TechnicalReviewer) will lose access to creation and editing UI components and routes.

## Proposed Changes

### Core Authorization
#### [MODIFY] [authorization_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/auth/authorization_service.dart)
- Update `canManageFarms()` to include `FieldSurveyor` and `TechnicalReviewer` in the `restrictedRoles` list. This aligns the service with the UAT Authorization Matrix.

### Domain & Repository
#### [MODIFY] [farm_validator.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/domain/farm_validator.dart)
- Add a permission check in `validate()` to ensure the user's role is authorized to perform mutations. If the role is restricted, add an "Access Denied" error message.

### UI Components
#### [MODIFY] [farmer_card.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/widgets/farmer_card.dart)
- Wrap the "Add Farm" button (`AppRoutes.addFarm`) with `if (authService.canManageFarms())`.

### Navigation
#### [MODIFY] [app_router.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/router/app_router.dart)
- Implement route-level guards for `addFarm` and `editFarm` routes.
- Use `ref.read(authorizationServiceProvider)` within the router's `redirect` logic or the route's `builder` to block unauthorized access and redirect to a safe location (e.g., home or details screen with a message).

## Verification Plan

### Automated Tests
- Create `farm_authorization_test.dart` to verify:
    - `AuthorizationService` correctly identifies restricted roles.
    - `FarmValidator` blocks creation for unauthorized roles.
    - `FarmerCard` hides the "Add Farm" button for unauthorized roles.
    - Router blocks direct navigation to `/farms/add` for unauthorized roles.

### Manual Verification
- Log in as a `TechnicalReviewer`.
- Navigate to the Farmers list.
- Verify that the "Add Farm" button is NOT visible on any `FarmerCard`.
- Attempt to manually navigate to `/farms/add` (if possible via deep link or console) and verify redirection/blocking.
- Repeat for `FieldSurveyor` role.
- Log in as `AgriculturalEngineer` and verify the button IS visible and functional.
