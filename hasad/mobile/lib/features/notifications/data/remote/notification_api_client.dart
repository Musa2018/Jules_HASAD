import 'package:dio/dio.dart';

class NotificationApiClient {
  final Dio _dio;

  NotificationApiClient(this._dio);

  Future<Map<String, dynamic>> getMyNotifications({int pageIndex = 1, int pageSize = 20}) async {
    final response = await _dio.get(
      '/api/notification/my-notifications',
      queryParameters: {'pageIndex': pageIndex, 'pageSize': pageSize},
    );
    return response.data;
  }

  Future<void> markAsRead(String id) async {
    await _dio.put('/api/notification/$id/read');
  }

  Future<void> registerDevice(String token, String platform) async {
    await _dio.post('/api/device/register', data: {
      'deviceToken': token,
      'platform': platform,
    });
  }
}
