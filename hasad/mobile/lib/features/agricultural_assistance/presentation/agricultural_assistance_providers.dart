import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/agricultural_assistance/data/agricultural_assistance_repository.dart';
import 'package:mobile/features/agricultural_assistance/domain/agricultural_assistance.dart';

final assistanceRepositoryProvider = Provider<AgriculturalAssistanceRepository>((ref) {
  return AgriculturalAssistanceRepositoryImpl(ref.watch(apiDioProvider));
});

final assistanceDecisionProvider = FutureProvider.family<AgriculturalAssistance?, String>((
  ref,
  reportId,
) async {
  return ref.watch(assistanceRepositoryProvider).getByReportId(reportId);
});

class AgriculturalAssistanceNotifier extends StateNotifier<AsyncValue<void>> {
  final AgriculturalAssistanceRepository _repository;

  AgriculturalAssistanceNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> calculate(String reportId, String remarks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.create(reportId, remarks));
  }

  Future<void> recalculate(AgriculturalAssistance assistance) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.recalculate(assistance.id, assistance.rowVersion),
    );
  }

  Future<void> submit(AgriculturalAssistance assistance) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.submit(assistance.id, assistance.rowVersion),
    );
  }

  Future<void> approve(
    AgriculturalAssistance assistance,
    double amount,
    String remarks,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.approve(
        assistance.id,
        amount,
        remarks,
        assistance.rowVersion,
      ),
    );
  }

  Future<void> reject(AgriculturalAssistance assistance, String remarks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () =>
          _repository.reject(assistance.id, remarks, assistance.rowVersion),
    );
  }

  Future<void> pay(AgriculturalAssistance assistance, String remarks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.markAsPaid(
        assistance.id,
        remarks,
        assistance.rowVersion,
      ),
    );
  }
}

final assistanceActionProvider =
    StateNotifierProvider<AgriculturalAssistanceNotifier, AsyncValue<void>>((ref) {
      return AgriculturalAssistanceNotifier(ref.watch(assistanceRepositoryProvider));
    });
