import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';
import '../domain/lookup_entities.dart' as domain;
import '../domain/reference_data.dart';
import 'reference_data_repository.dart';

class OfflineFirstReferenceDataRepository implements ReferenceDataRepository {
  final AppDatabase _db;
  final ReferenceDataRepository _remote;

  OfflineFirstReferenceDataRepository(this._db, this._remote);

  @override
  Future<ReferenceData> getReferenceData({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localData = await _loadFromLocal();
      if (_isDataComplete(localData)) {
        return localData;
      }
    }

    final remoteData = await _remote.getReferenceData();
    await _saveToLocal(remoteData);
    return remoteData;
  }

  @override
  Future<List<domain.DamageNature>> getNatures() async {
    final items = await _db.select(_db.damageNatures).get();
    return items
        .map((e) => domain.DamageNature(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<List<domain.DamageCategory>> getCategories(int natureId) async {
    final items = await (_db.select(_db.damageCategories)
          ..where((t) => t.parentId.equals(natureId)))
        .get();
    return items
        .map((e) => domain.DamageCategory(
            id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<List<domain.DamageSubCategory>> getSubCategories(int categoryId) async {
    final items = await (_db.select(_db.damageSubCategories)
          ..where((t) => t.parentId.equals(categoryId)))
        .get();
    return items
        .map((e) => domain.DamageSubCategory(
            id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<List<domain.DamageClassification>> getClassifications(
    int subCategoryId,
  ) async {
    final items = await (_db.select(_db.damageClassifications)
          ..where((t) => t.parentId.equals(subCategoryId)))
        .get();
    return items
        .map((e) => domain.DamageClassification(
            id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<domain.CostingSheetVersion?> getActiveCostingSheet(
    int classificationId,
  ) async {
    final item = await (_db.select(_db.costingSheets)
          ..where((t) =>
              t.classificationId.equals(classificationId) &
              t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();

    if (item == null) return null;

    return domain.CostingSheetVersion(
      id: item.id,
      classificationId: item.classificationId,
      unitPrice: item.unitPrice,
      effectiveFrom: item.effectiveFrom,
      effectiveTo: item.effectiveTo,
      isActive: item.isActive,
      versionNumber: item.versionNumber,
    );
  }

  @override
  Future<List<domain.DamageClassification>> searchClassifications(
    String query,
  ) async {
    if (query.isEmpty) return [];
    final pattern = '%$query%';
    final items = await (_db.select(_db.damageClassifications)
          ..where((t) => t.nameAr.like(pattern) | t.nameEn.like(pattern)))
        .get();

    return items
        .map((e) => domain.DamageClassification(
            id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  Future<ReferenceData> _loadFromLocal() async {
    final ownership = await _db.select(_db.ownershipTypes).get();
    final sectors = await _db.select(_db.agriculturalSectors).get();
    final political = await _db.select(_db.politicalClassifications).get();
    final units = await _db.select(_db.areaUnits).get();
    final relationships = await _db.select(_db.relationshipToOwners).get();

    // Damage Hierarchy
    final natures = await _db.select(_db.damageNatures).get();
    final categories = await _db.select(_db.damageCategories).get();
    final subCategories = await _db.select(_db.damageSubCategories).get();
    final classifications = await _db.select(_db.damageClassifications).get();

    // Damage Causes
    final causeCategories = await _db.select(_db.damageCauseCategories).get();
    final causes = await _db.select(_db.damageCauses).get();

    final costs = await _db.select(_db.costingSheets).get();

    return ReferenceData(
      ownershipTypes: ownership
          .map((e) => domain.OwnershipType(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      agriculturalSectors: sectors
          .map((e) => domain.AgriculturalSector(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      politicalClassifications: political
          .map((e) => domain.PoliticalClassification(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      areaUnits: units
          .map((e) => domain.AreaUnit(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      relationshipToOwners: relationships
          .map((e) => domain.RelationshipToOwner(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageNatures: natures
          .map((e) => domain.DamageNature(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageCategories: categories
          .map((e) => domain.DamageCategory(
              id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageSubCategories: subCategories
          .map((e) => domain.DamageSubCategory(
              id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageClassifications: classifications
          .map((e) => domain.DamageClassification(
              id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageCauseCategories: causeCategories
          .map((e) => domain.DamageCauseCategory(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageCauses: causes
          .map((e) => domain.DamageCause(
              id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      costingSheets: costs
          .map((e) => domain.CostingSheetVersion(
              id: e.id,
              classificationId: e.classificationId,
              unitPrice: e.unitPrice,
              effectiveFrom: e.effectiveFrom,
              effectiveTo: e.effectiveTo,
              isActive: e.isActive,
              versionNumber: e.versionNumber))
          .toList(),
    );
  }

  bool _isDataComplete(ReferenceData data) {
    return data.ownershipTypes.isNotEmpty &&
        data.agriculturalSectors.isNotEmpty &&
        data.politicalClassifications.isNotEmpty &&
        data.areaUnits.isNotEmpty &&
        data.relationshipToOwners.isNotEmpty &&
        data.damageNatures.isNotEmpty;
  }

  Future<void> _saveToLocal(ReferenceData data) async {
    await _db.batch((batch) {
      // Clear existing to ensure sync
      batch.deleteWhere(_db.ownershipTypes, (t) => const Constant(true));
      batch.deleteWhere(_db.agriculturalSectors, (t) => const Constant(true));
      batch.deleteWhere(_db.politicalClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.areaUnits, (t) => const Constant(true));
      batch.deleteWhere(_db.relationshipToOwners, (t) => const Constant(true));
      batch.deleteWhere(_db.damageNatures, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageSubCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauseCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauses, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheets, (t) => const Constant(true));

      batch.insertAll(_db.ownershipTypes, data.ownershipTypes.map((e) => OwnershipTypesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));
      
      batch.insertAll(_db.agriculturalSectors, data.agriculturalSectors.map((e) => AgriculturalSectorsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.politicalClassifications, data.politicalClassifications.map((e) => PoliticalClassificationsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.areaUnits, data.areaUnits.map((e) => AreaUnitsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.relationshipToOwners, data.relationshipToOwners.map((e) => RelationshipToOwnersCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageNatures, data.damageNatures.map((e) => DamageNaturesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageCategories, data.damageCategories.map((e) => DamageCategoriesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageSubCategories, data.damageSubCategories.map((e) => DamageSubCategoriesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageClassifications, data.damageClassifications.map((e) => DamageClassificationsCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageCauseCategories, data.damageCauseCategories.map((e) => DamageCauseCategoriesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.damageCauses, data.damageCauses.map((e) => DamageCausesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )));

      batch.insertAll(_db.costingSheets, data.costingSheets.map((e) => CostingSheetsCompanion.insert(
        id: e.id,
        classificationId: e.classificationId,
        unitPrice: e.unitPrice,
        effectiveFrom: e.effectiveFrom,
        effectiveTo: Value(e.effectiveTo),
        isActive: Value(e.isActive),
        versionNumber: e.versionNumber,
      )));
    });
  }
}
