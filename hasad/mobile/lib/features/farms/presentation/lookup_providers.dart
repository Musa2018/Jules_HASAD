import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';

final ownershipTypesProvider = FutureProvider<List<OwnershipType>>((ref) async {
  final db = ref.watch(databaseProvider);
  final items = await db.select(db.ownershipTypes).get();
  return items.map((e) => OwnershipType(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList();
});

final agriculturalSectorsProvider = FutureProvider<List<AgriculturalSector>>((ref) async {
  final db = ref.watch(databaseProvider);
  final items = await db.select(db.agriculturalSectors).get();
  return items.map((e) => AgriculturalSector(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList();
});

final politicalClassificationsProvider = FutureProvider<List<PoliticalClassification>>((ref) async {
  final db = ref.watch(databaseProvider);
  final items = await db.select(db.politicalClassifications).get();
  return items.map((e) => PoliticalClassification(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList();
});

final areaUnitsProvider = FutureProvider<List<AreaUnit>>((ref) async {
  final db = ref.watch(databaseProvider);
  final items = await db.select(db.areaUnits).get();
  return items.map((e) => AreaUnit(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList();
});

final relationshipToOwnersProvider = FutureProvider<List<RelationshipToOwner>>((ref) async {
  final db = ref.watch(databaseProvider);
  final items = await db.select(db.relationshipToOwners).get();
  return items.map((e) => RelationshipToOwner(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn)).toList();
});
