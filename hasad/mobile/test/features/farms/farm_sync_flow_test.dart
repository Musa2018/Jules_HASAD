import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/data/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}
class MockFarmRepository extends Mock implements FarmRepository {}
class MockDamageReportRepository extends Mock implements DamageReportRepository {}
class MockAttachmentRepository extends Mock implements DamageReportAttachmentRepository {}
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

    when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

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
        id: 'fake',
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
      ),
    );
    registerFallbackValue(
      const Farm(
        id: 'fake',
        farmerId: 'f1',
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
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  group('Farm Sync Identity Flow', () {
    test('Full lifecycle: Create -> Sync -> Edit -> Sync Update', () async {
      const localClientId = 'client-uuid-123';
      const serverGuid = 'server-guid-456';
      const farmerId = 'farmer-guid-789';

      final farm = const Farm(
        id: localClientId,
        farmerId: farmerId,
        localFarmName: 'Green Farm',
        ownershipTypeId: 2, // Rented
        ownerFarmerId: 'owner-1',
        relationshipToOwnerId: 1,
        governorateId: 'G1',
        directorateId: 'D1',
        localityId: 'L1',
        basin: 'B1',
        parcel: 'P1',
        area: 100,
        areaUnitId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
      );

      // 1. Save locally as pending create
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localClientId,
          farmerId: farmerId,
          localFarmName: 'Green Farm',
          ownershipTypeId: const Value(2),
          ownerFarmerId: const Value('owner-1'),
          relationshipToOwnerId: const Value(1),
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 100,
          syncStatus: const Value('pending'),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-1',
          localId: localClientId,
          entityType: 'farm',
          operation: 'create',
          data: jsonEncode(farm.toJson()),
        ),
      );

      // 2. Mock Create API Response (maps server-side 'id' to 'serverId')
      when(() => mockFarmRepo.createFarm(any())).thenAnswer((_) async => farm.copyWith(
        serverId: serverGuid,
        rowVersion: 'v1',
      ));

      // 3. Process Create
      await syncService.processQueue();

      // 4. Verify serverId persisted locally
      final localAfterCreate = await (db.select(db.farms)..where((t) => t.id.equals(localClientId))).getSingle();
      expect(localAfterCreate.serverId, serverGuid);
      expect(localAfterCreate.syncStatus, 'completed');

      // 5. Simulate Edit: Change ownership to Owned (1)
      final updatedFarm = farm.copyWith(
        serverId: serverGuid,
        ownershipTypeId: 1, // Owned
        ownerFarmerId: null,
        relationshipToOwnerId: null,
        rowVersion: 'v1',
      );

      await (db.update(db.farms)..where((t) => t.id.equals(localClientId))).write(
        const FarmsCompanion(
          ownershipTypeId: Value(1),
          ownerFarmerId: Value(null),
          relationshipToOwnerId: Value(null),
          syncStatus: Value('pending'),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-2',
          localId: localClientId,
          entityType: 'farm',
          operation: 'update',
          data: jsonEncode(updatedFarm.toJson()),
        ),
      );

      // 6. Mock Update API
      // Capture the payload to verify it uses serverGuid as 'id'
      late Farm capturedFarm;
      when(() => mockFarmRepo.updateFarm(any())).thenAnswer((invocation) async {
        capturedFarm = invocation.positionalArguments[0] as Farm;
        return capturedFarm.copyWith(rowVersion: 'v2');
      });

      // 7. Process Update
      await syncService.processQueue();

      // 8. CRITICAL VERIFICATION:
      // The update payload sent to RemoteFarmRepository must use serverGuid as serverId
      // and FarmSyncDto.toUpdateJson will map serverId to 'id'
      expect(capturedFarm.serverId, serverGuid, reason: 'Update must use the backend identifier');
      expect(capturedFarm.id, localClientId, reason: 'Update should still carry local identity');

      final localAfterUpdate = await (db.select(db.farms)..where((t) => t.id.equals(localClientId))).getSingle();
      expect(localAfterUpdate.ownershipTypeId, 1);
      expect(localAfterUpdate.ownerFarmerId, isNull);
      expect(localAfterUpdate.syncStatus, 'completed');
    });
  });

  group('Farmer Sync Identity Flow', () {
    test('Full lifecycle: Create -> Sync -> Update', () async {
      const localId = 'client-f-1';
      const serverId = 'server-f-1';

      final farmer = Farmer(
        id: localId,
        idTypeId: 1,
        idNumber: '123',
        firstNameAr: 'A',
        fatherNameAr: 'B',
        grandfatherNameAr: 'C',
        familyNameAr: 'D',
        firstNameEn: 'E',
        fatherNameEn: 'F',
        grandfatherNameEn: 'G',
        familyNameEn: 'H',
        birthDate: DateTime(1980),
        gender: Gender.male,
        phoneNumber: '000',
        familySize: 1,
        governorateId: 'G',
        localityId: 'L',
        address: 'Addr',
      );

      await db.into(db.farmers).insert(
        FarmersCompanion.insert(
          id: localId,
          firstNameAr: const Value('A'),
          fatherNameAr: const Value('B'),
          grandfatherNameAr: const Value('C'),
          familyNameAr: const Value('D'),
          firstNameEn: const Value('E'),
          fatherNameEn: const Value('F'),
          grandfatherNameEn: const Value('G'),
          familyNameEn: const Value('H'),
          birthDate: Value(DateTime(1980)),
          syncStatus: const Value('pending'),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-f1',
          localId: localId,
          entityType: 'farmer',
          operation: 'create',
          data: jsonEncode(farmer.toJson()),
        ),
      );

      when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((_) async => farmer.copyWith(
        serverId: serverId,
        rowVersion: 'fv1',
      ));

      await syncService.processQueue();

      final local = await (db.select(db.farmers)..where((t) => t.id.equals(localId))).getSingle();
      expect(local.serverId, serverId);

      // Update
      final updated = farmer.copyWith(serverId: serverId, phoneNumber: '111', rowVersion: 'fv1');
      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-f2',
          localId: localId,
          entityType: 'farmer',
          operation: 'update',
          data: jsonEncode(updated.toJson()),
        ),
      );

      late Farmer captured;
      when(() => mockFarmerRepo.updateFarmer(any())).thenAnswer((inv) async {
        captured = inv.positionalArguments[0] as Farmer;
        return captured.copyWith(rowVersion: 'fv2');
      });

      await syncService.processQueue();
      expect(captured.serverId, serverId);
    });
  });

  group('Dependency Late Binding', () {
    test('Farm creation uses Farmer serverId after Farmer syncs', () async {
      const localFarmerId = 'local-farmer-1';
      const serverFarmerId = 'server-farmer-1';
      const localFarmId = 'local-farm-1';

      // 1. Farmer exists locally (pending)
      await db.into(db.farmers).insert(
        FarmersCompanion.insert(
          id: localFarmerId,
          firstNameAr: const Value('Farmer'),
          fatherNameAr: const Value(''),
          grandfatherNameAr: const Value(''),
          familyNameAr: const Value(''),
          firstNameEn: const Value(''),
          fatherNameEn: const Value(''),
          grandfatherNameEn: const Value(''),
          familyNameEn: const Value(''),
          birthDate: Value(DateTime(1980)),
          syncStatus: const Value('pending'),
        ),
      );

      // 2. Farm exists locally (linked to localFarmerId)
      final farm = const Farm(
        id: localFarmId,
        farmerId: localFarmerId, // Linked to local ID
        localFarmName: 'Dependency Farm',
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

      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localFarmId,
          farmerId: localFarmerId,
          localFarmName: 'Dependency Farm',
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 10,
          syncStatus: const Value('pending'),
        ),
      );

      // 3. Queue both
      await db.batch((b) {
        b.insertAll(db.syncQueue, [
          SyncQueueCompanion.insert(
            id: 'q-farmer',
            localId: localFarmerId,
            entityType: 'farmer',
            operation: 'create',
            data: jsonEncode(Farmer(
              id: localFarmerId,
              idTypeId: 1,
              idNumber: '1',
              firstNameAr: 'Farmer',
              fatherNameAr: '',
              grandfatherNameAr: '',
              familyNameAr: '',
              firstNameEn: '',
              fatherNameEn: '',
              grandfatherNameEn: '',
              familyNameEn: '',
              birthDate: DateTime(1980),
              gender: Gender.male,
              phoneNumber: '',
              familySize: 1,
              governorateId: '',
              localityId: '',
              address: '',
            ).toJson()),
            createdAt: Value(DateTime.now().subtract(const Duration(seconds: 1))),
          ),
          SyncQueueCompanion.insert(
            id: 'q-farm',
            localId: localFarmId,
            entityType: 'farm',
            operation: 'create',
            data: jsonEncode(farm.toJson()),
            createdAt: Value(DateTime.now()),
          ),
        ]);
      });

      // 4. Mock responses
      when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((inv) async {
        final f = inv.positionalArguments[0] as Farmer;
        return f.copyWith(serverId: serverFarmerId, rowVersion: 'v1');
      });

      late Farm capturedFarm;
      when(() => mockFarmRepo.createFarm(any())).thenAnswer((inv) async {
        capturedFarm = inv.positionalArguments[0] as Farm;
        return capturedFarm.copyWith(serverId: 'server-farm-1', rowVersion: 'v1');
      });

      // 5. Process
      await syncService.processQueue();

      // 6. Verify Farm was sent with serverFarmerId
      expect(capturedFarm.farmerId, serverFarmerId, reason: 'Late binding must resolve local ID to server ID');
    });
  });
}
