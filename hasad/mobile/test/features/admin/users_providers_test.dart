import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/token_refresher.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/features/admin/data/users_repository.dart';
import 'package:mobile/features/admin/domain/role.dart';
import 'package:mobile/features/admin/presentation/users_providers.dart' as admin;
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/features/location/presentation/location_providers.dart' as loc;
import 'package:mocktail/mocktail.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockTokenRefresher extends Mock implements TokenRefresher {}

class MockDio extends Mock implements Dio {}

class MockLocationRepository extends Mock implements LocationRepository {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier({required AuthStatus status, AuthSession? session})
    : super(
        MockAuthRepository(),
        MockSecureStorageService(),
        MockTokenRefresher(),
      ) {
    state = AuthState(status: status, session: session);
  }

  @override
  Future<void> restoreSession() async {}
}

void main() {
  late MockUsersRepository mockRepository;
  late MockLocationRepository mockLocationRepo;

  setUp(() {
    mockRepository = MockUsersRepository();
    mockLocationRepo = MockLocationRepository();
  });

  ProviderContainer createContainer({
    AuthStatus status = AuthStatus.authenticated,
    List<String> roles = const ['SuperAdmin'],
    LocationRepository? locationRepo,
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
        admin.usersRepositoryProvider.overrideWithValue(mockRepository),
        loc.locationRepositoryProvider.overrideWithValue(locationRepo ?? mockLocationRepo),
        authProvider.overrideWith(
          (ref) => FakeAuthNotifier(status: status, session: session),
        ),
        apiDioProvider.overrideWithValue(MockDio()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Users Providers Security', () {
    test('rolesProvider throws when user is not SuperAdmin', () async {
      final container = createContainer(roles: ['AgriculturalEngineer']);

      await expectLater(
        container.read(admin.rolesProvider.future),
        throwsA(
          predicate((e) => e.toString().contains('SuperAdmin access required')),
        ),
      );
    });

    test('rolesProvider succeeds when user is SuperAdmin', () async {
      final container = createContainer(roles: ['SuperAdmin']);
      final roles = [
        const Role(id: 'r1', name: 'SuperAdmin', scopeType: 'Global'),
      ];
      when(() => mockRepository.getRoles()).thenAnswer((_) async => roles);

      final result = await container.read(admin.rolesProvider.future);

      expect(result, roles);
      verify(() => mockRepository.getRoles()).called(1);
    });
  });

  group('Users Providers State', () {
    test('rolesProvider returns data from repository', () async {
      final container = createContainer();
      final roles = [
        const Role(id: 'r1', name: 'SuperAdmin', scopeType: 'Global'),
      ];
      when(() => mockRepository.getRoles()).thenAnswer((_) async => roles);

      final result = await container.read(admin.rolesProvider.future);
      expect(result, roles);
    });

    test('directoratesProvider calls repository with correct ID', () async {
      final container = createContainer();
      when(
        () => mockLocationRepo.getDirectorates(governorateId: 'g1'),
      ).thenAnswer((_) async => []);

      await container.read(admin.directoratesProvider('g1').future);

      verify(
        () => mockLocationRepo.getDirectorates(governorateId: 'g1'),
      ).called(1);
    });

    test(
      'userManagementProvider.createUser calls repository and updates state',
      () async {
        final container = createContainer();
        when(
          () => mockRepository.createUser(
            fullName: any(named: 'fullName'),
            userName: any(named: 'userName'),
            email: any(named: 'email'),
            phoneNumber: any(named: 'phoneNumber'),
            password: any(named: 'password'),
            confirmPassword: any(named: 'confirmPassword'),
            role: any(named: 'role'),
            governorateId: any(named: 'governorateId'),
            directorateId: any(named: 'directorateId'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async {});

        final notifier = container.read(admin.userManagementProvider.notifier);
        await notifier.createUser(
          fullName: 'Test',
          userName: 'test',
          email: 't@t.com',
          phoneNumber: '1',
          password: 'p',
          confirmPassword: 'p',
          role: 'r',
          isActive: true,
        );

        expect(container.read(admin.userManagementProvider).success, true);
      },
    );
  });
}
