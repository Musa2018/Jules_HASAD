# Implementation Plan - Production Debug Session: Farmers Sync Trace

Add comprehensive, temporary logging to the synchronization pipeline to capture the exact HTTP request/response payloads and identify why the backend is rejecting Farmers data.

## User Review Required

> [!IMPORTANT]
> This plan involves adding `print` statements and a custom `LogInterceptor` to the networking and sync layers. This data may contain PII (Farmer names, IDs) in the console output during debugging.

## Proposed Changes

### 1. Networking Layer (Logging Abstraction)

#### [NEW] [debug_logger.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/utils/debug_logger.dart)
- Create a simple helper to pretty-print JSON and format the debug blocks requested.
- Include a `const bool ENABLE_SYNC_DEBUG = true;` flag to easily disable it later.

### 2. Networking Layer (Dio)

#### [MODIFY] [auth_providers.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/auth/presentation/auth_providers.dart)
- Add a custom `Interceptor` to `apiDioProvider` that uses `DebugLogger` to print full request/response details.

### 3. Synchronization Layer

#### [MODIFY] [background_sync_service.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/background_sync_service.dart)
- In `_processItem`, log the "Sync Information" block (Entity Type, Operation, IDs, etc.) before handing off to the repositories.
- Add try/catch blocks around sync calls to capture and log the full "Error Trace" including stack traces.

### 4. Data Layer

#### [MODIFY] [remote_farmer_repository.dart](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/farmers/data/remote_farmer_repository.dart)
- Add specific logging inside `createFarmer` and `updateFarmer` to show the exact `payload` after local ID removal and `clientId` assignment, just before the `dio.post/put` call.

## Verification Plan

### Automated Tests
- Run `flutter test test/core/storage/background_sync_service_test.dart`.
- Verify that the logs appear in the test output as expected when the sync logic is exercised.

### Manual Debugging (Report Generation)
1. Execute a sync operation (via test or running the app).
2. Capture the console output.
3. Analyze the field-by-field differences between the captured JSON and the Swagger definition.
4. Produce the **Validation Report** in a new artifact.
