import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/token_refresher.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/features/admin/data/users_repository.dart';
import 'package:mobile/features/admin/domain/role.dart';
import 'package:mobile/features/admin/presentation/users_providers.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepository extends Mock implements UsersRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockTokenRefresher extends Mock implements TokenRefresher {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier({required AuthStatus status, AuthSession? session})
      : super(MockAuthRepository(), MockSecureStorageService(), MockTokenRefresher()) {
    state = AuthState(status: status, session: session);
  }

  @override
  Future<void> restoreSession() async {}
}

void main() {
  late MockUsersRepository mockRepository;

  setUp(() {
    mockRepository = MockUsersRepository();
  });

  ProviderContainer createContainer({
    AuthStatus status = AuthStatus.authenticated,
    List<String> roles = const ['SuperAdmin'],
  }) {
    final session = status == AuthStatus.authenticated
        ? AuthSession(
            token: 't',
            refreshToken: 'r',
            userId: 'u1',
            email: 'a@a.com',
            fullName: 'Admin',
            roles: roles,
          )
        : null;

    final container = ProviderContainer(
      overrides: [
        usersRepositoryProvider.overrideWithValue(mockRepository),
        authProvider.overrideWith((ref) => FakeAuthNotifier(status: status, session: session)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Users Providers Security', () {
    test('rolesProvider throws when user is not SuperAdmin', () async {
      final container = createContainer(roles: ['AgriculturalEngineer']);

      await expectLater(
        container.read(rolesProvider.future),
        throwsA(predicate((e) => e.toString().contains('SuperAdmin access required'))),
      );
    });

    test('rolesProvider succeeds when user is SuperAdmin', () async {
      final container = createContainer(roles: ['SuperAdmin']);
      final roles = [const Role(id: 'r1', name: 'SuperAdmin')];
      when(() => mockRepository.getRoles()).thenAnswer((_) async => roles);

      final result = await container.read(rolesProvider.future);

      expect(result, roles);
      verify(() => mockRepository.getRoles()).called(1);
    });
  });

  group('Users Providers State', () {
    test('rolesProvider returns data from repository', () async {
      final container = createContainer();
      final roles = [const Role(id: 'r1', name: 'SuperAdmin')];
      when(() => mockRepository.getRoles()).thenAnswer((_) async => roles);

      final result = await container.read(rolesProvider.future);
      expect(result, roles);
    });

    test('directoratesProvider calls repository with correct ID', () async {
      final container = createContainer();
      when(() => mockRepository.getDirectorates(governorateId: 'g1'))
          .thenAnswer((_) async => []);

      await container.read(directoratesProvider('g1').future);

      verify(() => mockRepository.getDirectorates(governorateId: 'g1')).called(1);
    });
  });
}
