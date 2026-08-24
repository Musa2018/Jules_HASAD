import 'dart:async';
import 'package:mobile/features/notifications/data/local/local_notification_db.dart';
import 'package:mobile/features/notifications/data/remote/notification_api_client.dart';

class NotificationSyncService {
  final LocalNotificationDb _db;
  final NotificationApiClient _apiClient;
  Timer? _syncTimer;

  NotificationSyncService(this._db, this._apiClient);

  Future<void> startSync() async {
    // 1. Immediate pull on start
    await pullNotifications();
    
    // 2. Schedule periodic sync for read statuses
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncPendingReadStatuses());
  }

  Future<void> pullNotifications() async {
    try {
      print('NotificationSync: Pulling notifications from server...');
      final results = await _apiClient.getMyNotifications(pageIndex: 1, pageSize: 50);
      
      final items = (results['Items'] ?? results['items']) as List;
      for (var item in items) {
        await _db.insertNotification({
          'Id': (item['id'] ?? item['Id']).toString(),
          'Title': item['title'] ?? item['Title'] ?? '',
          'Body': item['body'] ?? item['Body'] ?? '',
          'Category': item['category'] ?? item['Category'] ?? 'General',
          'PayloadJson': item['payloadJson'] ?? item['PayloadJson'],
          'IsRead': (item['isRead'] ?? item['IsRead'] ?? false) ? 1 : 0,
          'ReceivedAt': item['createdAt'] ?? item['CreatedAt'],
          'SyncStatus': 1,
        });
      }
      print('NotificationSync: Pulled ${items.length} notifications.');
    } catch (e) {
      print('NotificationSync: Error pulling notifications: $e');
    }
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
