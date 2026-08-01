# Implementation Plan - Geographic Integrity & Multi-Farm Scenario Validation

This plan executes the final architectural review and hardening of geographic scoping, ensuring that operational authorization is strictly land-based (Farm/DamageReport) and correctly handles farmers with multiple properties across jurisdictions.

## User Review Required

> [!IMPORTANT]
> **Operational Scoping Rule**: Farmer visibility in operational lists is derived from their farms. A farmer (e.g., Ahmed) will be visible to a Jenin user if he has at least one farm in Jenin. However, the same Jenin user will ONLY see the Jenin farm in Ahmed's profile, not his farms in Nablus.
> [!WARNING]
> **Query Hardening**: `GetFarmById` and `GetFarmsByFarmer` will now return failures or filtered lists if the requested assets are outside the user's assigned Directorate/Governorate.

## Proposed Changes

### 1. Backend Authorization Hardening

#### [MODIFY] [GetFarmsByFarmerQuery.cs](file:///hasad/backend/Hasad.Application/Features/Farms/Queries/GetFarmsByFarmer/GetFarmsByFarmerQuery.cs)
- Inject `ICurrentUserService`.
- Apply geographic filtering to the query:
    - If user is Engineer/Surveyor: `farm.DirectorateId == currentUser.DirectorateId`.
    - If user is Director: `farm.GovernorateId == currentUser.GovernorateId`.

#### [MODIFY] [GetFarmByIdQuery.cs](file:///hasad/backend/Hasad.Application/Features/Farms/Queries/GetFarmById/GetFarmByIdQuery.cs)
- Inject `ICurrentUserService`.
- Add an explicit scope check after fetching the farm:
    - Return a failure Result (403 Forbidden semantics) if the farm's `DirectorateId` or `GovernorateId` does not match the user's scope.

---

### 2. Multi-Farm Security Testing

#### [NEW] [MultiFarmSecurityScenariosTests.cs](file:///hasad/backend/Hasad.Application.Tests/MultiFarmSecurityScenariosTests.cs)
- **Scenario A: Multi-Farm Access**:
    - Verify Jenin user sees 1/3 farms for Farmer Ahmed.
    - Verify Jenin user CANNOT fetch Nablus farm by ID.
- **Scenario B: Cross-Jurisdiction Visibility**:
    - Verify Jenin user CANNOT see Farmer Ali (who only owns Nablus land), even if Ali's personal address is in Jenin.

---

### 3. Mobile UI Review & Terminology

#### [MODIFY] [app_ar.arb](file:///hasad/mobile/lib/l10n/app_ar.arb) & [app_en.arb](file:///hasad/mobile/lib/l10n/app_en.arb)
- Add labels for "Personal Address" (العنوان الشخصي) to distinguish from land location.

#### [MODIFY] [FarmerDetailsScreen.dart](file:///hasad/mobile/lib/features/farmers/presentation/farmer_details_screen.dart) & [FarmerCard.dart](file:///hasad/mobile/lib/features/farmers/presentation/widgets/farmer_card.dart)
- Update geographic labels to use "Personal Address" terminology.
- Ensure no "Directorate" is shown for the Farmer profile itself (only Governorate/Locality for residency).

---

### 4. Synchronization & Relational Integrity

#### [NEW] [multi_farm_offline_sync_test.dart](file:///hasad/mobile/test/core/storage/multi_farm_offline_sync_test.dart)
- Verify that creating 1 Farmer + 3 Farms (Diff Directorates) offline results in correct relational binding during synchronization.

---

### 5. Documentation

#### [MODIFY] [ADR-0013](file:///docs/adr/0013-damagereport-authorization-inheritance.md)
- Add Section: **Multi-Farm Scoping Policy**.
- Formalize that Farmer profile visibility is a proxy for Farm ownership within scope.

#### [MODIFY] [AI_CONTEXT.md](file:///AI_CONTEXT.md)
- Add the "Informational vs. Operational Geographics" rule.

## Verification Plan

### Automated Verification
- `dotnet build hasad/backend/Hasad.sln /warnaserror`
- `dotnet test hasad/backend/Hasad.sln`
- `flutter test`

### Manual Verification
- Seed Ahmed Mohammed with 3 farms.
- Log in as Jenin Directorate User.
- Confirm only 1 farm is visible under Ahmed's profile.
- Verify direct access to Nablus Farm ID returns "Access Denied".
