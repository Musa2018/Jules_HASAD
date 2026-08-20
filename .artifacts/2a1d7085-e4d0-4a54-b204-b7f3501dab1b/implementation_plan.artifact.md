# Implementation Plan - Phase 1: Step 1 (Dynamic Reporting Engine Foundations)

Establish the data models and validation logic for the Dynamic Reporting Engine as specified in `2_DYNAMIC_REPORTING_ENGINE_SPEC.md`.

## User Review Required

> [!IMPORTANT]
> The database schema uses JSON strings for configurations (`ConfigurationJson`, `SavedFiltersJson`, etc.). This allows for maximum flexibility in the metadata-driven engine while keeping the schema simple.

## Proposed Changes

### [Hasad.Domain]

#### [NEW] [ReportDefinition](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/ReportDefinition.cs)
Defines the structure for report templates.

#### [NEW] [UserReportPreset](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/UserReportPreset.cs)
Stores user-specific report customizations and saved filters.

#### [NEW] [ReportExecutionLog](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/ReportExecutionLog.cs)
Audit log for report execution and performance monitoring.

---

### [Hasad.Infrastructure]

#### [MODIFY] [ApplicationDbContext](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
Register the new entities and apply configurations (indexes, foreign keys).

---

### [Hasad.Application]

#### [NEW] [ReportMetadata Models](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Reporting/Models/ReportMetadata.cs)
Data structures for the Data Dictionary (White-list).

#### [NEW] [IReportMetadataService](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Reporting/Services/IReportMetadataService.cs)
Interface for retrieving report metadata.

#### [NEW] [ReportMetadataService](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/Reporting/Services/ReportMetadataService.cs)
Implementation that manages the white-list of allowed fields, operators, and data sources.

## Verification Plan

### Automated Tests
- Unit tests for `ReportMetadataService` to ensure it correctly identifies valid/invalid fields and operators.
- EF Core migration check to ensure schema matches the DDL in the spec.

### Manual Verification
- Verify that the new tables are created in SQL Server after applying migrations.
- Debug the `ReportMetadataService` with sample report IDs.
