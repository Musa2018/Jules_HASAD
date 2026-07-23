import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide isNull;
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
import 'package:mobile/features/farms/data/offline_first_farm_repository.dart';

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
    
    syncService = BackgroundSyncService(
      db,
      mockFarmerRepo,
      mockFarmRepo,
      mockDamageRepo,
      mockAttachmentRepo,
      mockConnectivity,
    );
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  group('Offline Delete Hardened Workflow', () {
    test('Delete offline -> Item remains visible as Pending Delete', () async {
      const localId = 'farm-1';
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localId,
          farmerId: 'farmer-1',
          localFarmName: 'Visible Farm',
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 10,
          syncStatus: const Value('completed'),
        ),
      );

      // Offline delete simulation
      await (db.update(db.farms)..where((t) => t.id.equals(localId))).write(
        const FarmsCompanion(
          isPendingDelete: Value(true),
          syncStatus: Value('pending'),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-del',
          localId: localId,
          entityType: 'farm',
          operation: 'delete',
          data: jsonEncode({'id': 'server-1'}),
        ),
      );

      // Verify still in database (visibility depends on UI stream which no longer filters it out)
      final farm = await (db.select(db.farms)..where((t) => t.id.equals(localId))).getSingle();
      expect(farm.isPendingDelete, isTrue);
      expect(farm.syncStatus, 'pending');
    });

    test('Sync failure -> Item remains with error', () async {
      const localId = 'farm-fail';
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localId,
          farmerId: 'farmer-1',
          localFarmName: 'Failed Delete',
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 10,
          syncStatus: const Value('pending'),
          isPendingDelete: const Value(true),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-fail',
          localId: localId,
          entityType: 'farm',
          operation: 'delete',
          data: jsonEncode({'id': 'server-fail'}),
        ),
      );

      when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockFarmRepo.deleteFarm(any())).thenThrow(Exception('Server Down'));

      await syncService.processQueue();

      final farm = await (db.select(db.farms)..where((t) => t.id.equals(localId))).getSingle();
      expect(farm.isPendingDelete, isTrue);
      expect(farm.syncStatus, 'failed');
      expect(farm.lastSyncError, contains('Server Down'));
    });

    test('Sync failure (Restricted) -> Item remains with localized business error', () async {
      const localId = 'farm-restricted';
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localId,
          farmerId: 'farmer-1',
          localFarmName: 'Restricted Farm',
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 10,
          syncStatus: const Value('pending'),
          isPendingDelete: const Value(true),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-restricted',
          localId: localId,
          entityType: 'farm',
          operation: 'delete',
          data: jsonEncode({'id': 'server-restricted'}),
        ),
      );

      when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      // Mock backend error message
      final errorMsg = 'لا يمكن حذف المزرعة لوجود استمارات ضرر مرتبطة بها.';
      when(() => mockFarmRepo.deleteFarm(any())).thenThrow(SyncException([errorMsg]));

      await syncService.processQueue();

      final farm = await (db.select(db.farms)..where((t) => t.id.equals(localId))).getSingle();
      expect(farm.isPendingDelete, isTrue);
      expect(farm.syncStatus, 'failed');
      expect(farm.lastSyncError, contains(errorMsg));
    });

    test('Undo delete -> Item returns to Completed status and task removed', () async {
      const localId = 'farm-undo';
      
      // 1. Setup pending delete
      await db.into(db.farms).insert(
        FarmsCompanion.insert(
          id: localId,
          farmerId: 'farmer-1',
          localFarmName: 'Undo Farm',
          governorateId: 'G1',
          directorateId: 'D1',
          localityId: 'L1',
          basin: 'B1',
          parcel: 'P1',
          area: 10,
          syncStatus: const Value('pending'),
          isPendingDelete: const Value(true),
        ),
      );

      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: 'q-undo',
          localId: localId,
          entityType: 'farm',
          operation: 'delete',
          data: '{}',
        ),
      );

      // 2. Undo via repository logic (we'll implement it in repository, test verifies logic)
      final repo = OfflineFirstFarmRepository(db, syncService);
      await repo.cancelDeleteFarm(localId);

      // 3. Verify
      final farm = await (db.select(db.farms)..where((t) => t.id.equals(localId))).getSingle();
      expect(farm.isPendingDelete, isFalse);
      expect(farm.syncStatus, 'completed');

      final queue = await db.select(db.syncQueue).get();
      expect(queue, isEmpty);
    });
  });
}
