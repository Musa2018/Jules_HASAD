# Task - Authorization & Authentication Hardening (UAT-002 & UAT-003)

- [x] Implement UI Guards for Farm Creation Leak (UAT-002)
    - [x] Update `FarmsListScreen` to hide FAB for unauthorized users
- [x] Implement Backend Security for Disabled Users (UAT-003)
    - [x] Update `LoginCommandHandler.cs` with `IsActive` check
    - [x] Update `RefreshTokenCommandHandler.cs` with `IsActive` check
- [x] Automated Regression Testing
    - [x] Add `farms_list_authorization_test.dart`
    - [x] Update/Add backend tests for `IsActive` scenarios
- [x] Documentation & UAT Updates
    - [x] Update `UAT_Farmers_Farms_Hardening.md`
    - [x] Update `PROJECT_STATUS.md`
- [x] Final Verification
    - [x] `flutter analyze` & `flutter test`
    - [x] `dotnet test`
- [x] Commit changes
