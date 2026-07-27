import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';

class DamageItemSelectionState {
  final CostingSheetItem? selectedCosting;
  final DamageClassification? classification;
  final DamageSubCategory? subCategory;
  final DamageCategory? category;
  final DamageNature? nature;
  final DamageAction? action;
  final bool isLoading;
  final String? error;

  const DamageItemSelectionState({
    this.selectedCosting,
    this.classification,
    this.subCategory,
    this.category,
    this.nature,
    this.action,
    this.isLoading = false,
    this.error,
  });

  DamageItemSelectionState copyWith({
    CostingSheetItem? selectedCosting,
    DamageClassification? classification,
    DamageSubCategory? subCategory,
    DamageCategory? category,
    DamageNature? nature,
    DamageAction? action,
    bool clearAction = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return DamageItemSelectionState(
      selectedCosting: selectedCosting ?? this.selectedCosting,
      classification: classification ?? this.classification,
      subCategory: subCategory ?? this.subCategory,
      category: category ?? this.category,
      nature: nature ?? this.nature,
      action: clearAction ? null : (action ?? this.action),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class DamageItemSelectionNotifier extends StateNotifier<DamageItemSelectionState> {
  final Ref _ref;

  DamageItemSelectionNotifier(this._ref) : super(const DamageItemSelectionState());

  Future<void> selectItem(CostingSheetItem item) async {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      final refData = await _ref.read(referenceDataProvider.future);
      
      // 1. Classification
      final classification = refData.damageClassifications
          .where((c) => c.id == item.classificationId)
          .firstOrNull;
      
      if (classification == null) throw Exception('Classification not found');

      // 2. SubCategory
      final subCategory = refData.damageSubCategories
          .where((s) => s.id == classification.parentId)
          .firstOrNull;

      // 3. Category
      final category = refData.damageCategories
          .where((c) => c.id == subCategory?.parentId)
          .firstOrNull;

      // 4. Nature (Derived from Category's AgriculturalSectorId)
      final nature = refData.damageNatures
          .where((n) => n.id == category?.parentId) // ParentId of Category is NatureId
          .firstOrNull;

      state = state.copyWith(
        selectedCosting: item,
        classification: classification,
        subCategory: subCategory,
        category: category,
        nature: nature,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setAction(DamageAction action) {
    state = state.copyWith(action: action);
  }

  void reset() {
    state = const DamageItemSelectionState();
  }
}

final damageItemSelectionProvider = StateNotifierProvider.autoDispose<DamageItemSelectionNotifier, DamageItemSelectionState>((ref) {
  return DamageItemSelectionNotifier(ref);
});
