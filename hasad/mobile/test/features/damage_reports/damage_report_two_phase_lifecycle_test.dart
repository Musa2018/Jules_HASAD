import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';

void main() {
  group('DamageReportWorkflowX (Two-Phase Lifecycle)', () {
    final baseReport = DamageReport(
      id: 'ID-1',
      farmId: 'FARM-1',
      damageDate: DateTime.now(),
      documentationDate: DateTime.now(),
      notes: 'Test notes',
    );

    test('isHeaderSynced is false when serverId or reportNumber is missing', () {
      expect(baseReport.isHeaderSynced, isFalse);
      
      final withServerId = baseReport.copyWith(serverId: 'SERVER-1');
      expect(withServerId.isHeaderSynced, isFalse);

      final withNumber = baseReport.copyWith(reportNumber: 'JEN-001');
      expect(withNumber.isHeaderSynced, isFalse);
      
      final fullySynced = baseReport.copyWith(serverId: 'SERVER-1', reportNumber: 'JEN-001');
      expect(fullySynced.isHeaderSynced, isTrue);
    });

    test('isReadyForReview requires synced header, items, and synced items', () {
      final report = baseReport.copyWith(
        serverId: 'SERVER-1',
        reportNumber: 'JEN-001',
      );
      
      expect(report.isReadyForReview, isFalse, reason: 'No items yet');

      final withItem = report.copyWith(
        items: [
          DamageItem(
            id: 'ITEM-1',
            damageReportId: 'ID-1',
            affectedArea: 10,
            damagePercentage: 50,
            quantity: 5,
            estimatedLoss: 100,
            syncStatus: 'pending',
          ),
        ],
      );
      expect(withItem.isReadyForReview, isFalse, reason: 'Item not synced');

      final withSyncedItem = withItem.copyWith(
        items: [
          withItem.items.first.copyWith(syncStatus: 'completed'),
        ],
      );
      expect(withSyncedItem.isReadyForReview, isTrue, reason: 'Header and all items synced');
    });

    test('workflowStateKey progression', () {
      expect(baseReport.workflowStateKey, equals('workflowState_DraftHeader'));
      
      final headerSyncFailed = baseReport.copyWith(syncStatus: 'failed');
      expect(headerSyncFailed.workflowStateKey, equals('workflowState_HeaderSyncFailed'));

      final headerSynced = baseReport.copyWith(serverId: 'SERVER-1', reportNumber: 'JEN-001');
      expect(headerSynced.workflowStateKey, equals('workflowState_HeaderSynced'));

      final assessmentInProgress = headerSynced.copyWith(
        items: [
          DamageItem(
            id: 'ITEM-1',
            damageReportId: 'ID-1',
            affectedArea: 10,
            damagePercentage: 50,
            quantity: 5,
            estimatedLoss: 100,
            syncStatus: 'completed',
          ),
        ],
        statusId: DamageReportStatus.draft,
      );
      // It will be 'Ready for Review' if all synced
      expect(assessmentInProgress.workflowStateKey, equals('workflowState_ReadyForReview'));

      final itemPending = assessmentInProgress.copyWith(
        items: [
          assessmentInProgress.items.first.copyWith(syncStatus: 'pending'),
        ],
      );
      expect(itemPending.workflowStateKey, equals('workflowState_AssessmentPendingSync'));

      final submitted = assessmentInProgress.copyWith(statusId: DamageReportStatus.techReview);
      expect(submitted.workflowStateKey, equals('status_TechReview'));
    });
   group('Business Identifier Rules', () {
    test('DamageItems must link to DamageReport using the internal technical Id', () {
      final reportId = 'TECHNICAL-GUID-123';
      final report = DamageReport(
        id: reportId,
        reportNumber: 'OFFICIAL-JEN-001',
        farmId: 'F1',
        damageDate: DateTime.now(),
        documentationDate: DateTime.now(),
        notes: '',
      );
      
      final item = DamageItem(
        id: 'ITEM-1',
        damageReportId: report.id, // Must be ID, not ReportNumber
        affectedArea: 1,
        damagePercentage: 1,
        quantity: 1,
        estimatedLoss: 1,
      );
      
      expect(item.damageReportId, equals(reportId));
      expect(item.damageReportId, isNot(equals(report.reportNumber)));
    });
  });
  });
}
