# AGENTS.md - معايير التطوير لنظام حساد

## Coding Standards
- Follow Clean Architecture and SOLID principles.
- Use feature-first folder structure.
- All public methods must have Doc comments (Dart).
- Ensure all Flutter widgets are responsive and support RTL (Arabic).

## Synchronization (Offline-First)
- **Data Persistence**: Data MUST be saved locally before attempting API calls.
- **Retry Logic**: Use the updated `retrySync` pattern which bypasses backoff for immediate user actions.
- **Metadata**: Always update `syncStatus`, `lastSyncError`, and `updatedAt` to ensure UI reactivity.
- **Workflow History**: Any status transition must trigger a `syncWorkflowHistory` call to keep local audit logs consistent.

## Error Handling
- **API Exceptions**: Capture and store full `DioException` details in `lastSyncError`.
- **Validation**: Surface backend validation errors (400) directly to the user via technical error banners.
- **Robustness**: Always check `if (!mounted)` in StateNotifiers after `await` calls.

## Testing
- Aim for high coverage in Domain and Application layers.
- Use `background_sync_service_test.dart` as a reference for all sync-related tests.
- Verify provider invalidation (`ref.invalidate`) in integration tests.
