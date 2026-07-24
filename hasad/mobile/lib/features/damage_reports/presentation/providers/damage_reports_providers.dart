// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/offline_first_damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart';

final damageReportRepositoryProvider = Provider<DamageReportRepository>((ref) {
  return OfflineFirstDamageReportRepository(
    ref.watch(databaseProvider),
    ref.watch(syncServiceProvider),
  );
});

final attachmentRepositoryProvider = Provider<DamageReportAttachmentRepository>(
  (ref) {
    return OfflineFirstDamageReportAttachmentRepository(
      ref.watch(databaseProvider),
      ref.watch(syncServiceProvider),
    );
  },
);

final damageReportsListByFarmProvider = FutureProvider.autoDispose
    .family<List<DamageReport>, String>((ref, farmId) async {
      return ref
          .watch(damageReportRepositoryProvider)
          .getDamageReportsByFarm(farmId);
    });

final damageReportStreamProvider = StreamProvider.autoDispose.family<DamageReport?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.damageReports)..where((t) => t.id.equals(id)))
      .watchSingleOrNull()
      .asyncMap((row) async {
    if (row == null) return null;
    final items = await (db.select(db.damageItems)..where((t) => t.damageReportId.equals(id))).get();
    
    // Convert to domain (Manual mapping since we don't have the repository method yet)
    return DamageReport(
      id: row.id,
      serverId: row.serverId,
      permanentFormNumber: row.permanentFormNumber,
      temporaryFormNumber: row.temporaryFormNumber,
      damageYear: row.damageYear,
      farmId: row.farmId,
      farmerId: row.farmerId,
      damageDate: row.damageDate,
      documentationDate: row.documentationDate,
      damageCauseCategoryId: row.damageCauseCategoryId,
      damageCauseId: row.damageCauseId,
      settlementName: row.settlementName,
      companyName: row.companyName,
      governorateId: row.governorateId,
      directorateId: row.directorateId,
      localityId: row.localityId,
      latitude: row.latitude,
      longitude: row.longitude,
      statusId: row.statusId,
      notes: row.notes,
      rowVersion: row.rowVersion,
      syncStatus: row.syncStatus,
      lastSyncError: row.lastSyncError,
      items: items.map((i) => DamageItem(
        id: i.id,
        serverId: i.serverId,
        damageReportId: i.damageReportId,
        classificationId: i.classificationId,
        costingSheetId: i.costingSheetId,
        costingSheetItemId: i.costingSheetItemId,
        calculatedUnitPrice: i.calculatedUnitPrice,
        measurementUnitSnapshot: i.measurementUnitSnapshot,
        affectedArea: i.affectedArea,
        damagePercentage: i.damagePercentage,
        quantity: i.quantity,
        estimatedLoss: i.estimatedLoss,
        rowVersion: i.rowVersion,
        syncStatus: i.syncStatus,
        lastSyncError: i.lastSyncError,
      )).toList(),
    );
  });
});

final damageReportHistoryProvider = FutureProvider.autoDispose.family<List<DamageWorkflowHistory>, String>((ref, id) {
  return ref.watch(damageReportRepositoryProvider).getReportHistory(id);
});

final attachmentsByReportProvider = FutureProvider.autoDispose
    .family<List<DamageReportAttachment>, String>((ref, reportId) async {
      return ref
          .watch(attachmentRepositoryProvider)
          .getAttachmentsByReport(reportId);
    });

class DamageReportFormState {
  final bool isLoading;
  final List<String> errors;
  final bool success;
  final DamageReport? createdReport;

  const DamageReportFormState({
    this.isLoading = false,
    this.errors = const [],
    this.success = false,
    this.createdReport,
  });
}

class DamageReportFormNotifier extends StateNotifier<DamageReportFormState> {
  final DamageReportRepository _repository;

  DamageReportFormNotifier(this._repository)
    : super(const DamageReportFormState());

  Future<void> createDamageReport(DamageReport report) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      final created = await _repository.createDamageReport(report);
      state = DamageReportFormState(success: true, createdReport: created);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(
        errors: ['An unexpected error occurred.'],
      );
    }
  }

  Future<void> updateDamageReport(DamageReport report) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      final updated = await _repository.updateDamageReport(report);
      state = DamageReportFormState(success: true, createdReport: updated);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(
        errors: ['An unexpected error occurred.'],
      );
    }
  }

  Future<void> submitReport(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.submitReport(id);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(
        errors: ['Failed to submit report.'],
      );
    }
  }

  Future<void> deleteDamageReport(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.deleteDamageReport(id);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(
        errors: ['An unexpected error occurred.'],
      );
    }
  }
}

final damageReportFormProvider =
    StateNotifierProvider.autoDispose<
      DamageReportFormNotifier,
      DamageReportFormState
    >((ref) {
      return DamageReportFormNotifier(
        ref.watch(damageReportRepositoryProvider),
      );
    });
