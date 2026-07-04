import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final secureStorageServiceProvider = Provider((ref) {
  return SecureStorageService(ref.watch(secureStorageProvider));
});

final dioProvider = Provider((ref) => Dio());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(dioProvider));
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  AuthState({this.user, this.isLoading = false, this.error, this.isInitialized = false});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _storage;

  AuthNotifier(this._repository, this._storage) : super(AuthState());

  Future<void> init() async {
    final token = await _storage.getToken();
    if (token != null) {
      // In a real app, we might fetch user profile here
      // For now, assume if token exists, we are "logged in"
      // state = AuthState(user: ...);
    }
    state = AuthState(user: state.user, isInitialized: true);
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true, isInitialized: true);
    try {
      final data = await _repository.login(email, password);
      final user = User.fromJson(data['data']);

      if (user.token != null) {
        await _storage.saveToken(user.token!);
      }
      if (user.refreshToken != null) {
        await _storage.saveRefreshToken(user.refreshToken!);
      }

      state = AuthState(user: user, isInitialized: true);
    } catch (e) {
      state = AuthState(error: e.toString(), isInitialized: true);
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
    state = AuthState(user: null, isInitialized: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
