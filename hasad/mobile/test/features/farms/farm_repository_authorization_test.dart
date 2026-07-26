import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/data/offline_first_farm_repository.dart';

class MockBackgroundSyncService extends Mock implements BackgroundSyncService {}
class MockAuthorizationService extends Mock implements AuthorizationService {}

void main() {
  late AppDatabase db;
  late MockBackgroundSyncService mockSyncService;
  late MockAuthorizationService mockAuthService;
  late OfflineFirstFarmRepository repo;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockBackgroundSyncService();
    mockAuthService = MockAuthorizationService();
    repo = OfflineFirstFarmRepository(db, mockSyncService, mockAuthService);
  });

  tearDown(() async {
    await db.close();
  });

  final testFarm = Farm(
    id: 'f1',
    farmerId: 'farmer1',
    localFarmName: 'Test Farm',
    ownershipTypeId: 1,
    governorateId: 'G1',
    directorateId: 'D1',
    localityId: 'L1',
    basin: 'B1',
    parcel: 'P1',
    area: 10,
    areaUnitId: 1,
    agriculturalSectorId: 1,
    politicalClassificationId: 1,
  );

  test('createFarm throws FarmException when unauthorized', () async {
    when(() => mockAuthService.canManageFarms()).thenReturn(false);

    expect(
      () => repo.createFarm(testFarm),
      throwsA(isA<FarmException>().having((e) => e.errors, 'errors', contains(contains('Access Denied')))),
    );
  });

  test('updateFarm throws FarmException when unauthorized', () async {
    when(() => mockAuthService.canManageFarms()).thenReturn(false);

    expect(
      () => repo.updateFarm(testFarm),
      throwsA(isA<FarmException>().having((e) => e.errors, 'errors', contains(contains('Access Denied')))),
    );
  });

  test('deleteFarm throws FarmException when unauthorized', () async {
    // Insert a farm first
    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: 'f1',
      farmerId: 'farmer1',
      localFarmName: 'Test Farm',
      governorateId: 'G1',
      directorateId: 'D1',
      localityId: 'L1',
      basin: 'B1',
      parcel: 'P1',
      area: 10,
    ));

    when(() => mockAuthService.canManageFarms()).thenReturn(false);

    expect(
      () => repo.deleteFarm('f1'),
      throwsA(isA<FarmException>().having((e) => e.errors, 'errors', contains(contains('Access Denied')))),
    );
  });
}
