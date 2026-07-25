# ADR 0017: Global Identity Number Uniqueness

## Status
Proposed

## Context
During the User Acceptance Testing (UAT) phase (specifically finding UAT-007), it was discovered that the system allowed multiple active farmers to share the same `IdentityNumber` as long as they had different `IdentityType`s (e.g., National ID vs. Passport). This behavior caused ambiguity in identity-based searches, leading to "Too Many Results" errors and potential data inconsistency in reporting.

The previous business rule was: `IdentityTypeId + IdentityNumber` must be unique.

## Decision
We will enforce **Global IdentityNumber Uniqueness** across all active farmer records.

1. **Uniqueness Scope**: The `IdentityNumber` must be unique regardless of the `IdentityType`.
2. **Soft Delete Handling**: Uniqueness is only enforced for active records (`IsDeleted = 0`). Logical deletion allows the reuse of an identity number for a new record.
3. **Identity Type**: The `IdentityType` remains a required classification field but is no longer part of the uniqueness constraint.
4. **Data Integrity**: Search by `IdentityNumber` must return at most one active record.

## Migration Strategy
To ensure a safe and repeatable deployment:

1. **Pre-migration Audit**: A mandatory SQL audit script must be run by administrators to identify and resolve existing duplicates before applying the schema change.
2. **Schema Change**: The existing composite unique index `IX_Farmers_IdTypeId_IdNumber` will be replaced with a single-column unique index `IX_Farmers_IdNumber` with a filter `[IsDeleted] = 0`.

## Consequences
- **Positive**: Eliminates search ambiguity and improves data integrity.
- **Positive**: Simplifies identity-based lookup logic.
- **Negative**: Requires manual data cleanup in existing databases where duplicates might already exist.
- **Negative**: Prevents edge cases where a person might legitimately have two different identity documents registered separately (business rule assumes one physical person = one unique identity record in the system).

## References
- UAT finding: UAT-007
- Project: HASAD Farmers & Farms Hardening
