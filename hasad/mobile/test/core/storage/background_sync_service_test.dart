import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}

class MockFarmRepository extends Mock implements FarmRepository {}

class MockDamageReportRepository extends Mock
    implements DamageReportRepository {}

class MockAttachmentRepository extends Mock
    implements DamageReportAttachmentRepository {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockFarmerRepository mockFarmerRepo;
  late MockFarmRepository mockFarmRepo;
  late MockDamageReportRepository mockDamageRepo;
  late MockAttachmentRepository mockAttachmentRepo;
  late MockConnectivity mockConnectivity;
  late BackgroundSyncService syncService;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    mockFarmerRepo = MockFarmerRepository();
    mockFarmRepo = MockFarmRepository();
    mockDamageRepo = MockDamageReportRepository();
    mockAttachmentRepo = MockAttachmentRepository();
    mockConnectivity = MockConnectivity();

    when(
      () => mockConnectivity.onConnectivityChanged,
    ).thenAnswer((_) => const Stream.empty());

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    syncService = BackgroundSyncService(
      db,
      mockFarmerRepo,
      mockFarmRepo,
      mockDamageRepo,
      mockAttachmentRepo,
      mockConnectivity,
    );

    registerFallbackValue(
      Farmer(
        id: '',
        idTypeId: 1,
        idNumber: '',
        firstNameAr: '',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: '',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1900),
        gender: Gender.unspecified,
        phoneNumber: '',
        familySize: 1,
        governorateId: '',
        localityId: '',
        address: '',
        rowVersion: '',
      ),
    );
    registerFallbackValue(
      const Farm(
        id: '',
        farmerId: '',
        localFarmName: '',
        ownershipTypeId: 1,
        governorateId: '',
        directorateId: '',
        localityId: '',
        basin: '',
        parcel: '',
        area: 0,
        areaUnitId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
      ),
    );
    registerFallbackValue(
      DamageReport(
        id: '',
        farmId: '',
        farmerId: '',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        governorateId: '',
        directorateId: '',
        localityId: '',
        statusId: '',
        notes: '',
      ),
    );
    registerFallbackValue(
      const DamageReportAttachment(id: '', damageReportId: '', localPath: ''),
    );
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  test('processQueue syncs create farmer item to remote', () async {
    const localId = 'local-123';
    final farmer = Farmer(
      id: localId,
      idTypeId: 1,
      idNumber: '12345',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.male,
      phoneNumber: '0599',
      familySize: 5,
      governorateId: 'G1',
      localityId: 'L1',
      address: 'Test Address',
      rowVersion: '',
    );

    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: localId,
            idTypeId: const Value(1),
            idNumber: const Value('12345'),
            firstNameAr: const Value('أحمد'),
            fatherNameAr: const Value('محمد'),
            grandfatherNameAr: const Value('علي'),
            familyNameAr: const Value('محمود'),
            firstNameEn: const Value('Ahmed'),
            fatherNameEn: const Value('Mohammed'),
            grandfatherNameEn: const Value('Ali'),
            familyNameEn: const Value('Mahmoud'),
            birthDate: Value(DateTime(1985, 5, 10)),
            gender: const Value(1),
            phoneNumber: const Value('0599'),
            familySize: const Value(5),
            governorateId: const Value('G1'),
            localityId: const Value('L1'),
            address: const Value('Test Address'),
            syncStatus: const Value('pending'),
          ),
        );

    await db
        .into(db.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            id: 'queue-1',
            localId: localId,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
          ),
        );

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(
      () => mockFarmerRepo.createFarmer(any()),
    ).thenAnswer((_) async => farmer.copyWith(id: localId, rowVersion: 'v1'));

    await syncService.processQueue();

    final localFarmer = await (db.select(
      db.farmers,
    )..where((t) => t.id.equals(localId))).getSingle();
    expect(localFarmer.rowVersion, 'v1');
    expect(localFarmer.syncStatus, 'completed');

    final queueItem = await db.select(db.syncQueue).getSingle();
    expect(queueItem.status, 'completed');
  });

  test('processQueue handles items added during processing (drain loop)', () async {
    const localId1 = 'local-1';
    const localId2 = 'local-2';
    final farmer1 = Farmer(
      id: localId1,
      idTypeId: 1,
      idNumber: '1',
      firstNameAr: 'N1',
      fatherNameAr: '',
      grandfatherNameAr: '',
      familyNameAr: '',
      firstNameEn: '',
      fatherNameEn: '',
      grandfatherNameEn: '',
      familyNameEn: '',
      birthDate: DateTime(1990),
      gender: Gender.male,
      phoneNumber: '',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: '',
      rowVersion: '',
    );
    final farmer2 = farmer1.copyWith(id: localId2, idNumber: '2');

    // Setup connectivity
    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    // Mock remote calls
    when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((invocation) async {
      final f = invocation.positionalArguments[0] as Farmer;
      if (f.id == localId1) {
        // While processing first item, add second item to queue
        await db.into(db.farmers).insert(
              FarmersCompanion.insert(
                id: localId2,
                idTypeId: const Value(1),
                idNumber: const Value('2'),
                firstNameAr: const Value('N2'),
                fatherNameAr: const Value(''),
                grandfatherNameAr: const Value(''),
                familyNameAr: const Value(''),
                firstNameEn: const Value(''),
                fatherNameEn: const Value(''),
                grandfatherNameEn: const Value(''),
                familyNameEn: const Value(''),
                birthDate: Value(DateTime(1990)),
                gender: const Value(1),
                phoneNumber: const Value(''),
                familySize: const Value(1),
                governorateId: const Value('G1'),
                localityId: const Value('L1'),
                address: const Value(''),
                syncStatus: const Value('pending'),
              ),
            );
        await db.into(db.syncQueue).insert(
              SyncQueueCompanion.insert(
                id: 'queue-2',
                localId: localId2,
                entityType: 'farmer',
                operation: 'create',
                data: jsonEncode(farmer2.toJson()),
              ),
            );
        return f.copyWith(rowVersion: 'v1');
      }
      return f.copyWith(rowVersion: 'v2');
    });

    // Add first item and start sync
    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: localId1,
            idTypeId: const Value(1),
            idNumber: const Value('1'),
            firstNameAr: const Value('N1'),
            fatherNameAr: const Value(''),
            grandfatherNameAr: const Value(''),
            familyNameAr: const Value(''),
            firstNameEn: const Value(''),
            fatherNameEn: const Value(''),
            grandfatherNameEn: const Value(''),
            familyNameEn: const Value(''),
            birthDate: Value(DateTime(1990)),
            gender: const Value(1),
            phoneNumber: const Value(''),
            familySize: const Value(1),
            governorateId: const Value('G1'),
            localityId: const Value('L1'),
            address: const Value(''),
            syncStatus: const Value('pending'),
          ),
        );
    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: 'queue-1',
            localId: localId1,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer1.toJson()),
          ),
        );

    await syncService.processQueue();

    // Verify both items processed
    final farmers = await db.select(db.farmers).get();
    expect(farmers.length, 2);
    expect(farmers.every((f) => f.syncStatus == 'completed'), true);

    final queueItems = await db.select(db.syncQueue).get();
    expect(queueItems.length, 2);
    expect(queueItems.every((q) => q.status == 'completed'), true);
  });

  test('initialize() triggers processQueue and processes existing items', () async {
    const localId = 'startup-1';
    final farmer = Farmer(
      id: localId,
      idTypeId: 1,
      idNumber: 'S1',
      firstNameAr: 'Startup',
      fatherNameAr: '',
      grandfatherNameAr: '',
      familyNameAr: '',
      firstNameEn: '',
      fatherNameEn: '',
      grandfatherNameEn: '',
      familyNameEn: '',
      birthDate: DateTime(1990),
      gender: Gender.male,
      phoneNumber: '',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: '',
      rowVersion: '',
    );

    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: localId,
            idTypeId: const Value(1),
            idNumber: const Value('S1'),
            firstNameAr: const Value('Startup'),
            fatherNameAr: const Value(''),
            grandfatherNameAr: const Value(''),
            familyNameAr: const Value(''),
            firstNameEn: const Value(''),
            fatherNameEn: const Value(''),
            grandfatherNameEn: const Value(''),
            familyNameEn: const Value(''),
            birthDate: Value(DateTime(1990)),
            gender: const Value(1),
            phoneNumber: const Value(''),
            familySize: const Value(1),
            governorateId: const Value('G1'),
            localityId: const Value('L1'),
            address: const Value(''),
            syncStatus: const Value('pending'),
          ),
        );
    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: 'q-startup',
            localId: localId,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
          ),
        );

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(
      () => mockFarmerRepo.createFarmer(any()),
    ).thenAnswer((_) async => farmer.copyWith(rowVersion: 'vs'));

    await syncService.initialize();

    final f = await (db.select(db.farmers)..where((t) => t.id.equals(localId)))
        .getSingle();
    expect(f.syncStatus, 'completed');
  });

  test('processQueue recovers stuck syncing items after timeout', () async {
    const localId = 'stuck-1';
    final farmer = Farmer(
      id: localId,
      idTypeId: 1,
      idNumber: 'ST1',
      firstNameAr: 'Stuck',
      fatherNameAr: '',
      grandfatherNameAr: '',
      familyNameAr: '',
      firstNameEn: '',
      fatherNameEn: '',
      grandfatherNameEn: '',
      familyNameEn: '',
      birthDate: DateTime(1990),
      gender: Gender.male,
      phoneNumber: '',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: '',
      rowVersion: '',
    );

    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: localId,
            idTypeId: const Value(1),
            idNumber: const Value('ST1'),
            firstNameAr: const Value('Stuck'),
            fatherNameAr: const Value(''),
            grandfatherNameAr: const Value(''),
            familyNameAr: const Value(''),
            firstNameEn: const Value(''),
            fatherNameEn: const Value(''),
            grandfatherNameEn: const Value(''),
            familyNameEn: const Value(''),
            birthDate: Value(DateTime(1990)),
            gender: const Value(1),
            phoneNumber: const Value(''),
            familySize: const Value(1),
            governorateId: const Value('G1'),
            localityId: const Value('L1'),
            address: const Value(''),
            syncStatus: const Value('syncing'),
          ),
        );

    // Insert as syncing but old
    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: 'q-stuck',
            localId: localId,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
            status: const Value('syncing'),
            lastAttemptAt: Value(
              DateTime.now().subtract(const Duration(minutes: 10)),
            ),
          ),
        );

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(
      () => mockFarmerRepo.createFarmer(any()),
    ).thenAnswer((_) async => farmer.copyWith(rowVersion: 'vstuck'));

    await syncService.processQueue();

    final f = await (db.select(db.farmers)..where((t) => t.id.equals(localId)))
        .getSingle();
    expect(f.syncStatus, 'completed');
  });

  test('processQueue propagates status to entity (syncing -> failed)', () async {
    const localId = 'fail-1';
    final farmer = Farmer(
      id: localId,
      idTypeId: 1,
      idNumber: 'F1',
      firstNameAr: 'Fail',
      fatherNameAr: '',
      grandfatherNameAr: '',
      familyNameAr: '',
      firstNameEn: '',
      fatherNameEn: '',
      grandfatherNameEn: '',
      familyNameEn: '',
      birthDate: DateTime(1990),
      gender: Gender.male,
      phoneNumber: '',
      familySize: 1,
      governorateId: 'G1',
      localityId: 'L1',
      address: '',
      rowVersion: '',
    );

    await db.into(db.farmers).insert(
          FarmersCompanion.insert(
            id: localId,
            idTypeId: const Value(1),
            idNumber: const Value('F1'),
            firstNameAr: const Value('Fail'),
            fatherNameAr: const Value(''),
            grandfatherNameAr: const Value(''),
            familyNameAr: const Value(''),
            firstNameEn: const Value(''),
            fatherNameEn: const Value(''),
            grandfatherNameEn: const Value(''),
            familyNameEn: const Value(''),
            birthDate: Value(DateTime(1990)),
            gender: const Value(1),
            phoneNumber: const Value(''),
            familySize: const Value(1),
            governorateId: const Value('G1'),
            localityId: const Value('L1'),
            address: const Value(''),
            syncStatus: const Value('pending'),
          ),
        );
    await db.into(db.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: 'q-fail',
            localId: localId,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(farmer.toJson()),
          ),
        );

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(
      () => mockFarmerRepo.createFarmer(any()),
    ).thenThrow(SyncException(['NETWORK_ERROR']));

    await syncService.processQueue();

    final f = await (db.select(db.farmers)..where((t) => t.id.equals(localId)))
        .getSingle();
    expect(f.syncStatus, 'failed');
  });

  test(
    'processQueue marks item as invalid on FarmerValidationException and stops retrying',
    () async {
      const localId = 'invalid-1';
      final farmer = Farmer(
        id: localId,
        idTypeId: 1,
        idNumber: 'I1',
        firstNameAr: 'Invalid',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: '',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime(1990),
        gender: Gender.male,
        phoneNumber: '',
        familySize: 1,
        governorateId: 'G1',
        localityId: 'L1',
        address: '',
        rowVersion: '',
      );

      await db.into(db.farmers).insert(
        FarmersCompanion.insert(
          id: localId,
          idTypeId: const Value(1),
          idNumber: const Value('I1'),
          firstNameAr: const Value('Invalid'),
          fatherNameAr: const Value(''),
          grandfatherNameAr: const Value(''),
          familyNameAr: const Value(''),
          firstNameEn: const Value(''),
          fatherNameEn: const Value(''),
          grandfatherNameEn: const Value(''),
          familyNameEn: const Value(''),
          birthDate: Value(DateTime(1990)),
          gender: const Value(1),
          phoneNumber: const Value(''),
          familySize: const Value(1),
          governorateId: const Value('G1'),
          localityId: const Value('L1'),
          address: const Value(''),
          syncStatus: const Value('pending'),
        ),
      );
      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-invalid',
          localId: localId,
          entityType: 'farmer',
          operation: 'create',
          data: jsonEncode(farmer.toJson()),
        ),
      );

      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(
        () => mockFarmerRepo.createFarmer(any()),
      ).thenThrow(SyncValidationException(['Gender must be Male or Female.']));

      await syncService.processQueue();

      final f = await (db.select(db.farmers)..where((t) => t.id.equals(localId)))
          .getSingle();
      expect(f.syncStatus, 'invalid');
      expect(f.lastSyncError, contains('Gender must be Male or Female.'));

      final q = await db.select(db.syncQueue).getSingle();
      expect(q.status, 'invalid');

      // Try again, it should NOT be retried
      clearInteractions(mockFarmerRepo);
      await syncService.processQueue();
      verifyNever(() => mockFarmerRepo.createFarmer(any()));
    },
  );

  test('addToQueue preserves CREATE operation during offline edits', () async {
    const localId = 'collapsing-1';
    final data1 = {'firstNameAr': 'Initial'};
    final data2 = {'firstNameAr': 'Updated'};

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    // 1. Initial CREATE
    await syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: data1,
    );

    var items = await db.select(db.syncQueue).get();
    expect(items.length, 1);
    expect(items.first.operation, 'create');

    // 2. Offline UPDATE
    await syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'update',
      data: data2,
    );

    items = await db.select(db.syncQueue).get();
    expect(items.length, 1);
    expect(items.first.operation, 'create'); // Preserved!
    expect(jsonDecode(items.first.data)['firstNameAr'], 'Updated');
  });

  test('addToQueue handles multiple offline updates by collapsing', () async {
    const localId = 'multi-1';

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    await syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: {'v': 1},
    );

    for (int i = 2; i <= 5; i++) {
      await syncService.addToQueue(
        localId: localId,
        entityType: 'farmer',
        operation: 'update',
        data: {'v': i},
      );
    }

    final items = await db.select(db.syncQueue).get();
    expect(items.length, 1);
    expect(items.first.operation, 'create');
    expect(jsonDecode(items.first.data)['v'], 5);
  });

  test('addToQueue resets status to pending and clears errors on retry', () async {
    const localId = 'retry-1';

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    // 1. Initial task that failed/invalid
    await db.into(db.syncQueue).insert(
      SyncQueueCompanion.insert(
        id: 'q1',
        localId: localId,
        entityType: 'farmer',
        operation: 'create',
        data: '{}',
        status: const Value('invalid'),
        lastError: const Value('Old Error'),
        retryCount: const Value(1),
      ),
    );

    // 2. Call addToQueue (e.g. user fixed data and saved)
    await syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'update',
      data: {'fixed': true},
    );

    final item = await db.select(db.syncQueue).getSingle();
    expect(item.status, 'pending');
    expect(item.lastError, null);
    expect(item.retryCount, 0);
    expect(item.operation, 'create'); // Preserved
  });

  test('addToQueue uses UPDATE operation for already synced farmer', () async {
    const localId = 'synced-1';

    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    // Record has no pending task in queue (it's already synced)
    await syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'update',
      data: {'v': 1},
    );

    final item = await db.select(db.syncQueue).getSingle();
    expect(item.operation, 'update');
  });

  group('Delete Lifecycle', () {
    test('processQueue performs remote DELETE then local hard delete', () async {
      const localId = 'delete-1';
      const serverId = 'remote-1';

      // 1. Setup local record as pending delete
      await db.into(db.farmers).insert(
            FarmersCompanion.insert(
              id: localId,
              serverId: const Value(serverId),
              idTypeId: const Value(1),
              idNumber: const Value('1'),
              firstNameAr: const Value('To Delete'),
              fatherNameAr: const Value(''),
              grandfatherNameAr: const Value(''),
              familyNameAr: const Value(''),
              firstNameEn: const Value(''),
              fatherNameEn: const Value(''),
              grandfatherNameEn: const Value(''),
              familyNameEn: const Value(''),
              birthDate: Value(DateTime(1990)),
              gender: const Value(1),
              phoneNumber: const Value(''),
              familySize: const Value(1),
              governorateId: const Value('G1'),
              localityId: const Value('L1'),
              address: const Value(''),
              syncStatus: const Value('pending'),
              isPendingDelete: const Value(true),
            ),
          );

      await db.into(db.syncQueue).insert(
            SyncQueueCompanion.insert(
              id: 'q-delete',
              localId: localId,
              entityType: 'farmer',
              operation: 'delete',
              data: jsonEncode({'id': serverId}),
            ),
          );

      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );
      when(() => mockFarmerRepo.deleteFarmer(serverId)).thenAnswer(
        (_) async => {},
      );

      await syncService.processQueue();

      // Verified hard deleted locally
      final farmers = await db.select(db.farmers).get();
      expect(farmers, isEmpty);

      final queueItems = await db.select(db.syncQueue).get();
      expect(queueItems.first.status, 'completed');
    });

    test('addToQueue removes record immediately when deleting unsynced CREATE', () async {
      const localId = 'cancel-create-1';

      // 1. Initial CREATE offline
      await db.into(db.farmers).insert(
            FarmersCompanion.insert(
              id: localId,
              idTypeId: const Value(1),
              idNumber: const Value('1'),
              firstNameAr: const Value('New'),
              fatherNameAr: const Value(''),
              grandfatherNameAr: const Value(''),
              familyNameAr: const Value(''),
              firstNameEn: const Value(''),
              fatherNameEn: const Value(''),
              grandfatherNameEn: const Value(''),
              familyNameEn: const Value(''),
              birthDate: Value(DateTime(1990)),
              gender: const Value(1),
              phoneNumber: const Value(''),
              familySize: const Value(1),
              governorateId: const Value('G1'),
              localityId: const Value('L1'),
              address: const Value(''),
              syncStatus: const Value('pending'),
            ),
          );
      await syncService.addToQueue(
        localId: localId,
        entityType: 'farmer',
        operation: 'create',
        data: {'firstNameAr': 'New'},
      );

      // 2. DELETE before sync
      await syncService.addToQueue(
        localId: localId,
        entityType: 'farmer',
        operation: 'delete',
        data: {},
      );

      // Verified both record and task removed immediately
      final farmers = await db.select(db.farmers).get();
      expect(farmers, isEmpty);

      final queue = await db.select(db.syncQueue).get();
      expect(queue, isEmpty);
    });
  });

  group('Generic Operation Collapsing', () {
    test('addToQueue preserves CREATE for Farm entity', () async {
      const localId = 'farm-collapsing';
      
      await syncService.addToQueue(
        localId: localId,
        entityType: 'farm',
        operation: 'create',
        data: {'v': 1},
      );
      
      await syncService.addToQueue(
        localId: localId,
        entityType: 'farm',
        operation: 'update',
        data: {'v': 2},
      );
      
      final items = await db.select(db.syncQueue).get();
      expect(items.length, 1);
      expect(items.first.operation, 'create');
      expect(jsonDecode(items.first.data)['v'], 2);
    });

    test('addToQueue preserves CREATE for DamageReport entity', () async {
      const localId = 'report-collapsing';
      
      await syncService.addToQueue(
        localId: localId,
        entityType: 'damage_report',
        operation: 'create',
        data: {'v': 1},
      );
      
      await syncService.addToQueue(
        localId: localId,
        entityType: 'damage_report',
        operation: 'update',
        data: {'v': 2},
      );
      
      final items = await db.select(db.syncQueue).get();
      expect(items.length, 1);
      expect(items.first.operation, 'create');
      expect(jsonDecode(items.first.data)['v'], 2);
    });
  });

  group('Cascading Hard Delete', () {
    test('_hardDeleteLocalEntity removes items and attachments for damage_report', () async {
      const reportId = 'report-1';
      
      await db.into(db.damageReports).insert(
        DamageReportsCompanion.insert(
          id: reportId,
          farmId: 'f1',
          farmerId: 'fr1',
          damageDate: DateTime.now(),
          documentationDate: DateTime.now(),
          governorateId: 'g1',
          directorateId: 'd1',
          localityId: 'l1',
          statusId: 's1',
          notes: '',
        ),
      );
      
      await db.into(db.damageItems).insert(
        DamageItemsCompanion.insert(
          id: 'item-1',
          damageReportId: reportId,
          classificationId: const Value(1),
          costingSheetId: const Value('cs1'),
          calculatedUnitPrice: const Value(100.0),
          measurementUnitSnapshot: const Value('Tree'),
          affectedArea: 1,
          damagePercentage: 10,
          quantity: 1,
          estimatedLoss: 100,
        ),
      );

      // Trigger hard delete via sync service logic (internal helper)
      // We can't call _hardDeleteLocalEntity directly if it's private, but it's used by _syncXXX and addToQueue
      // Let's use addToQueue logic for CREATE + DELETE collapsing to trigger it
      await syncService.addToQueue(
        localId: reportId,
        entityType: 'damage_report',
        operation: 'create',
        data: {},
      );
      
      await syncService.addToQueue(
        localId: reportId,
        entityType: 'damage_report',
        operation: 'delete',
        data: {},
      );
      
      final reports = await db.select(db.damageReports).get();
      expect(reports, isEmpty);
      
      final items = await db.select(db.damageItems).get();
      expect(items, isEmpty);
    });
  });
}
