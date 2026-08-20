import 'package:signalr_core/signalr_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/features/notifications/data/local/local_notification_db.dart';
import 'dart:convert';

class NotificationClientService {
  HubConnection? _hubConnection;
  final LocalNotificationDb _db;
  final FlutterLocalNotificationsPlugin _localNotifier = FlutterLocalNotificationsPlugin();

  NotificationClientService(this._db) {
    _initLocalNotifications();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _localNotifier.initialize(initSettings);
  }

  Future<void> init(String hubUrl, String authToken, {String? deviceToken}) async {
    if (_hubConnection != null) return;

    var url = hubUrl;
    if (deviceToken != null) {
      url += (url.contains('?') ? '&' : '?') + 'deviceToken=$deviceToken';
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(url, HttpConnectionOptions(
          accessTokenFactory: () async => authToken,
          logging: (level, message) => print('SignalR [$level]: $message'),
        ))
        .build();

    _hubConnection!.on("ReceiveNotification", _handleIncomingNotification);

    try {
      await _hubConnection!.start();
    } catch (e) {
      print('SignalR Connection Error: $e');
    }
  }

  void _handleIncomingNotification(List<dynamic>? args) async {
    if (args == null || args.isEmpty) return;
    
    // Server sends: { Id, Title, Body, Category, Payload, CreatedAt }
    final data = args[0] as Map<String, dynamic>;

    // 1. Persist to SQLite
    await _db.insertNotification({
      'Id': data['id'].toString(),
      'Title': data['title'],
      'Body': data['body'],
      'Category': data['category'] ?? 'General',
      'PayloadJson': data['payload'],
      'IsRead': 0,
      'ReceivedAt': DateTime.now().toIso8601String(),
      'SyncStatus': 1,
    });

    // 2. Show Local Notification
    _showLocalNotification(data);
  }

  Future<void> _showLocalNotification(Map<String, dynamic> data) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifier.show(
      data['id'].hashCode,
      data['title'],
      data['body'],
      details,
      payload: data['payload'],
    );
  }

  void dispose() {
    _hubConnection?.stop();
  }
}
