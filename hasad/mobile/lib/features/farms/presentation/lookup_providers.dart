import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import '../data/reference_data_repository.dart';
import '../data/remote_reference_data_repository.dart';
import '../data/offline_first_reference_data_repository.dart';
import '../domain/lookup_entities.dart';
import '../domain/reference_data.dart';

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>((ref) {
  final remote = RemoteReferenceDataRepository(ref.watch(apiDioProvider));
  return OfflineFirstReferenceDataRepository(ref.watch(databaseProvider), remote);
});

final referenceDataProvider = FutureProvider<ReferenceData>((ref) async {
  return ref.watch(referenceDataRepositoryProvider).getReferenceData();
});

final ownershipTypesProvider = FutureProvider<List<OwnershipType>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.ownershipTypes;
});

final agriculturalSectorsProvider = FutureProvider<List<AgriculturalSector>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.agriculturalSectors;
});

final politicalClassificationsProvider = FutureProvider<List<PoliticalClassification>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.politicalClassifications;
});

final areaUnitsProvider = FutureProvider<List<AreaUnit>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.areaUnits;
});

final measurementUnitsProvider = FutureProvider<List<MeasurementUnit>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.measurementUnits;
});

final costingSheetCatalogsProvider = FutureProvider<List<CostingSheetCatalog>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.costingSheetCatalogs;
});

final costingSheetVersionsProvider = FutureProvider<List<CostingSheetVersion>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.costingSheetVersions;
});

final costingSheetItemsProvider = FutureProvider<List<CostingSheetItem>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.costingSheetItems;
});

final damageCauseCategoriesProvider = FutureProvider<List<DamageCauseCategory>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.damageCauseCategories;
});

final damageCausesByCategoryProvider = FutureProvider.family<List<DamageCause>, int>((ref, categoryId) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.damageCauses.where((c) => c.parentId == categoryId).toList();
});

final relationshipToOwnersProvider = FutureProvider<List<RelationshipToOwner>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.relationshipToOwners;
});

final measurementUnitByIdProvider = FutureProvider.family<MeasurementUnit?, int>((ref, id) async {
  final units = await ref.watch(measurementUnitsProvider.future);
  return units.where((u) => u.id == id).firstOrNull;
});
