import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/notifications/data/local/local_notification_db.dart';
import 'package:mobile/features/notifications/data/remote/notification_api_client.dart';
import 'package:mobile/features/notifications/presentation/services/notification_client_service.dart';
import 'package:mobile/features/notifications/presentation/services/notification_sync_service.dart';
import 'package:mobile/core/config/app_config.dart';

final notificationDbProvider = Provider((ref) => LocalNotificationDb.instance);

final notificationApiClientProvider = Provider((ref) {
  final dio = ref.watch(apiDioProvider);
  return NotificationApiClient(dio);
});

final notificationClientServiceProvider = Provider((ref) {
  final db = ref.watch(notificationDbProvider);
  final authState = ref.watch(authProvider);
  
  final service = NotificationClientService(db, onNotificationTapped: (id) {
    ref.read(localNotificationsProvider.notifier).markAsRead(id);
  });
  
  if (authState.isAuthenticated) {
    final baseUrl = EnvironmentConfig.config.apiBaseUrl;
    // Hubs are typically at the root of the app, not under /api
    final hubBaseUrl = baseUrl.replaceAll(RegExp(r'/api$'), '');
    final hubUrl = '$hubBaseUrl/hubs/notifications';
    final token = authState.session?.token ?? '';
    
    // We should ideally get the device token from a service (FCM/APNS)
    // For now we initialize with what we have.
    service.connect(
      url: hubUrl,
      accessToken: token,
    );
  }
  
  ref.onDispose(() => service.dispose());
  return service;
});

final notificationSyncServiceProvider = Provider((ref) {
  final db = ref.watch(notificationDbProvider);
  final client = ref.watch(notificationApiClientProvider);
  final service = NotificationSyncService(db, client);
  
  final authState = ref.watch(authProvider);
  if (authState.isAuthenticated) {
    service.startSync();
  }
  
  ref.onDispose(() => service.stopSync());
  return service;
});

final localNotificationsProvider = StateNotifierProvider<LocalNotificationsNotifier, List<Map<String, dynamic>>>((ref) {
  final db = ref.watch(notificationDbProvider);
  final apiClient = ref.watch(notificationApiClientProvider);
  return LocalNotificationsNotifier(db, apiClient);
});

class LocalNotificationsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final LocalNotificationDb _db;
  final NotificationApiClient _apiClient;

  LocalNotificationsNotifier(this._db, this._apiClient) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    state = await _db.getAllNotifications();
  }

  Future<void> markAsRead(String id) async {
    // 1. Update local database immediately
    await _db.markAsRead(id);
    await refresh();

    // 2. Attempt to update server immediately
    try {
      await _apiClient.markAsRead(id);
      await _db.updateSyncStatus(id, 1);
    } catch (e) {
      // If server update fails, it remains as SyncStatus = 0
      // and NotificationSyncService will retry it later.
      print('Error marking notification as read on server: $e');
    }
  }
}

final unreadCountProvider = FutureProvider<int>((ref) async {
  // Watch localNotificationsProvider to recalculate when it changes
  ref.watch(localNotificationsProvider);
  return await ref.watch(notificationDbProvider).getUnreadCount();
});
