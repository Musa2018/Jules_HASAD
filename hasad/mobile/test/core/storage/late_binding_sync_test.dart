import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/data/damage_report_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

class MockFarmerRepo extends Mock implements FarmerRepository {}
class MockFarmRepo extends Mock implements FarmRepository {}
class MockReportRepo extends Mock implements DamageReportRepository {}
class MockAttachmentRepo extends Mock implements DamageReportAttachmentRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late AppDatabase db;
  late MockFarmerRepo farmerRepo;
  late MockFarmRepo farmRepo;
  late MockReportRepo reportRepo;
  late MockAttachmentRepo attachmentRepo;
  late MockConnectivity connectivity;
  late BackgroundSyncService syncService;

  setUpAll(() {
    registerFallbackValue(
      Farmer(
        id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '',
        grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '',
        grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1990),
        gender: Gender.male, phoneNumber: '', familySize: 1, governorateId: '',
        localityId: '', address: '',
      ),
    );
    registerFallbackValue(
      Farm(
        id: '', farmerId: '', localFarmName: '', ownershipTypeId: 1,
        governorateId: '', directorateId: '', localityId: '',
        basin: '', parcel: '', area: 1, areaUnitId: 1,
        agriculturalSectorId: 1, politicalClassificationId: 1,
      ),
    );
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    farmerRepo = MockFarmerRepo();
    farmRepo = MockFarmRepo();
    reportRepo = MockReportRepo();
    attachmentRepo = MockAttachmentRepo();
    connectivity = MockConnectivity();

    syncService = BackgroundSyncService(
      db, farmerRepo, farmRepo, reportRepo, attachmentRepo, connectivity,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Late Binding Sync Resolution', () {
    test('Offline Farmer + Offline Farm: Resolves IDs and syncs in order', () async {
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // 1. Queue Farmer creation
      final farmer = Farmer(
        id: 'local-farmer-1',
        idTypeId: 1,
        idNumber: '1',
        firstNameAr: 'أحمد',
        fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
        firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
        birthDate: DateTime(1990), gender: Gender.male, phoneNumber: '',
        familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
      );

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'local-farmer-1',
        firstNameAr: const drift.Value('أحمد'),
        syncStatus: const drift.Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q1',
        localId: 'local-farmer-1',
        entityType: 'farmer',
        operation: 'create',
        data: jsonEncode(farmer.toJson()),
      ));

      // 2. Queue Farm creation referencing local farmer ID
      final farm = Farm(
        id: 'local-farm-1',
        farmerId: 'local-farmer-1',
        localFarmName: 'Farm 1',
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

      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'local-farm-1',
        farmerId: 'local-farmer-1',
        localFarmName: 'Farm 1',
        ownershipTypeId: const drift.Value(1),
        governorateId: 'G1',
        directorateId: 'D1',
        localityId: 'L1',
        basin: 'B1',
        parcel: 'P1',
        area: 10,
        areaUnitId: const drift.Value(1),
        agriculturalSectorId: const drift.Value(1),
        politicalClassificationId: const drift.Value(1),
        syncStatus: const drift.Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q2',
        localId: 'local-farm-1',
        entityType: 'farm',
        operation: 'create',
        data: jsonEncode(farm.toJson()),
      ));

      // Mocks
      // The backend returns a Farmer with the authority ID in the 'id' field
      final serverFarmer = farmer.copyWith(id: 'server-farmer-1', serverId: 'server-farmer-1');
      when(() => farmerRepo.createFarmer(any())).thenAnswer((_) async => serverFarmer);
      
      when(() => farmRepo.createFarm(any())).thenAnswer((inv) async {
        final f = inv.positionalArguments[0] as Farm;
        return f.copyWith(serverId: 'server-farm-1');
      });

      // Execute sync
      await syncService.processQueue();

      // Verify Farmer synced
      verify(() => farmerRepo.createFarmer(any())).called(1);

      // Verify Farm synced with RESOLVED ID
      final farmCapture = verify(() => farmRepo.createFarm(captureAny())).captured.single as Farm;
      expect(farmCapture.farmerId, 'server-farmer-1'); // Resolved!
      expect(farmCapture.serverId, isNull); // Should be empty for creation request

      // Verify local status
      final localFarm = await (db.select(db.farms)..where((t) => t.id.equals('local-farm-1'))).getSingle();
      expect(localFarm.syncStatus, 'completed');
      expect(localFarm.serverId, 'server-farm-1');
    });

    test('Defers Farm sync if Farmer sync fails', () async {
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Queue Farmer
      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'fail-farmer',
        firstNameAr: const drift.Value('Fail'),
        syncStatus: const drift.Value('pending'),
      ));
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q1', localId: 'fail-farmer', entityType: 'farmer', operation: 'create',
        data: jsonEncode(Farmer(
          id: 'fail-farmer', idTypeId: 1, idNumber: '1', firstNameAr: 'Fail',
          fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
          firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
          birthDate: DateTime(1990), gender: Gender.male, phoneNumber: '',
          familySize: 1, governorateId: 'G1', localityId: 'L1', address: '',
        ).toJson()),
      ));

      // Queue Farm
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'wait-farm', farmerId: 'fail-farmer', localFarmName: 'Wait',
        ownershipTypeId: const drift.Value(1), governorateId: 'G1', directorateId: 'D1',
        localityId: 'L1', basin: 'B1', parcel: 'P1', area: 10,
        areaUnitId: const drift.Value(1), agriculturalSectorId: const drift.Value(1), 
        politicalClassificationId: const drift.Value(1),
        syncStatus: const drift.Value('pending'),
      ));
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q2', localId: 'wait-farm', entityType: 'farm', operation: 'create',
        data: jsonEncode(Farm(
           id: 'wait-farm', farmerId: 'fail-farmer', localFarmName: 'Wait',
           ownershipTypeId: 1, governorateId: 'G1', directorateId: 'D1',
           localityId: 'L1', basin: 'B1', parcel: 'P1', area: 10,
           areaUnitId: 1, agriculturalSectorId: 1, politicalClassificationId: 1,
        ).toJson()),
      ));

      // Farmer sync fails
      when(() => farmerRepo.createFarmer(any())).thenThrow(Exception('Sync failed'));

      await syncService.processQueue();

      // Farm should still be pending and have no serverId
      final localFarm = await (db.select(db.farms)..where((t) => t.id.equals('wait-farm'))).getSingle();
      expect(localFarm.syncStatus, 'pending');
      expect(localFarm.serverId, isNull);

      // Farm queue item should have a dependency error in logs
      final queueItem = await (db.select(db.syncQueue)..where((t) => t.id.equals('q2'))).getSingle();
      expect(queueItem.status, 'pending');
      expect(queueItem.lastError, contains('Waiting for Farmer'));
    });
  });
}
