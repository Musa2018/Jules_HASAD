import '../domain/lookup_entities.dart';
import '../domain/reference_data.dart';

abstract class ReferenceDataRepository {
  Future<ReferenceData> getReferenceData({bool forceRefresh = false});

  // Hierarchical Lookups
  Future<List<DamageNature>> getNatures();
  Future<List<DamageCategory>> getCategories(int natureId);
  Future<List<DamageSubCategory>> getSubCategories(int categoryId);
  Future<List<DamageClassification>> getClassifications(int subCategoryId);
  Future<CostingSheetVersion?> getActiveCostingSheet(int classificationId);

  // Search
  Future<List<DamageClassification>> searchClassifications(String query);
}
