# Production Debug Session: Farmer Update Sync Trace

Captured and analyzed the communication for Farmer Update operations.

## 1. HTTP Communication (Captured Trace)

**Endpoint**: `PUT /api/v1/farmers/remote-uuid-123`
**Method**: `PUT`

### JSON Request Payload
```json
{
  "id": "remote-uuid-123",
  "clientId": "local-uuid-update",
  "idTypeId": 1,
  "idNumber": "949585335",
  "firstNameAr": "أحمد",
  "fatherNameAr": "محمد",
  "grandfatherNameAr": "علي",
  "familyNameAr": "محمود",
  "firstNameEn": "Ahmed",
  "fatherNameEn": "Mohammed",
  "grandfatherNameEn": "Ali",
  "familyNameEn": "Mahmoud",
  "birthDate": "1985-05-10",
  "gender": 1,
  "phoneNumber": "0599123456",
  "familySize": 5,
  "governorateId": "GOV-1",
  "localityId": "LOC-1",
  "address": "Test Address",
  "rowVersion": "AAAAAAAAB98="
}
```

## 2. Contract Verification (Backend Comparison)

| Field | Flutter Sent | Backend (UpdateFarmerCommand) | Result |
| :--- | :--- | :--- | :--- |
| `id` | `remote-uuid-123` | `Guid Id` | **Match** |
| `clientId` | `local-uuid-update` | `Guid ClientId` | **Match** |
| `birthDate` | `"1985-05-10"` | `DateOnly BirthDate` | **Match** |
| `gender` | `1` | `Gender Gender` | **Match** |
| `rowVersion` | `"Base64String"` | `string RowVersion` | **Match** |

## 3. Risk Audit: Other Entities (Farm & DamageReport)

During the audit, a critical discrepancy was found in the `Farm` and `DamageReport` entities:

### Farm Update Payload (Current State)
```json
{
  "id": "local-uuid-abc",  // WRONG: Sending Client ID instead of Server ID
  "clientId": "local-uuid-abc",
  ...
}
```
**Root Cause**: The `Farm` domain model is missing the `serverId` field. When an update is performed, the repository uses the local `id` (ClientId) for the `id` field in the command. This causes the backend to return `404 Not Found`.

## 4. Identified Problems
1. **Missing Metadata**: `Farm`, `DamageReport`, and `DamageItem` domain models lack the `serverId` and `lastSyncError` fields present in `Farmer`.
2. **Reconciliation Failure**: After a successful creation sync, the `serverId` returned by the server is stored in the local DB but not correctly mapped back into the domain models for subsequent updates in all repositories.

## 5. Conclusion
Farmer updates are technically configured correctly in the DTO layer, but the system lacks consistency across other entity types which likely share the same sync failure patterns. Hardening the metadata mapping for ALL entities is the required path forward.
