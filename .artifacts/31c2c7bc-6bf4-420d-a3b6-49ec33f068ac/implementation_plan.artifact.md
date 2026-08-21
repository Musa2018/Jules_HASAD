# Fix Connectivity Links between Flutter, Backend, and Admin Dashboard

This plan addresses three connectivity gaps to ensure the Reporting & Analytics Engine works end-to-end.

## Proposed Changes

### 1. Database Seeding
#### [MODIFY] [SeedData.sql](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/SeedData.sql) [NEW]
Create a SQL script to seed `DashboardKpiMetrics` with initial values for the admin dashboard.

### 2. Flutter Connectivity
#### [MODIFY] [app_config.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/core/config/app_config.dart)
Ensure the default `apiBaseUrl` for development is consistently using `10.0.2.2` for Android Emulator.

#### [MODIFY] [e2e_live_test.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/test/live/e2e_live_test.dart)
Update test base URL to support emulator testing if needed.

### 3. Device Presence & Real-time KPIs
#### [MODIFY] [NotificationHub.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Hubs/NotificationHub.cs)
- Inject `IHubContext<AdminDashboardHub>` into `NotificationHub`.
- In `OnConnectedAsync`, update `UserDevices` and then broadcast a "MetricUpdated" message to `LiveSuperAdminStream` so the admin dashboard reflects the new online user count immediately.
- Ensure `IsOnline` and `Platform` are handled correctly.

#### [MODIFY] [notification_client_service.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/features/notifications/presentation/services/notification_client_service.dart)
- Ensure the SignalR client listens for a generic "Broadcast" event if required.
- Add logging to confirm successful connection to `hubs/notifications`.

## Verification Plan

### Automated Tests
- Run `dotnet test` for backend.
- Run `flutter test` for mobile.

### Manual Verification
1. Run the SQL seeding script.
2. Start the Backend and Admin Web.
3. Launch the Flutter app in an Android Emulator.
4. Log in on the Flutter app.
5. Observe the Admin Dashboard:
   - Check if "Online Now" KPI increments immediately.
   - Check if the device distribution chart updates.
6. Verify the Flutter app receives a test broadcast if sent from the Admin Dashboard.
