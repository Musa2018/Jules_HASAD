import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/data/damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/data/damage_report_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/data/offline_first_damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/data/offline_first_damage_report_repository.dart';
import 'package:mobile/features/farmers/domain/damage_report.dart';
import 'package:mobile/features/farmers/domain/damage_report_attachment.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';

final farmerFiltersProvider = StateProvider<FarmerFilter>((ref) {
  return const FarmerFilter();
});

final farmerRepositoryProvider = Provider<FarmerRepository>((ref) {
  return OfflineFirstFarmerRepository(
    ref.watch(databaseProvider),
    ref.watch(syncServiceProvider),
    ref.watch(remoteFarmerRepositoryProvider),
    ref.watch(connectivityProvider),
  );
});

final farmersListProvider = StreamProvider.autoDispose<List<Farmer>>((ref) {
  final filter = ref.watch(farmerFiltersProvider);
  return ref.watch(farmerRepositoryProvider).watchFarmers(filter: filter);
});

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

final farmerProvider = FutureProvider.autoDispose.family<Farmer, String>((
  ref,
  id,
) async {
  return ref.watch(farmerRepositoryProvider).getFarmer(id);
});

final farmerStreamProvider =
    StreamProvider.autoDispose.family<Farmer?, String>((ref, id) {
      return ref.watch(farmerRepositoryProvider).watchFarmer(id);
    });

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

class FarmerFormState {
  final bool isLoading;
  final List<String> errors;
  final bool success;
  final Farmer? farmer;

  const FarmerFormState({
    this.isLoading = false,
    this.errors = const [],
    this.success = false,
    this.farmer,
  });
}

class FarmerFormNotifier extends StateNotifier<FarmerFormState> {
  final FarmerRepository _repository;

  FarmerFormNotifier(this._repository) : super(const FarmerFormState());

  Future<void> createFarmer(Farmer farmer) async {
    state = const FarmerFormState(isLoading: true);
    try {
      final result = await _repository.createFarmer(farmer);
      state = FarmerFormState(success: true, farmer: result);
    } on FarmerException catch (e) {
      state = FarmerFormState(errors: e.errors);
    } catch (_) {
      state = const FarmerFormState(errors: ['An unexpected error occurred.']);
    }
  }

  Future<void> updateFarmer(Farmer farmer) async {
    state = const FarmerFormState(isLoading: true);
    try {
      final result = await _repository.updateFarmer(farmer);
      state = FarmerFormState(success: true, farmer: result);
    } on FarmerException catch (e) {
      state = FarmerFormState(errors: e.errors);
    } catch (_) {
      state = const FarmerFormState(errors: ['An unexpected error occurred.']);
    }
  }

  Future<void> deleteFarmer(String id) async {
    state = const FarmerFormState(isLoading: true);
    try {
      await _repository.deleteFarmer(id);
      state = const FarmerFormState(success: true);
    } on FarmerException catch (e) {
      state = FarmerFormState(errors: e.errors);
    } catch (_) {
      state = const FarmerFormState(errors: ['An unexpected error occurred.']);
    }
  }
}

final farmerFormProvider =
    StateNotifierProvider.autoDispose<FarmerFormNotifier, FarmerFormState>((
      ref,
    ) {
      return FarmerFormNotifier(ref.watch(farmerRepositoryProvider));
    });

enum FarmerSearchStatus { idle, searching, found, notFound, error }

class FarmerSearchState {
  final FarmerSearchStatus status;
  final Farmer? farmer;
  final String? error;

  const FarmerSearchState({
    this.status = FarmerSearchStatus.idle,
    this.farmer,
    this.error,
  });
}

class FarmerSearchNotifier extends StateNotifier<FarmerSearchState> {
  final FarmerRepository _repository;

  FarmerSearchNotifier(this._repository) : super(const FarmerSearchState());

  Future<void> search(String idNumber) async {
    if (idNumber.isEmpty) return;

    state = const FarmerSearchState(status: FarmerSearchStatus.searching);

    try {
      final farmer = await _repository.findByIdNumber(idNumber);
      if (farmer != null) {
        state = FarmerSearchState(status: FarmerSearchStatus.found, farmer: farmer);
      } else {
        state = const FarmerSearchState(status: FarmerSearchStatus.notFound);
      }
    } catch (e) {
      state = FarmerSearchState(
        status: FarmerSearchStatus.error,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const FarmerSearchState();
  }
}

final farmerSearchProvider =
    StateNotifierProvider.autoDispose<FarmerSearchNotifier, FarmerSearchState>((
      ref,
    ) {
      return FarmerSearchNotifier(ref.watch(farmerRepositoryProvider));
    });
