# Task - Authorization & Authentication Hardening (UAT-002 & UAT-003)

- [ ] Implement UI Guards for Farm Creation Leak (UAT-002)
    - [ ] Update `FarmsListScreen` to hide FAB for unauthorized users
- [ ] Implement Backend Security for Disabled Users (UAT-003)
    - [ ] Update `LoginCommandHandler.cs` with `IsActive` check
    - [ ] Update `RefreshTokenCommandHandler.cs` with `IsActive` check
- [ ] Automated Regression Testing
    - [ ] Add `farms_list_authorization_test.dart`
    - [ ] Update/Add backend tests for `IsActive` scenarios
- [ ] Documentation & UAT Updates
    - [ ] Update `UAT_Farmers_Farms_Hardening.md`
    - [ ] Update `PROJECT_STATUS.md`
- [ ] Final Verification
    - [ ] `flutter analyze` & `flutter test`
    - [ ] `dotnet test`
- [ ] Commit changes
