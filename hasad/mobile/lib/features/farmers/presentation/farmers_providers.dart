import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';

final farmerRepositoryProvider = Provider<FarmerRepository>((ref) {
  return OfflineFirstFarmerRepository(
    ref.watch(databaseProvider),
    ref.watch(syncServiceProvider),
  );
});

final farmersListProvider = FutureProvider.autoDispose<List<Farmer>>((ref) async {
  return ref.watch(farmerRepositoryProvider).getFarmers();
});

class FarmerFormState {
  final bool isLoading;
  final List<String> errors;
  final bool success;

  const FarmerFormState({
    this.isLoading = false,
    this.errors = const [],
    this.success = false,
  });
}

class FarmerFormNotifier extends StateNotifier<FarmerFormState> {
  final FarmerRepository _repository;

  FarmerFormNotifier(this._repository) : super(const FarmerFormState());

  Future<void> createFarmer(Farmer farmer) async {
    state = const FarmerFormState(isLoading: true);
    try {
      await _repository.createFarmer(farmer);
      state = const FarmerFormState(success: true);
    } on FarmerException catch (e) {
      state = FarmerFormState(errors: e.errors);
    } catch (_) {
      state = const FarmerFormState(errors: ['An unexpected error occurred.']);
    }
  }

  Future<void> updateFarmer(Farmer farmer) async {
    state = const FarmerFormState(isLoading: true);
    try {
      await _repository.updateFarmer(farmer);
      state = const FarmerFormState(success: true);
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

final farmerFormProvider = StateNotifierProvider.autoDispose<FarmerFormNotifier, FarmerFormState>((ref) {
  return FarmerFormNotifier(ref.watch(farmerRepositoryProvider));
});
