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

## Migration & Deployment Strategy
To ensure a safe and repeatable deployment:

1. **Pre-migration Audit**: A mandatory SQL audit script (`IdentityUniquenessAudit.sql`) must be run by administrators to identify existing duplicates.
2. **Data Cleanup**: Administrators must resolve duplicates (merge or delete) before applying schema changes.
3. **Schema-Only Migration**: The EF Core migration will strictly perform schema changes (dropping the composite index and creating the single-column filtered index). It will NOT modify business data.
4. **Deployment Sequence**:
    - Step 1: Run Audit Script.
    - Step 2: Resolve Duplicates.
    - Step 3: Apply Database Migration.
    - Step 4: Deploy Application Code.

## Consequences
- **Positive**: Eliminates search ambiguity and improves data integrity.
- **Positive**: Simplifies identity-based lookup logic.
- **Negative**: Requires manual data cleanup in existing databases where duplicates might already exist.
- **Negative**: Prevents edge cases where a person might legitimately have two different identity documents registered separately.

## References
- UAT finding: UAT-007
- Project: HASAD Farmers & Farms Hardening
- Audit Script: `hasad/backend/Hasad.Infrastructure/Persistence/deployment/database/IdentityUniquenessAudit.sql`
