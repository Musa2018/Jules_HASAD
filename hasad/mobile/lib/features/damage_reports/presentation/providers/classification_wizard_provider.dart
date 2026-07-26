import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';

class ClassificationWizardState {
  final int currentStep;
  final DamageNature? selectedNature;
  final DamageAction? selectedAction;
  final DamageCategory? selectedCategory;
  final DamageSubCategory? selectedSubCategory;
  final DamageClassification? selectedClassification;
  final CostingSheetItem? resolvedCosting;
  final bool isLoading;
  final String? error;

  const ClassificationWizardState({
    this.currentStep = 1,
    this.selectedNature,
    this.selectedAction,
    this.selectedCategory,
    this.selectedSubCategory,
    this.selectedClassification,
    this.resolvedCosting,
    this.isLoading = false,
    this.error,
  });

  ClassificationWizardState copyWith({
    int? currentStep,
    DamageNature? selectedNature,
    bool clearNature = false,
    DamageAction? selectedAction,
    bool clearAction = false,
    DamageCategory? selectedCategory,
    bool clearCategory = false,
    DamageSubCategory? selectedSubCategory,
    bool clearSubCategory = false,
    DamageClassification? selectedClassification,
    bool clearClassification = false,
    CostingSheetItem? resolvedCosting,
    bool clearCosting = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ClassificationWizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedNature: clearNature ? null : (selectedNature ?? this.selectedNature),
      selectedAction: clearAction ? null : (selectedAction ?? this.selectedAction),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedSubCategory: clearSubCategory ? null : (selectedSubCategory ?? this.selectedSubCategory),
      selectedClassification: clearClassification ? null : (selectedClassification ?? this.selectedClassification),
      resolvedCosting: clearCosting ? null : (resolvedCosting ?? this.resolvedCosting),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ClassificationWizardNotifier extends StateNotifier<ClassificationWizardState> {
  final Ref _ref;

  ClassificationWizardNotifier(this._ref)
      : super(const ClassificationWizardState());

  void setNature(DamageNature nature) {
    state = state.copyWith(
      selectedNature: nature,
      clearAction: true,
      clearCategory: true,
      clearSubCategory: true,
      clearClassification: true,
      clearCosting: true,
      currentStep: 2,
    );
  }

  void setAction(DamageAction action) {
    state = state.copyWith(
      selectedAction: action,
      clearCategory: true,
      clearSubCategory: true,
      clearClassification: true,
      clearCosting: true,
      currentStep: 3,
    );
  }

  void setCategory(DamageCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      clearSubCategory: true,
      clearClassification: true,
      clearCosting: true,
      currentStep: 4,
    );
  }

  void setSubCategory(DamageSubCategory subCategory) {
    state = state.copyWith(
      selectedSubCategory: subCategory,
      clearClassification: true,
      clearCosting: true,
      currentStep: 5,
    );
  }

  Future<void> setClassification(DamageClassification classification) async {
    state = state.copyWith(
      selectedClassification: classification,
      isLoading: true,
      clearCosting: true,
    );

    try {
      final repo = _ref.read(referenceDataRepositoryProvider);
      final costing = await repo.getActiveCostingSheet(classification.id);

      state = state.copyWith(
        resolvedCosting: costing,
        isLoading: false,
        error: costing == null ? 'No active pricing found for this item.' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to resolve pricing: ${e.toString()}',
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const ClassificationWizardState();
  }
}

final classificationWizardProvider = StateNotifierProvider.family
    .autoDispose<ClassificationWizardNotifier, ClassificationWizardState, int>(
        (ref, sectorId) {
  return ClassificationWizardNotifier(ref);
});

// Cascading Filter Providers
final naturesProvider = FutureProvider<List<DamageNature>>((ref) {
  return ref.watch(referenceDataRepositoryProvider).getNatures();
});

final actionsProvider = FutureProvider<List<DamageAction>>((ref) {
  return ref.watch(referenceDataRepositoryProvider).getActions();
});

final categoriesBySectorProvider =
    FutureProvider.family<List<DamageCategory>, int>((ref, sectorId) {
  // Use parentId as agriculturalSectorId
  return ref.watch(referenceDataRepositoryProvider).getCategories(sectorId);
});

final subCategoriesByCategoryProvider = FutureProvider.family<List<DamageSubCategory>, int>((ref, categoryId) {
  return ref.watch(referenceDataRepositoryProvider).getSubCategories(categoryId);
});

final classificationsBySubCategoryProvider = FutureProvider.family<List<DamageClassification>, int>((ref, subId) {
  return ref.watch(referenceDataRepositoryProvider).getClassifications(subId);
});
