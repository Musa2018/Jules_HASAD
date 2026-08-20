import 'dart:async';
import 'package:mobile/features/notifications/data/local/local_notification_db.dart';
import 'package:mobile/features/notifications/data/remote/notification_api_client.dart';

class NotificationSyncService {
  final LocalNotificationDb _db;
  final NotificationApiClient _apiClient;
  Timer? _syncTimer;

  NotificationSyncService(this._db, this._apiClient);

  void startSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncPendingReadStatuses());
  }

  Future<void> syncPendingReadStatuses() async {
    final pending = await _db.getUnsyncedReadStatus();
    if (pending.isEmpty) return;

    for (var item in pending) {
      try {
        final id = item['Id'] as String;
        await _apiClient.markAsRead(id);
        await _db.updateSyncStatus(id, 1);
      } catch (e) {
        // Log error or retry later
        print('Error syncing notification read status: $e');
      }
    }
  }

  void stopSync() {
    _syncTimer?.cancel();
  }
}
