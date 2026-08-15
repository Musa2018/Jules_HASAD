import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

import '../../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late MockFarmerRepository farmerRepo;
  late MockFarmRepository farmRepo;
  late MockDamageReportRepository reportRepo;
  late MockDamageReportAttachmentRepository attachmentRepo;
  late MockConnectivity connectivity;
  late BackgroundSyncService syncService;

  setUpAll(() {
    registerFallbackValue(
      Farmer(
        id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '',
        grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '',
        grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1990),
        gender: Gender.male, phoneNumber: '', familySize: 1, governorateId: '',
        localityId: '', address: '', rowVersion: '',
      ),
    );
    registerFallbackValue(
      const Farm(
        id: '', farmerId: '', localFarmName: '', ownershipTypeId: 1,
        governorateId: '', directorateId: '', localityId: '', basin: '', parcel: '',
        area: 0.0, areaUnitId: 1, agriculturalSectorId: 1, politicalClassificationId: 1,
      ),
    );
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    farmerRepo = MockFarmerRepository();
    farmRepo = MockFarmRepository();
    reportRepo = MockDamageReportRepository();
    attachmentRepo = MockDamageReportAttachmentRepository();
    connectivity = MockConnectivity();

    syncService = BackgroundSyncService(
      db, farmerRepo, farmRepo, reportRepo, attachmentRepo, connectivity,
    );

    when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  tearDown(() async {
    await db.close();
  });

  test('Sync handles late-binding server IDs in dependent records', () async {
    // 1. Setup offline data: Farmer and Farm (both pending)
    const localFarmerId = 'f-local';
    const localFarmId = 'farm-local';
    const serverFarmerId = 'f-server';
    const serverFarmId = 'farm-server';

    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: localFarmerId,
      idNumber: const drift.Value('123'),
      idTypeId: const drift.Value(1),
      firstNameAr: const drift.Value('Ar'),
      fatherNameAr: const drift.Value(''), grandfatherNameAr: const drift.Value(''), familyNameAr: const drift.Value(''),
      firstNameEn: const drift.Value('En'), fatherNameEn: const drift.Value(''), grandfatherNameEn: const drift.Value(''), familyNameEn: const drift.Value(''),
      birthDate: drift.Value(DateTime(1990)),
      gender: drift.Value(Gender.male.index),
      phoneNumber: const drift.Value('555'),
      familySize: const drift.Value(4),
      address: const drift.Value('Addr'),
      syncStatus: const drift.Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      localId: localFarmerId,
      entityType: 'farmer',
      operation: 'create',
      data: '{}',
      status: 'pending',
      createdAt: DateTime.now(),
    ));

    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: localFarmId,
      farmerId: localFarmerId, // Using local ID initially
      localFarmName: 'Farm',
      ownershipTypeId: const drift.Value(1),
      governorateId: 'gov', directorateId: 'dir', localityId: 'loc',
      basin: 'b', parcel: 'p',
      area: 10, areaUnitId: const drift.Value(1),
      agriculturalSectorId: const drift.Value(1),
      politicalClassificationId: const drift.Value(1),
      syncStatus: const drift.Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      localId: localFarmId,
      entityType: 'farm',
      operation: 'create',
      data: jsonEncode({'farmerId': localFarmerId}),
      status: 'pending',
      createdAt: DateTime.now().add(const Duration(seconds: 1)),
    ));

    // 2. Mock responses
    when(() => farmerRepo.createFarmer(any())).thenAnswer((_) async => 
      Farmer(
        id: localFarmerId, serverId: serverFarmerId, idNumber: '123', idTypeId: 1,
        firstNameAr: 'Ar', fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: 'En', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1990), gender: Gender.male, phoneNumber: '555',
        familySize: 4, address: 'Addr', rowVersion: 'v1',
      )
    );

    when(() => farmRepo.createFarm(any())).thenAnswer((invocation) async {
      final farm = invocation.positionalArguments[0] as Farm;
      // VERIFY: The farm passed to the remote repo MUST have the serverFarmerId
      expect(farm.farmerId, serverFarmerId, reason: 'Farm must be updated with server farmer ID before remote call');
      
      return farm.copyWith(serverId: serverFarmId);
    });

    // 3. Run sync
    await syncService.processQueue();

    // 4. Verify results
    final syncedFarm = await (db.select(db.farms)..where((t) => t.id.equals(localFarmId))).getSingle();
    expect(syncedFarm.serverId, serverFarmId);
    expect(syncedFarm.farmerId, serverFarmerId);
  });

  test('Sync correctly handles existing server IDs (no re-binding needed)', () async {
    const localFarmerId = 'f1';
    const serverFarmerId = 'sf1';
    const localFarmId = 'farm1';

    // Farmer is already synced
    await db.into(db.farmers).insert(FarmersCompanion.insert(
      id: localFarmerId,
      serverId: drift.Value(serverFarmerId),
      idNumber: const drift.Value('123'), idTypeId: const drift.Value(1),
      firstNameAr: const drift.Value('Ar'), fatherNameAr: const drift.Value(''), grandfatherNameAr: const drift.Value(''), familyNameAr: const drift.Value(''),
      firstNameEn: const drift.Value('En'), fatherNameEn: const drift.Value(''), grandfatherNameEn: const drift.Value(''), familyNameEn: const drift.Value(''),
      birthDate: drift.Value(DateTime(1990)), gender: drift.Value(Gender.male.index), phoneNumber: const drift.Value('555'),
      familySize: const drift.Value(4), address: const drift.Value('Addr'),
      syncStatus: const drift.Value('completed'),
    ));

    // Farm is pending
    await db.into(db.farms).insert(FarmsCompanion.insert(
      id: localFarmId,
      farmerId: serverFarmerId,
      localFarmName: 'Farm',
      ownershipTypeId: const drift.Value(1),
      governorateId: 'gov', directorateId: 'dir', localityId: 'loc',
      basin: 'b', parcel: 'p',
      area: 10, areaUnitId: const drift.Value(1),
      agriculturalSectorId: const drift.Value(1),
      politicalClassificationId: const drift.Value(1),
      syncStatus: const drift.Value('pending'),
    ));

    await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
      localId: localFarmId,
      entityType: 'farm',
      operation: 'create',
      data: jsonEncode({'farmerId': serverFarmerId}),
      status: 'pending',
      createdAt: DateTime.now(),
    ));

    when(() => farmRepo.createFarm(any())).thenAnswer((inv) async => (inv.positionalArguments[0] as Farm).copyWith(serverId: 'sfarm1'));

    await syncService.processQueue();

    verify(() => farmRepo.createFarm(any(that: predicate<Farm>((f) => f.farmerId == serverFarmerId)))).called(1);
  });
}
