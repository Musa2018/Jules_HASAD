# Walkthrough — Sprint 10.6 — Farmer Validation

Implemented centralized business validation for the Farmer module across both Backend and Flutter.

## Changes Made

### Backend
- **[FarmerValidationHelpers.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/FarmerValidationHelpers.cs)**: New utility class containing:
    - Palestinian ID Modulus-10 checksum logic.
    - Numeric and Alphanumeric check methods.
    - Age calculation logic (minimum 18 years).
- **[CreateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/CreateFarmer/CreateFarmerCommand.cs)**: Updated validator to enforce ID rules based on type and verify birth date.
- **[UpdateFarmerCommand.cs](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Farmers/Commands/UpdateFarmer/UpdateFarmerCommand.cs)**: Updated validator with matching logic.

### Flutter
- **[validators.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/utils/validators.dart)**: New core utility matching backend validation logic for consistent client-side feedback.
- **[farmer_form_screen.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/presentation/farmer_form_screen.dart)**:
    - Integrated new validators into the ID Number and Birth Date fields.
    - Added support for Jerusalem ID and Passport selection.
    - Dynamic validation changes based on the selected ID Type.
- **Localization**: Updated English and Arabic `.arb` files with new error messages and ID type labels.

## Verification Results

### Automated Tests
- **Backend**: Successfully ran `FarmerValidatorTests` covering:
    - Valid/Invalid Palestinian IDs (checksum, length, characters).
    - Jerusalem ID (numeric check).
    - Passport (alphanumeric check).
    - Age validation (>= 18 years, no future dates).
- **Flutter**: `flutter analyze` passed with no relevant errors (only minor deprecations).

### Summary of Rules Applied
| Rule | Requirement |
| :--- | :--- |
| **Palestinian ID** | 9 digits, numeric, Modulus-10 checksum |
| **Jerusalem ID** | Numeric, leading zeros allowed |
| **Passport** | Alphanumeric |
| **Age** | Minimum 18 years, no future dates |
| **Duplicates** | Unique combination of ID Type + ID Number |
