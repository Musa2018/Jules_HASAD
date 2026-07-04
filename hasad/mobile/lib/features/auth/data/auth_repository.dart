import 'package:dio/dio.dart';
import 'package:mobile/core/config/app_config.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '${EnvironmentConfig.config.apiBaseUrl}/v1/accounts/login',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  @override
  Future<void> logout() async {
    // Clear local storage
  }
}
