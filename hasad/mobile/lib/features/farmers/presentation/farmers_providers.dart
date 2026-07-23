import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
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
