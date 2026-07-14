import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/farmers/data/compensation_repository.dart';
import 'package:mobile/features/farmers/domain/compensation.dart';

final compensationRepositoryProvider = Provider<CompensationRepository>((ref) {
  return CompensationRepositoryImpl(ref.watch(apiDioProvider));
});

final compensationProvider = FutureProvider.family<Compensation?, String>((ref, reportId) async {
  return ref.watch(compensationRepositoryProvider).getByReportId(reportId);
});

class CompensationNotifier extends StateNotifier<AsyncValue<void>> {
  final CompensationRepository _repository;

  CompensationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> calculate(String reportId, String remarks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.create(reportId, remarks));
  }

  Future<void> update(Compensation compensation) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.update(compensation));
  }
}

final compensationActionProvider = StateNotifierProvider<CompensationNotifier, AsyncValue<void>>((ref) {
  return CompensationNotifier(ref.watch(compensationRepositoryProvider));
});
