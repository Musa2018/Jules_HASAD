import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';

import '../../helpers/mocks.dart';

void main() {
  late AppDatabase db;
  late BackgroundSyncService syncService;
  late MockFarmerRepository remoteFarmerRepo;
  late MockFarmRepository remoteFarmRepo;
  late MockDamageReportRepository remoteDamageRepo;
  late MockDamageReportAttachmentRepository remoteAttachmentRepo;
  late MockConnectivity connectivity;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    remoteFarmerRepo = MockFarmerRepository();
    remoteFarmRepo = MockFarmRepository();
    remoteDamageRepo = MockDamageReportRepository();
    remoteAttachmentRepo = MockDamageReportAttachmentRepository();
    connectivity = MockConnectivity();

    syncService = BackgroundSyncService(
      db,
      remoteFarmerRepo,
      remoteFarmRepo,
      remoteDamageRepo,
      remoteAttachmentRepo,
      connectivity,
    );

    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  tearDown(() async {
    await db.close();
  });

  group('DamageReport Sync Hardening', () {
    test('Prunes redundant damage_item tasks after successful bulk creation', () async {
      final reportId = 'report-1';
      final itemId = 'item-1';

      // 1. Setup local state
      await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: reportId,
        farmId: 'farm-1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        statusId: DamageReportStatus.draft,
        notes: 'Notes',
        syncStatus: const Value('pending'),
      ));

      await db.into(db.damageItems).insert(DamageItemsCompanion.insert(
        id: itemId,
        damageReportId: reportId,
        affectedArea: 10,
        damagePercentage: 50,
        quantity: 100,
        estimatedLoss: 1000,
        syncStatus: const Value('pending'),
      ));

      // 2. Add tasks to queue
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q1',
        localId: reportId,
        entityType: 'damage_report',
        operation: 'create',
        data: jsonEncode({
          'clientId': reportId,
          'farmId': 'farm-1',
          'farmerId': 'farmer-1',
          'damageDate': DateTime.now().toIso8601String(),
          'documentationDate': DateTime.now().toIso8601String(),
          'notes': 'Notes',
          'items': [
            {
              'clientId': itemId,
              'damageReportId': reportId,
              'affectedArea': 10,
              'damagePercentage': 50,
              'quantity': 100,
              'estimatedLoss': 1000,
            }
          ],
        }),
        createdAt: Value(DateTime.now()),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q2',
        localId: itemId,
        entityType: 'damage_item',
        operation: 'create',
        data: jsonEncode({'id': itemId, 'damageReportId': reportId}),
        createdAt: Value(DateTime.now()),
      ));

      // 3. Mock remote success
      final remoteReport = DamageReport(
        id: reportId,
        serverId: 'server-report-1',
        reportNumber: 'NBL-NAB-2026-000001',
        farmId: 'farm-1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        notes: 'Notes',
        statusId: DamageReportStatus.pendingTechnicalVerification,
        items: [
          DamageItem(
            id: itemId,
            serverId: 'server-item-1',
            damageReportId: reportId,
            affectedArea: 10,
            damagePercentage: 50,
            quantity: 100,
            estimatedLoss: 1000,
          )
        ],
      );

      when(() => remoteDamageRepo.createDamageReportFromJson(any()))
          .thenAnswer((_) async => remoteReport);
      
      // Need to mock resolves for Farm and Farmer
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm-1',
        serverId: const Value('server-farm-1'),
        farmerId: 'farmer-1',
        localFarmName: 'Farm 1',
        governorateId: 'gov-1',
        directorateId: 'dir-1',
        localityId: 'loc-1',
        basin: '1',
        parcel: '1',
        area: 10,
      ));

      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'farmer-1',
        serverId: const Value('server-farmer-1'),
      ));

      // 4. Run sync
      await syncService.processQueue();

      // 5. Verify pruning
      final remainingTasks = await db.select(db.syncQueue).get();
      // Only the report task remains (as 'completed')
      expect(remainingTasks.length, 1);
      expect(remainingTasks.first.entityType, 'damage_report');
      expect(remainingTasks.first.status, 'completed');

      // Verify item sync task q2 is gone
      final itemTask = await (db.select(db.syncQueue)..where((t) => t.id.equals('q2'))).getSingleOrNull();
      expect(itemTask, isNull);
    });

    test('Workflow sync updates status to Synced and refreshes from server', () async {
      final reportId = 'report-1';
      final serverId = 'server-report-1';

      await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: reportId,
        serverId: Value(serverId),
        farmId: 'farm-1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        statusId: DamageReportStatus.pendingTechnicalVerification,
        notes: 'Notes',
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q1',
        localId: reportId,
        entityType: 'damage_report',
        operation: 'workflow_action',
        data: jsonEncode({'action': 'submit'}),
        createdAt: Value(DateTime.now()),
      ));

      final updatedReport = DamageReport(
        id: reportId,
        serverId: serverId,
        farmId: 'farm-1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        notes: 'Notes',
        statusId: DamageReportStatus.techReview,
      );

      final history = [
        DamageWorkflowHistory(
          id: 'hist-1',
          serverId: 's-hist-1',
          damageReportId: serverId,
          fromStatus: DamageReportStatus.pendingTechnicalVerification,
          toStatus: DamageReportStatus.techReview,
          changedByUserId: 'user-1',
          changedAt: DateTime.now(),
          comment: 'Submitted',
        )
      ];

      when(() => remoteDamageRepo.submitReport(serverId)).thenAnswer((_) async => {});
      when(() => remoteDamageRepo.getDamageReport(serverId)).thenAnswer((_) async => updatedReport);
      when(() => remoteDamageRepo.getReportHistory(serverId)).thenAnswer((_) async => history);

      await syncService.processQueue();

      // Verify local report status
      final localReport = await (db.select(db.damageReports)..where((t) => t.id.equals(reportId))).getSingle();
      expect(localReport.statusId, DamageReportStatus.techReview);
      expect(localReport.syncStatus, 'completed');

      // Verify history refreshed
      final localHistory = await (db.select(db.damageWorkflowHistories)..where((t) => t.damageReportId.equals(reportId))).get();
      expect(localHistory.length, 1);
      expect(localHistory.first.toStatus, DamageReportStatus.techReview);
    });

    test('Conflict with DAMAGE_REPORT_DUPLICATE code is mapped to localization key', () async {
       final reportId = 'report-1';
       
       await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: reportId,
        farmId: 'farm-1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        statusId: DamageReportStatus.draft,
        notes: 'Notes',
        syncStatus: const Value('pending'),
      ));

      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q1',
        localId: reportId,
        entityType: 'damage_report',
        operation: 'create',
        data: jsonEncode({
          'clientId': reportId,
          'farmId': 'farm-1',
          'farmerId': 'farmer-1',
          'damageDate': DateTime.now().toIso8601String(),
          'documentationDate': DateTime.now().toIso8601String(),
          'notes': 'Some notes',
        }),
        createdAt: Value(DateTime.now()),
      ));

      // Mock conflict with code
      when(() => remoteDamageRepo.createDamageReportFromJson(any()))
          .thenThrow(SyncConflictException(['Duplicate found'], code: 'DAMAGE_REPORT_DUPLICATE'));

      // Need to mock resolves for Farm and Farmer
      await db.into(db.farms).insert(FarmsCompanion.insert(
        id: 'farm-1',
        serverId: const Value('server-farm-1'),
        farmerId: 'farmer-1',
        localFarmName: 'Farm 1',
        governorateId: 'gov-1',
        directorateId: 'dir-1',
        localityId: 'loc-1',
        basin: '1',
        parcel: '1',
        area: 10,
      ));
      await db.into(db.farmers).insert(FarmersCompanion.insert(
        id: 'farmer-1',
        serverId: const Value('server-farmer-1'),
      ));

      await syncService.processQueue();

      final task = await (db.select(db.syncQueue)..where((t) => t.id.equals('q1'))).getSingle();
      expect(task.status, 'conflict');
      // The error should be the localization key
      expect(task.lastError, 'duplicateReportError');

      final localReport = await (db.select(db.damageReports)..where((t) => t.id.equals(reportId))).getSingle();
      expect(localReport.syncStatus, 'conflict');
      expect(localReport.lastSyncError, 'duplicateReportError');
    });
  });
}
