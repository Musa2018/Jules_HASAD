import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';

class DamageCauseWizardState {
  final int currentStep;
  final DamageCauseCategory? selectedCategory;
  final DamageCause? selectedCause;

  const DamageCauseWizardState({
    this.currentStep = 1,
    this.selectedCategory,
    this.selectedCause,
  });

  DamageCauseWizardState copyWith({
    int? currentStep,
    DamageCauseCategory? selectedCategory,
    bool clearCategory = false,
    DamageCause? selectedCause,
    bool clearCause = false,
  }) {
    return DamageCauseWizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedCause: clearCause ? null : (selectedCause ?? this.selectedCause),
    );
  }
}

class DamageCauseWizardNotifier extends StateNotifier<DamageCauseWizardState> {
  DamageCauseWizardNotifier() : super(const DamageCauseWizardState());

  void setCategory(DamageCauseCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      clearCause: true,
      currentStep: 2,
    );
  }

  void setCause(DamageCause cause) {
    state = state.copyWith(
      selectedCause: cause,
    );
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const DamageCauseWizardState();
  }

  void loadFromIds(int? categoryId, int? causeId, List<DamageCauseCategory> categories, List<DamageCause> allCauses) {
    if (categoryId == null || categoryId == 0) return;
    
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    if (category == null) return;

    DamageCause? cause;
    if (causeId != null && causeId != 0) {
      cause = allCauses.where((c) => c.id == causeId).firstOrNull;
    }

    state = DamageCauseWizardState(
      currentStep: cause != null ? 2 : 1,
      selectedCategory: category,
      selectedCause: cause,
    );
  }
}

final damageCauseWizardProvider =
    StateNotifierProvider.autoDispose<DamageCauseWizardNotifier, DamageCauseWizardState>((ref) {
  return DamageCauseWizardNotifier();
});
