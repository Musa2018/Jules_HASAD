import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

import 'package:mobile/features/damage_reports/data/repositories/remote_damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_filter.dart';
import 'package:mobile/features/damage_reports/domain/models/audit_log_entry.dart';

part 'damage_reports_providers.g.dart';

final remoteDamageReportRepositoryProvider = Provider<DamageReportRepository>((ref) {
  return RemoteDamageReportRepository(ref.watch(apiDioProvider));
});

final damageReportRepositoryProvider = Provider<DamageReportRepository>((ref) {
  return OfflineFirstDamageReportRepository(
    ref.watch(databaseProvider),
    ref,
    ref.watch(authProvider).session,
    ref.watch(remoteDamageReportRepositoryProvider),
    ref.watch(connectivityProvider),
  );
});

final damageReportFilterProvider = StateProvider<DamageReportFilter>((ref) => const DamageReportFilter());

final damageReportsListProvider = StreamProvider.autoDispose<List<DamageReport>>((ref) {
  return ref.watch(damageReportRepositoryProvider).watchDamageReports();
});

final damageReportsByFarmListProvider = StreamProvider.autoDispose.family<List<DamageReport>, String>((ref, farmId) {
  return ref.watch(damageReportRepositoryProvider).watchDamageReportsByFarm(farmId);
});

final filteredDamageReportsProvider = Provider.autoDispose<AsyncValue<List<DamageReport>>>((ref) {
  final filter = ref.watch(damageReportFilterProvider);
  final reportsAsync = ref.watch(damageReportsListProvider);

  return reportsAsync.whenData((reports) {
    return reports.where((r) {
      if (filter.searchText.isNotEmpty) {
        final search = filter.searchText.toLowerCase();
        final matchesNumber = r.reportNumber.toLowerCase().contains(search) ||
            r.temporaryFormNumber.toLowerCase().contains(search) ||
            r.permanentFormNumber.toLowerCase().contains(search);
        if (!matchesNumber) return false;
      }
      if (filter.statusId != null && r.statusId != filter.statusId) return false;
      if (filter.syncStatus != null && r.syncStatus != filter.syncStatus) return false;
      if (filter.governorateId != null && r.governorateId != filter.governorateId) return false;
      if (filter.directorateId != null && r.directorateId != filter.directorateId) return false;
      if (filter.localityId != null && r.localityId != filter.localityId) return false;
      return true;
    }).toList();
  });
});

final attachmentRepositoryProvider = Provider<DamageReportAttachmentRepository>(
      (ref) {
    return OfflineFirstDamageReportAttachmentRepository(
      ref.watch(databaseProvider),
      ref,
    );
  },
);

final damageReportStreamProvider = StreamProvider.autoDispose.family<DamageReport?, String>((ref, id) {
  final db = ref.watch(databaseProvider);

  // Use a join to watch all related tables. We also explicitly watch the child tables
  // to ensure any change in items or attachments triggers a rebuild of the full report.
  // Use a join to watch all related tables. We use explicit case-insensitive matching in the join
  // to ensure Drift's watcher correctly tracks dependencies across tables.
  final query = db.select(db.damageReports).join([
    leftOuterJoin(db.damageItems, db.damageItems.damageReportId.lower().equalsExp(db.damageReports.id.lower())),
    leftOuterJoin(db.damageReportAttachments, db.damageReportAttachments.damageReportId.lower().equalsExp(db.damageReports.id.lower())),
  ])..where(db.damageReports.id.lower().equals(id.toLowerCase()));

  return query.watch().asyncMap((rows) async {
    if (kDebugMode) {
      debugPrint('[damageReportStreamProvider] Triggered update for ID: $id. Join rows: ${rows.length}');
    }

    if (rows.isEmpty) return null;

    final reportRow = rows.first.readTable(db.damageReports);
    final reportId = reportRow.id;

    // Fetch items and attachments separately using case-insensitive ID matching and robust deletion filtering
    final items = await (db.select(db.damageItems)
      ..where((t) => t.damageReportId.lower().equals(id.toLowerCase()) | 
                     t.damageReportId.lower().equals(reportRow.serverId?.toLowerCase() ?? ''))
      ..where((t) => t.isPendingDelete.equals(false) | t.isPendingDelete.isNull()))
        .get();
    
    final attachments = await (db.select(db.damageReportAttachments)
      ..where((t) => t.damageReportId.lower().equals(id.toLowerCase()) | 
                     t.damageReportId.lower().equals(reportRow.serverId?.toLowerCase() ?? ''))
      ..where((t) => t.isPendingDelete.equals(false) | t.isPendingDelete.isNull()))
        .get();

    if (kDebugMode) {
      debugPrint('[damageReportStreamProvider] Report: $reportId, Items: ${items.length}, Attachments: ${attachments.length}');
    }

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
      updatedAt: reportRow.updatedAt,
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
        updatedAt: i.updatedAt,
      )).toList(),
      attachments: attachments.map((a) => DamageReportAttachment(
        id: a.id,
        serverId: a.serverId,
        damageReportId: a.damageReportId,
        documentName: a.documentName,
        documentDate: a.documentDate,
        documentTypeId: a.documentTypeId,
        localPath: a.localPath,
        remotePath: a.remotePath,
        uploadStatus: a.uploadStatus,
        syncStatus: a.syncStatus,
        lastSyncError: a.lastSyncError,
      )).toList(),
    );
  });
});

