import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/offline_first_damage_report_attachment_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';

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

  const DamageReportFormState({
    this.isLoading = false,
    this.errors = const [],
    this.success = false,
  });
}

class DamageReportFormNotifier extends StateNotifier<DamageReportFormState> {
  final DamageReportRepository _repository;

  DamageReportFormNotifier(this._repository)
    : super(const DamageReportFormState());

  Future<void> createDamageReport(DamageReport report) async {
    state = const DamageReportFormState(isLoading: true);
    try {
      await _repository.createDamageReport(report);
      state = const DamageReportFormState(success: true);
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
      await _repository.updateDamageReport(report);
      state = const DamageReportFormState(success: true);
    } on DamageReportException catch (e) {
      state = DamageReportFormState(errors: e.errors);
    } catch (_) {
      state = const DamageReportFormState(
        errors: ['An unexpected error occurred.'],
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
