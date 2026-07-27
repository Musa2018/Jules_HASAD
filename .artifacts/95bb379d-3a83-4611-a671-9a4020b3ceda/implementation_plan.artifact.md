# Implementation Plan - Fix Farmer Name Resolution and Farm Card UI

The user reported that farmer and owner names are showing IDs instead of names in the Farm Card. This is because the repository only searches by local ID, but synced records use server IDs. Additionally, the Farm Card needs UI improvements to show ownership type and conditionally hide the owner name.

## User Review Required

> [!NOTE]
> The fix for name resolution involves allowing lookups by both local ClientId and server Authority ID. This ensures that relationships are correctly resolved regardless of whether the data was created locally or synced from the server.

## Proposed Changes

### [Farmers Module - Data Layer]

#### [MODIFY] [farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/farmer_repository.dart)
- Update `getFarmer` to search by both `id` and `serverId`.
- Update `watchFarmer` to search by both `id` and `serverId`.

### [Farms Module - UI]

#### [MODIFY] [farm_card.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farms/presentation/widgets/farm_card.dart)
- Add a lookup for `OwnershipType` name.
- Display the **Ownership Type** in the card.
- **Conditional Visibility**: Only show the "Owner Farmer" row if `ownershipTypeId` is NOT 1 (i.e., not "Owned/ملك").
- Improve the display of names by ensuring `operatorAsync` and `ownerAsync` are correctly handled.

## Verification Plan

### Manual Verification
- Navigate to the Farms list.
- Verify that "Farmer Name" now shows the actual name (e.g., "Musa") instead of a UUID.
- Verify that "Owner Farmer" also shows the name.
- Change a farm's ownership to "Owned" and verify that the Owner row disappears.
- Verify that the Ownership Type (e.g., "ملك" or "ضمان") is visible on the card.
