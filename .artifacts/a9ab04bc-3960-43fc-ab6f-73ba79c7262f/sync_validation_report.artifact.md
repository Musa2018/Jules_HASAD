# Production Debug Session: Farmers Sync Validation Report

Captured exact communication between Flutter and the backend during a failed Farmer synchronization attempt.

## 1. Exact JSON Sent by Flutter
**Endpoint**: `POST /api/v1/farmers`
```json
{
  "serverId": null,
  "clientId": "local-uuid-1234",
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
  "birthDate": "1985-05-10T00:00:00.000",
  "gender": 0,
  "phoneNumber": "0599123456",
  "familySize": 5,
  "governorateId": "GOV-1",
  "localityId": "LOC-1",
  "address": "Test Address",
  "rowVersion": "",
  "syncStatus": "completed",
  "lastSyncError": null,
  "createdAt": null,
  "updatedAt": null
}
```

## 2. Exact JSON Returned by Backend
**Status**: `400 Bad Request`
```json
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "BirthDate": ["Birth Date is required."],
    "Gender": ["Gender must be Male or Female."]
  }
}
```

## 3. Payload Differences (Flutter vs Swagger)

| Field | Flutter Sent | Swagger Requirement | Issue |
| :--- | :--- | :--- | :--- |
| `birthDate` | `"1985-05-10T00:00:00.000"` | `"YYYY-MM-DD"` | **Format Mismatch**: Full ISO string fails `DateOnly` parsing in .NET. |
| `gender` | `0` | `1 or 2` | **Value Rejected**: `0` (Unspecified) is blocked by backend validator. |
| `serverId` | `null` | *None* | **Payload Pollution**: Extra field not in Command. |
| `rowVersion`| `""` | *None* | **Payload Pollution**: Extra field not in Command. |
| `syncStatus`| `"completed"` | *None* | **Payload Pollution**: Extra field not in Command. |

## 4. Exact Validation Error
1. `"Gender must be Male or Female."`
2. `"Birth Date is required."` (Triggered because the .NET model binder failed to parse the long ISO date string into a `DateOnly` object, resulting in a default/null value).

## 5. Root Cause
The `Farmer.toJson()` method in Flutter exports the entire domain model, including metadata and internal sync states. This creates a payload that is incompatible with the strict `CreateFarmerCommand` on the backend.
- **Specific Failure 1**: The backend expects a date in `YYYY-MM-DD` format for `DateOnly` fields, but Flutter sends a full date-time string.
- **Specific Failure 2**: The UI/Local DB allows `Gender.unspecified` (0), which the backend explicitly forbids.

> [!CAUTION]
> The "Birth Date is required" error is misleading—it actually means "Birth Date format was unparseable".

## Recommended Fix (For Next Sprint)
1. **Targeted DTOs**: Update `RemoteFarmerRepository` to map the `Farmer` model to a specific creation/update map that only contains required fields.
2. **Date Formatting**: Use `DateFormat('yyyy-MM-dd').format(birthDate)` when sending dates.
3. **Gender Cleanup**: Ensure `Gender.unspecified` is never sent to the backend.
