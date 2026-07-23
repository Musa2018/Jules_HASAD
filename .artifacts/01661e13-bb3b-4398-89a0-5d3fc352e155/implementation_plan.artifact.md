# Implementation Plan: Fix Governorate Dropdown Regression

The regression was caused by a mismatch between the Backend DTOs and the Flutter Domain Models after the Farm module implementation added the `code` requirement to Governorates. Additionally, some geographic endpoints were restricted to `SuperAdmin` only, which breaks functionality for other roles.

## User Review Required

> [!IMPORTANT]
> The geographic hierarchy was moved to a shared `LocationController`. The `UsersController` geographic endpoints will be deprecated or redirected to ensure consistency.

## Proposed Changes

### Backend: Hasad.Application & Hasad.Api

#### [MODIFY] [GovernorateDto.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Users/Models/GovernorateDto.cs)
- Add `public string Code { get; set; } = string.Empty;`

#### [MODIFY] [GetGovernoratesQueryHandler.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Location/Queries/GetGovernorates/GetGovernoratesQuery.cs)
- Select the `Code` property in the projection: `Code = g.Code`.

#### [MODIFY] [LocationController.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Api/Controllers/LocationController.cs)
- Add `GetDirectorates` endpoint to allow all authenticated users to fetch directorates.
- This endpoint will call `GetDirectoratesQuery` from the Location features.

#### [DELETE] Redundant Queries in Users Feature
- Remove `GetGovernorates` and `GetDirectorates` from `Hasad.Application/Features/Users/Queries/` to avoid duplication.
- Update `UsersController` to use the unified queries from `Hasad.Application/Features/Location/Queries/`.

---

### Flutter: mobile

#### [MODIFY] [location_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/location/data/location_repository.dart)
- Fix invalid Dart syntax in `getLocalities` (`?governorateId` -> `governorateId`).
- Update `getDirectorates` to call `/v1/Location/directorates` instead of `/v1/Users/directorates`.

#### [MODIFY] [users_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/admin/data/users_repository.dart)
- Ensure it uses the shared `LocationRepository` for geographic data.

---

## Verification Plan

### Automated Tests
- Backend: `dotnet test` (ensure geographic queries return the `Code`).
- Flutter: `flutter analyze` to verify the syntax fix.

### Manual Verification
1.  Log in as `SuperAdmin`.
2.  Navigate to **User Management** -> **Add User**.
3.  Verify that **Governorate** and **Directorate** dropdowns are populated.
4.  Log in as `AgriculturalEngineer`.
5.  Navigate to any farmer's **Add Farm** screen.
6.  Verify that the location dropdowns are correctly populated (and scoped if applicable).
