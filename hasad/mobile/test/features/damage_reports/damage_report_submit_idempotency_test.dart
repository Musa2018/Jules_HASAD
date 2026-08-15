import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
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
    registerFallbackValue(const DamageReportsCompanion());
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

  group('DamageReport Submit Idempotency & Recovery', () {
    test('Regression: Submit Success -> Refresh Fail -> Retry Sync -> Verify Recovery', () async {
      final reportId = 'report-1';
      final serverId = 'server-report-1';

      // 1. Initial State
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

      // 2. First Attempt
      when(() => remoteDamageRepo.submitReport(serverId)).thenAnswer((_) async => {});
      when(() => remoteDamageRepo.getDamageReport(serverId)).thenThrow(SyncException(['Network Error']));

      await syncService.processQueue();

      final taskAfterFail = await (db.select(db.syncQueue)..where((t) => t.id.equals('q1'))).getSingle();
      expect(taskAfterFail.status, 'failed');
      
      // 3. Second Attempt (Retry)
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
          id: '',
          serverId: 's-hist-1',
          damageReportId: serverId,
          fromStatus: DamageReportStatus.pendingTechnicalVerification,
          toStatus: DamageReportStatus.techReview,
          changedByUserId: 'user-1',
          changedAt: DateTime.now(),
          comment: 'Submitted',
        )
      ];

      reset(remoteDamageRepo);
      // Backend returns the idempotency trigger string
      when(() => remoteDamageRepo.submitReport(serverId))
          .thenThrow(SyncException(['Only draft or pending reports can be submitted']));
      when(() => remoteDamageRepo.getDamageReport(serverId)).thenAnswer((_) async => updatedReport);
      when(() => remoteDamageRepo.getReportHistory(serverId)).thenAnswer((_) async => history);

      // RESET retry backoff fields to allow immediate reprocessing
      await db.update(db.syncQueue).replace(taskAfterFail.copyWith(
        lastAttemptAt: const Value(null),
        retryCount: 0,
      ));

      await syncService.processQueue();

      final taskFinal = await (db.select(db.syncQueue)..where((t) => t.id.equals('q1'))).getSingle();
      expect(taskFinal.status, 'completed');

      final localReport = await (db.select(db.damageReports)..where((t) => t.id.equals(reportId))).getSingle();
      expect(localReport.statusId, DamageReportStatus.techReview);
      expect(localReport.syncStatus, 'completed');
    });

    test('Upsert Logic: Server records are matched by serverId', () async {
       final reportId = 'report-1';
       final serverId = 'server-report-1';

       await db.into(db.damageReports).insert(DamageReportsCompanion.insert(
        id: reportId,
        serverId: Value(serverId),
        farmId: 'f1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        statusId: 'Pending',
        notes: '',
      ));

       await db.into(db.damageWorkflowHistories).insert(DamageWorkflowHistoriesCompanion.insert(
         id: 'local-1',
         serverId: const Value('s-hist-1'),
         damageReportId: reportId,
         fromStatus: 'Draft',
         toStatus: 'Pending',
         changedByUserId: 'user-1',
         changedAt: DateTime.now(),
       ));

       await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        id: 'q2',
        localId: reportId,
        entityType: 'damage_report',
        operation: 'workflow_action',
        data: jsonEncode({'action': 'submit'}),
        createdAt: Value(DateTime.now()),
      ));

       final updatedReport = DamageReport(id: reportId, serverId: serverId, farmId: 'f1', damageDate: DateTime.now(), statusId: 'TechReview');
       final historyFromServer = [
         DamageWorkflowHistory(
           id: '',
           serverId: 's-hist-1',
           damageReportId: serverId,
           fromStatus: 'Draft',
           toStatus: 'TechReview',
           changedByUserId: 'user-1',
           changedAt: DateTime.now(),
         )
       ];

       when(() => remoteDamageRepo.submitReport(serverId)).thenAnswer((_) async => {});
       when(() => remoteDamageRepo.getDamageReport(serverId)).thenAnswer((_) async => updatedReport);
       when(() => remoteDamageRepo.getReportHistory(serverId)).thenAnswer((_) async => historyFromServer);

       await syncService.processQueue();

       final localHistory = await (db.select(db.damageWorkflowHistories)..where((t) => t.damageReportId.equals(reportId))).get();
       expect(localHistory.length, 1);
       expect(localHistory.first.id, 'local-1'); 
       expect(localHistory.first.toStatus, 'TechReview');
    });
  });
}
