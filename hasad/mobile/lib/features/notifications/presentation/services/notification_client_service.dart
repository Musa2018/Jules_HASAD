import 'package:signalr_core/signalr_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/features/notifications/data/local/local_notification_db.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class NotificationClientService {
  HubConnection? _hubConnection;
  final LocalNotificationDb _db;
  final FlutterLocalNotificationsPlugin _localNotifier = FlutterLocalNotificationsPlugin();
  final Function(String)? onNotificationTapped;
  final VoidCallback? onNotificationReceived;

  NotificationClientService(this._db, {this.onNotificationTapped, this.onNotificationReceived}) {
    _initLocalNotifications();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _localNotifier.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
        if (details.payload != null && onNotificationTapped != null) {
          onNotificationTapped!(details.payload!);
        }
      },
    );

    // Create high importance channel for Android 8.0+
    final androidPlugin = _localNotifier.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: 'This channel is used for important agricultural alerts.',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
      
      // Request permission for Android 13+
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> connect({required String url, required String accessToken, String? deviceToken}) async {
    if (_hubConnection != null && _hubConnection!.state == HubConnectionState.connected) {
      print('SignalR: Already connected to $url');
      return;
    }

    print('SignalR: Attempting connection to $url');
    var hubUrl = url;
    if (deviceToken != null) {
      hubUrl += (hubUrl.contains('?') ? '&' : '?') + 'deviceToken=$deviceToken';
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl, HttpConnectionOptions(
          accessTokenFactory: () async => accessToken,
          logging: (level, message) => print('SignalR [$level]: $message'),
        ))
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on("ReceiveNotification", (args) {
      print('SignalR: Method "ReceiveNotification" invoked with args: $args');
      _handleIncomingNotification(args);
    });

    _hubConnection!.onreconnecting((error) => print('SignalR: Reconnecting... $error'));
    _hubConnection!.onreconnected((connectionId) => print('SignalR: Reconnected! $connectionId'));
    _hubConnection!.onclose((error) => print('SignalR: Connection closed. $error'));

    try {
      await _hubConnection!.start();
      print('SignalR: Connection Started successfully. State: ${_hubConnection!.state}');
    } catch (e) {
      print('SignalR: Connection Error: $e');
    }
  }

  void _handleIncomingNotification(List<dynamic>? args) async {
    if (args == null || args.isEmpty) {
      print('SignalR: Received empty notification payload');
      return;
    }
    
    try {
      // Server sends: { id, title, body, category, payload, createdAt }
      final data = args[0] as Map<String, dynamic>;
      print('SignalR: Processing notification data: $data');

      final String id = (data['id'] ?? data['Id'] ?? DateTime.now().millisecondsSinceEpoch).toString();
      final String title = (data['title'] ?? data['Title'] ?? 'No Title').toString();
      final String body = (data['body'] ?? data['Body'] ?? '').toString();
      final String category = (data['category'] ?? data['Category'] ?? 'General').toString();
      final String? payload = data['payload'] ?? data['Payload'];

      // 1. Persist to SQLite
      await _db.insertNotification({
        'Id': id,
        'Title': title,
        'Body': body,
        'Category': category,
        'PayloadJson': payload,
        'IsRead': 0,
        'ReceivedAt': DateTime.now().toIso8601String(),
        'SyncStatus': 1,
      });
      print('SignalR: Notification persisted to local DB');

      // 2. Show Local Notification
      await _showLocalNotification({
        'id': id,
        'title': title,
        'body': body,
        'payload': payload,
      });

      // 3. Notify UI listeners
      if (onNotificationReceived != null) {
        onNotificationReceived!();
      }
    } catch (e) {
      print('SignalR: Error handling notification: $e');
    }
  }

  Future<void> _showLocalNotification(Map<String, dynamic> data) async {
    print('SignalR: Triggering local notification UI');
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important agricultural alerts.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      await _localNotifier.show(
        data['id'].hashCode,
        data['title'],
        data['body'],
        details,
        payload: data['id'], // Using notification ID as payload for "Mark as Read" flow
      );
      print('SignalR: Local notification displayed');
    } catch (e) {
      print('SignalR: Error showing local notification: $e');
    }
  }

  void dispose() {
    _hubConnection?.stop();
  }
}
