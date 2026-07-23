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

final relationshipToOwnersProvider = FutureProvider<List<RelationshipToOwner>>((ref) async {
  final data = await ref.watch(referenceDataProvider.future);
  return data.relationshipToOwners;
});
