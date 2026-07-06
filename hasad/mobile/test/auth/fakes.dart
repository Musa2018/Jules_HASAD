import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';

/// In-memory [SecureStorageService] for tests.
class FakeSecureStorage extends SecureStorageService {
  /// Backing store.
  final Map<String, String> values = {};

  /// Creates the fake.
  FakeSecureStorage() : super(const FlutterSecureStorage());

  @override
  Future<void> saveToken(String token) async => values['token'] = token;

  @override
  Future<String?> getToken() async => values['token'];

  @override
  Future<void> saveRefreshToken(String token) async =>
      values['refresh'] = token;

  @override
  Future<String?> getRefreshToken() async => values['refresh'];

  @override
  Future<void> clearAll() async => values.clear();
}

/// Scriptable [AuthRepository] for tests.
class FakeAuthRepository implements AuthRepository {
  /// Session returned by [login] and [refresh]; failures thrown when null.
  AuthSession? session;

  /// Number of times [refresh] was invoked.
  int refreshCalls = 0;

  /// Number of times [logout] was invoked.
  int logoutCalls = 0;

  /// Refresh tokens presented to [logout].
  final List<String> revokedTokens = [];

  /// Optional delay applied to [refresh] to simulate network latency.
  Duration refreshDelay = Duration.zero;

  @override
  Future<AuthSession> login(String email, String password) async {
    final current = session;
    if (current == null) throw AuthException(['Invalid email or password.']);
    return current;
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    refreshCalls++;
    await Future<void>.delayed(refreshDelay);
    final current = session;
    if (current == null) throw AuthException(['Invalid refresh token.']);
    return current;
  }

  @override
  Future<void> logout(String refreshToken) async {
    logoutCalls++;
    revokedTokens.add(refreshToken);
  }
}

/// Builds a sample session for tests.
AuthSession sampleSession({String token = 'access-1'}) => AuthSession(
  token: token,
  refreshToken: 'refresh-1',
  email: 'admin@hasad.ps',
  fullName: 'Super Admin',
);
