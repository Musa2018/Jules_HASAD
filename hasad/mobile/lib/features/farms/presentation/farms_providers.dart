import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/data/offline_first_farm_repository.dart';
import 'package:mobile/features/farms/domain/farm.dart';

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return OfflineFirstFarmRepository(
    ref.watch(databaseProvider),
    ref.watch(syncServiceProvider),
  );
});

final farmsListByFarmerProvider = FutureProvider.autoDispose
    .family<List<Farm>, String>((ref, farmerId) async {
      return ref.watch(farmRepositoryProvider).getFarmsByFarmer(farmerId);
    });

class FarmFormState {
  final bool isLoading;
  final List<String> errors;
  final bool success;

  const FarmFormState({
    this.isLoading = false,
    this.errors = const [],
    this.success = false,
  });
}

class FarmFormNotifier extends StateNotifier<FarmFormState> {
  final FarmRepository _repository;
  final Ref _ref;

  FarmFormNotifier(this._repository, this._ref) : super(const FarmFormState());

  Future<void> createFarm(Farm farm) async {
    state = const FarmFormState(isLoading: true);
    try {
      final session = _ref.read(authProvider).session;
      await _repository.createFarm(farm, session: session);
      state = const FarmFormState(success: true);
    } on FarmException catch (e) {
      state = FarmFormState(errors: e.errors);
    } catch (_) {
      state = const FarmFormState(errors: ['An unexpected error occurred.']);
    }
  }

  Future<void> updateFarm(Farm farm) async {
    state = const FarmFormState(isLoading: true);
    try {
      final session = _ref.read(authProvider).session;
      await _repository.updateFarm(farm, session: session);
      state = const FarmFormState(success: true);
    } on FarmException catch (e) {
      state = FarmFormState(errors: e.errors);
    } catch (_) {
      state = const FarmFormState(errors: ['An unexpected error occurred.']);
    }
  }

  Future<void> deleteFarm(String id) async {
    state = const FarmFormState(isLoading: true);
    try {
      final session = _ref.read(authProvider).session;
      await _repository.deleteFarm(id, session: session);
      state = const FarmFormState(success: true);
    } on FarmException catch (e) {
      state = FarmFormState(errors: e.errors);
    } catch (_) {
      state = const FarmFormState(errors: ['An unexpected error occurred.']);
    }
  }
}

final farmFormProvider =
    StateNotifierProvider.autoDispose<FarmFormNotifier, FarmFormState>((ref) {
      return FarmFormNotifier(ref.watch(farmRepositoryProvider), ref);
    });