final damageReportHistoryProvider = StreamProvider.autoDispose.family<List<DamageWorkflowHistory>, String>((ref, id) {
  final repository = ref.watch(damageReportRepositoryProvider);
  
  // Create a controller to combine local watch with a proactive fetch if needed
  final stream = repository.watchReportHistory(id);
  
  // Proactive fetch: if the report is synced but has no history yet, try to fetch it
  stream.first.then((histories) async {
    if (histories.isEmpty) {
      final report = await repository.getDamageReport(id);
      if (report.serverId != null && report.serverId!.isNotEmpty) {
        await repository.syncWorkflowHistory(id, report.serverId!);
      }
    }
  });

  return stream;
});

// [LEGACY_MANUAL_REFRESH]
// final attachmentsByReportProvider = StreamProvider.autoDispose
//     .family<List<DamageReportAttachment>, String>((ref, reportId) {
//   return ref
//       .watch(attachmentRepositoryProvider)
//       .watchAttachmentsByReport(reportId);
// });

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
  final Ref _ref;

  DamageReportFormNotifier(this._repository, this._ref)
      : super(const DamageReportFormState());

  Future<void> createDamageReport(DamageReport report) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      final created = await _repository.createDamageReport(report);
      if (mounted) state = DamageReportFormState(success: true, createdReport: created);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['An unexpected error occurred.'],
        );
      }
    }
  }

  Future<void> updateDamageReport(DamageReport report) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      final updated = await _repository.updateDamageReport(report);
      if (mounted) state = DamageReportFormState(success: true, createdReport: updated);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['An unexpected error occurred.'],
        );
      }
    }
  }

  Future<bool> submitReport(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.submitReport(id);
      if (mounted) state = const DamageReportFormState(success: true);
      return true;
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
      return false;
    } on SyncException catch (e) {
      if (mounted) state = DamageReportFormState(errors: [e.toString()]);
      return false;
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['Failed to submit report.'],
        );
      }
      return false;
    }
  }

  Future<bool> transitionReport(String id, String toStatus,
      {String? comment, bool isOverride = false}) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.transitionReport(id, toStatus,
          comment: comment, isOverride: isOverride);
      if (mounted) state = const DamageReportFormState(success: true);
      return true;
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
      return false;
    } on SyncException catch (e) {
      if (mounted) state = DamageReportFormState(errors: [e.toString()]);
      return false;
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['Failed to transition report status.'],
        );
      }
      return false;
    }
  }

  Future<void> deleteDamageReport(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.deleteDamageReport(id);
      if (mounted) state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['An unexpected error occurred.'],
        );
      }
    }
  }

  Future<void> addDamageItem(DamageItem item) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.addDamageItem(item);
      if (mounted) state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) state = const DamageReportFormState(errors: ['Failed to add item.']);
    }
  }

  Future<void> updateDamageItem(DamageItem item) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.updateDamageItem(item);
      if (mounted) state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) state = const DamageReportFormState(errors: ['Failed to update item.']);
    }
  }

  Future<void> deleteDamageItem(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.deleteDamageItem(id);
      if (mounted) state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      if (mounted) state = const DamageReportFormState(errors: ['Failed to delete item.']);
    }
  }

  Future<void> deleteAttachment(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _ref.read(attachmentRepositoryProvider).deleteAttachment(id);
      if (mounted) state = const DamageReportFormState(success: true);
    } catch (e) {
      if (mounted) state = DamageReportFormState(errors: [e.toString()]);
    }
  }

  Future<bool> retryReportSync(String id) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.retrySync(id);
      if (mounted) state = const DamageReportFormState(success: true);
      return true;
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
      return false;
    } on SyncException catch (e) {
      if (mounted) state = DamageReportFormState(errors: [e.toString()]);
      return false;
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['Failed to retry sync.'],
        );
      }
      return false;
    }
  }

  Future<void> retryAllFailedSyncs() async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.retryAllFailedSyncs();
      if (mounted) state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      if (mounted) state = DamageReportFormState(errors: e.errors);
    } on SyncException catch (e) {
      if (mounted) state = DamageReportFormState(errors: [e.toString()]);
    } catch (_) {
      if (mounted) {
        state = const DamageReportFormState(
          errors: ['Failed to retry all syncs.'],
        );
      }
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
    ref,
  );
});
@riverpod
Future<List<AuditLogEntry>> damageReportAuditLog(DamageReportAuditLogRef ref, String reportId) {
  return ref.watch(damageReportRepositoryProvider).getIntegratedAuditLog(reportId);
}
