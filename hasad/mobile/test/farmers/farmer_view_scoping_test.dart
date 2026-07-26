import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MockSyncService extends Mock implements BackgroundSyncService {}
class MockRemoteRepository extends Mock implements FarmerRepository {}
class MockConnectivity extends Mock implements Connectivity {}
class MockAuthorizationService extends Mock implements AuthorizationService {}

void main() {
  late AppDatabase db;
  late MockSyncService mockSyncService;
  late MockRemoteRepository mockRemoteRepository;
  late MockConnectivity mockConnectivity;
  late MockAuthorizationService mockAuthService;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockSyncService();
    mockRemoteRepository = MockRemoteRepository();
    mockConnectivity = MockConnectivity();
    mockAuthService = MockAuthorizationService();
  });

  tearDown(() async {
    await db.close();
  });

  group('Farmer View Scoping', () {
    final session = AuthSession(
      userId: 'eng-1',
      email: 'engineer@example.com',
      roles: ['AgriculturalEngineer'],
      governorateId: 'GOV-A',
      directorateId: 'DIR-A1',
      fullName: 'Eng Ahmed',
      token: 'token',
      refreshToken: 'ref-token',
    );

    test('AgriculturalEngineer in All View can see farmers from other governorates', () async {
      final repository = OfflineFirstFarmerRepository(
        db,
        mockSyncService,
        mockRemoteRepository,
        mockConnectivity,
        mockAuthService,
        session,
      );

      // Add two farmers: one in GOV-A, one in GOV-B
      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'f-a',
        idNumber: const Value('1'),
        firstNameAr: const Value('Farmer A'),
        governorateId: const Value('GOV-A'),
        gender: const Value(1),
        updatedAt: Value(DateTime.now()),
      ));
      
      // Add a farm in DIR-A1 for f-a
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm-a',
        farmerId: 'f-a',
        localFarmName: 'Farm A',
        basin: 'B1',
        parcel: 'P1',
        area: 10.0,
        governorateId: 'GOV-A',
        directorateId: 'DIR-A1',
        localityId: 'L1',
      ));

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'f-b',
        idNumber: const Value('2'),
        firstNameAr: const Value('Farmer B'),
        governorateId: const Value('GOV-B'),
        gender: const Value(1),
        updatedAt: Value(DateTime.now()),
      ));

      // All View (isOperational: false)
      final allFarmers = await repository.getFarmers(isOperational: false);
      expect(allFarmers.length, 2);
      expect(allFarmers.any((f) => f.governorateId == 'GOV-A'), true);
      expect(allFarmers.any((f) => f.governorateId == 'GOV-B'), true);
    });

    test('AgriculturalEngineer in Operational View only sees farmers who have a farm in his directorate', () async {
      final repository = OfflineFirstFarmerRepository(
        db,
        mockSyncService,
        mockRemoteRepository,
        mockConnectivity,
        mockAuthService,
        session,
      );

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'f-ops-1',
        idNumber: const Value('101'),
        firstNameAr: const Value('Ops Farmer 1'),
        governorateId: const Value('OTHER-GOV'),
        gender: const Value(1),
        updatedAt: Value(DateTime.now()),
      ));
      
      // Add a farm in DIR-A1 (User's Directorate) for f-ops-1
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm-ops-1',
        farmerId: 'f-ops-1',
        localFarmName: 'Farm in my dir',
        basin: 'B1',
        parcel: 'P1',
        area: 10.0,
        governorateId: 'GOV-A',
        directorateId: 'DIR-A1',
        localityId: 'L1',
      ));

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'f-ops-2',
        idNumber: const Value('102'),
        firstNameAr: const Value('Ops Farmer 2'),
        governorateId: const Value('GOV-A'), // Lives in same gov, but no farm in dir
        gender: const Value(1),
        updatedAt: Value(DateTime.now()),
      ));
      
      // Add a farm in OTHER-DIR for f-ops-2
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm-ops-2',
        farmerId: 'f-ops-2',
        localFarmName: 'Farm in other dir',
        basin: 'B1',
        parcel: 'P1',
        area: 10.0,
        governorateId: 'GOV-A',
        directorateId: 'OTHER-DIR',
        localityId: 'L1',
      ));

      // Operational View (isOperational: true)
      final operationalFarmers = await repository.getFarmers(isOperational: true);
      expect(operationalFarmers.length, 1);
      expect(operationalFarmers.first.id, 'f-ops-1');
    });

    test('watchFarmers in All View limits to 10 records', () async {
      final repository = OfflineFirstFarmerRepository(
        db,
        mockSyncService,
        mockRemoteRepository,
        mockConnectivity,
        mockAuthService,
        session,
      );

      // Insert 15 farmers
      for (int i = 0; i < 15; i++) {
        await db.into(db.farmers).insert(FarmersCompanion.insert(
          id: 'f-$i',
          idNumber: Value('id-$i'),
          firstNameAr: Value('Farmer $i'),
          governorateId: const Value('GOV-ANY'),
          gender: const Value(1),
          createdAt: Value(DateTime.now().add(Duration(minutes: i))),
          updatedAt: Value(DateTime.now()),
        ));
      }

      final stream = repository.watchFarmers(filter: const FarmerFilter(isOperational: false));
      final result = await stream.first;
      
      expect(result.length, 10);
      // Should be the latest ones (f-14 down to f-5)
      expect(result.first.id, 'f-14');
    });
  });
}
