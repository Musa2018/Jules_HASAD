// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
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
    ref,
    ref.watch(authProvider).session,
  );
});

final attachmentRepositoryProvider = Provider<DamageReportAttachmentRepository>(
  (ref) {
    return OfflineFirstDamageReportAttachmentRepository(
      ref.watch(databaseProvider),
      ref,
    );
  },
);

final damageReportsListByFarmProvider = FutureProvider.autoDispose
    .family<List<DamageReport>, String>((ref, farmId) async {
      return ref
          .watch(damageReportRepositoryProvider)
          .getDamageReportsByFarm(farmId);
    });

final allDamageReportsProvider = FutureProvider.autoDispose<List<DamageReport>>((ref) async {
  return ref.watch(damageReportRepositoryProvider).getDamageReports();
});

final damageReportStreamProvider = StreamProvider.autoDispose.family<DamageReport?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  
  // Use a join to watch both tables. This ensures the stream emits whenever 
  // the report header OR any of its items change.
  final query = db.select(db.damageReports).join([
    leftOuterJoin(db.damageItems, db.damageItems.damageReportId.equalsExp(db.damageReports.id)),
  ])..where(db.damageReports.id.equals(id));

  return query.watch().asyncMap((rows) async {
    if (rows.isEmpty) return null;
    
    final reportRow = rows.first.readTable(db.damageReports);
    
    // Fetch items separately to ensure we get the full list correctly (Drift join returns one row per item)
    final items = await (db.select(db.damageItems)
      ..where((t) => t.damageReportId.equals(id) & t.isPendingDelete.equals(false)))
      .get();
    
    return DamageReport(
      id: reportRow.id,
      serverId: reportRow.serverId ?? '',
      reportNumber: reportRow.reportNumber,
      permanentFormNumber: reportRow.permanentFormNumber,
      temporaryFormNumber: reportRow.temporaryFormNumber,
      damageYear: reportRow.damageYear,
      farmId: reportRow.farmId,
      farmerId: reportRow.farmerId,
      damageDate: reportRow.damageDate,
      documentationDate: reportRow.documentationDate,
      agriculturalSectorId: reportRow.agriculturalSectorId,
      damageCauseCategoryId: reportRow.damageCauseCategoryId,
      damageCauseId: reportRow.damageCauseId,
      governorateId: reportRow.governorateId,
      directorateId: reportRow.directorateId,
      localityId: reportRow.localityId,
      statusId: reportRow.statusId,
      notes: reportRow.notes,
      createdBy: reportRow.createdBy,
      rowVersion: reportRow.rowVersion,
      syncStatus: reportRow.syncStatus,
      lastSyncError: reportRow.lastSyncError,
      items: items.map((i) => DamageItem(
        id: i.id,
        serverId: i.serverId,
        damageReportId: i.damageReportId,
        damageNatureId: i.damageNatureId,
        damageActionId: i.damageActionId,
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

  Future<void> addDamageItem(DamageItem item) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.addDamageItem(item);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(errors: ['Failed to add item.']);
    }
  }

  Future<void> updateDamageItem(DamageItem item) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.updateDamageItem(item);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(errors: ['Failed to update item.']);
    }
  }

  Future<void> deleteDamageItem(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.deleteDamageItem(id);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(errors: ['Failed to delete item.']);
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
