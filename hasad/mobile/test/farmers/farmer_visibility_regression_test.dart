import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';
import 'package:drift/native.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart';

import '../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late OfflineFirstFarmerRepository repository;
  late MockBackgroundSyncService mockSyncService;
  late MockRef mockRef;
  late MockFarmerRepository mockRemoteRepository;

  const jerichoGovId = 'jericho-gov-id';
  const jerichoDirId = 'jericho-dir-id';
  const nablusGovId = 'nablus-gov-id';

  final engineerSession = AuthSession(
    userId: 'eng-1',
    fullName: 'Engineer',
    email: 'eng@hasad.ps',
    roles: ['AgriculturalEngineer'],
    governorateId: jerichoGovId,
    directorateId: jerichoDirId,
    token: '',
    refreshToken: '',
  );

  setUp(() async {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockSyncService = MockBackgroundSyncService();
    mockRemoteRepository = MockFarmerRepository();
    mockRef = MockRef();
    when(() => mockRef.read(syncServiceProvider)).thenReturn(mockSyncService);

    final mockConnectivity = MockConnectivity();

    repository = OfflineFirstFarmerRepository(
      db,
      mockRef,
      mockRemoteRepository,
      mockConnectivity,
      AuthorizationService(engineerSession),
      engineerSession,
    );

    // Seed Data
    // 1. Farmer in Jericho (Residence Locality A)
    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: 'farmer-1',
      firstNameAr: const Value('Farmer 1'),
      governorateId: Value(jerichoGovId),
      localityId: const Value('locality-a'),
    ));

    // 2. Farmer in Jericho (Residence Locality B)
    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: 'farmer-2',
      firstNameAr: const Value('Farmer 2'),
      governorateId: Value(jerichoGovId),
      localityId: const Value('locality-b'),
    ));

    // 3. Farmer in Nablus
    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: 'farmer-3',
      firstNameAr: const Value('Farmer 3'),
      governorateId: Value(nablusGovId),
      localityId: const Value('locality-c'),
    ));

    // 4. Farm for Farmer 1 in Jericho Directorate
    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: 'farm-1',
      farmerId: 'farmer-1',
      localFarmName: 'Farm 1',
      governorateId: jerichoGovId,
      directorateId: jerichoDirId,
      localityId: 'locality-a',
      area: 10.0,
      basin: '1',
      parcel: '1',
    ));

    // 5. Farm for Farmer 2 in ANOTHER Directorate (e.g., Nablus)
    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: 'farm-2',
      farmerId: 'farmer-2',
      localFarmName: 'Farm 2',
      governorateId: jerichoGovId,
      directorateId: 'other-dir-id',
      localityId: 'locality-b',
      area: 5.0,
      basin: '2',
      parcel: '2',
    ));
  });

  tearDown(() async {
    await db.close();
  });

  test('Scenario 1: All View returns latest farmers regardless of governorate', () async {
    final farmers = await repository.watchFarmers(
      filter: const FarmerFilter(isOperational: false),
    ).first;

    expect(farmers.length, 3);
    expect(farmers.any((f) => f.id == 'farmer-1'), true);
    expect(farmers.any((f) => f.id == 'farmer-2'), true);
    expect(farmers.any((f) => f.id == 'farmer-3'), true); // Now visible in All View
  });

  test('Scenario 2: Operational View returns only farmers with farms in user directorate', () async {
    final farmers = await repository.watchFarmers(
      filter: const FarmerFilter(isOperational: true),
    ).first;

    expect(farmers.length, 1);
    expect(farmers.first.id, 'farmer-1');
  });

  test('Scenario 3: Farmer with no farm is excluded from Operational View', () async {
    // Delete Farm 1
    await (db.delete(db.farms)..where((t) => t.id.equals('farm-1'))).go();

    final farmers = await repository.watchFarmers(
      filter: const FarmerFilter(isOperational: true),
    ).first;

    expect(farmers.length, 0);
    
    // But still visible in All View
    final allFarmers = await repository.watchFarmers(
      filter: const FarmerFilter(isOperational: false),
    ).first;
    expect(allFarmers.length, 3);
  });
}
