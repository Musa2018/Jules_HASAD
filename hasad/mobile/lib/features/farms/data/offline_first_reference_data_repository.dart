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
  Future<domain.CostingSheetItem?> getActiveCostingSheet(
    int classificationId,
  ) async {
    // Resolve price from the Active version
    final query = _db.select(_db.costingSheetItems).join([
      innerJoin(
        _db.costingSheetVersions,
        _db.costingSheetVersions.id.equalsExp(_db.costingSheetItems.versionId),
      ),
    ])
      ..where(_db.costingSheetItems.classificationId.equals(classificationId) &
          _db.costingSheetVersions.status.equals(2)); // 2: Active

    final row = await query.getSingleOrNull();

    if (row == null) return null;

    final item = row.readTable(_db.costingSheetItems);

    return domain.CostingSheetItem(
      id: item.id,
      versionId: item.versionId,
      classificationId: item.classificationId,
      measurementUnitId: item.measurementUnitId,
      unitPrice: item.unitPrice,
      createdAt: item.createdAt,
    );
  }

  @override
  Future<List<domain.DamageCauseCategory>> getDamageCauseCategories() async {
    final items = await _db.select(_db.damageCauseCategories).get();
    return items
        .map((e) => domain.DamageCauseCategory(
            id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<List<domain.DamageCause>> getDamageCauses(int categoryId) async {
    final items = await (_db.select(_db.damageCauses)
          ..where((t) => t.parentId.equals(categoryId)))
        .get();
    return items
        .map((e) => domain.DamageCause(
            id: e.id, parentId: e.parentId, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
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
    final areaUnits = await _db.select(_db.areaUnits).get(); // Legacy
    final measurementUnits = await _db.select(_db.measurementUnits).get();
    final relationships = await _db.select(_db.relationshipToOwners).get();

    // Damage Hierarchy
    final natures = await _db.select(_db.damageNatures).get();
    final categories = await _db.select(_db.damageCategories).get();
    final subCategories = await _db.select(_db.damageSubCategories).get();
    final classifications = await _db.select(_db.damageClassifications).get();

    // Damage Causes
    final causeCategories = await _db.select(_db.damageCauseCategories).get();
    final causes = await _db.select(_db.damageCauses).get();

    // Costing Hierarchy
    final catalogs = await _db.select(_db.costingSheetCatalogs).get();
    final versions = await _db.select(_db.costingSheetVersions).get();
    final items = await _db.select(_db.costingSheetItems).get();

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
      areaUnits: areaUnits
          .map((e) => domain.AreaUnit(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      measurementUnits: measurementUnits
          .map((e) => domain.MeasurementUnit(
              id: e.id, 
              nameAr: e.nameAr, 
              nameEn: e.nameEn, 
              code: e.code, 
              category: e.category))
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
      costingSheetCatalogs: catalogs
          .map((e) => domain.CostingSheetCatalog(
              id: e.id, 
              name: e.name, 
              description: e.description, 
              createdAt: e.createdAt, 
              createdBy: e.createdBy))
          .toList(),
      costingSheetVersions: versions
          .map((e) => domain.CostingSheetVersion(
              id: e.id,
              catalogId: e.catalogId,
              versionNumber: e.versionNumber,
              status: e.status,
              effectiveFrom: e.effectiveFrom,
              effectiveTo: e.effectiveTo,
              createdAt: e.createdAt,
              createdBy: e.createdBy,
              approvedAt: e.approvedAt,
              approvedBy: e.approvedBy))
          .toList(),
      costingSheetItems: items
          .map((e) => domain.CostingSheetItem(
              id: e.id,
              versionId: e.versionId,
              classificationId: e.classificationId,
              measurementUnitId: e.measurementUnitId,
              unitPrice: e.unitPrice,
              createdAt: e.createdAt))
          .toList(),
      legacyCostingSheets: [], // Handled by backend compatibility during sync
    );
  }

  bool _isDataComplete(ReferenceData data) {
    return data.ownershipTypes.isNotEmpty &&
        data.agriculturalSectors.isNotEmpty &&
        data.politicalClassifications.isNotEmpty &&
        data.measurementUnits.isNotEmpty &&
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
      batch.deleteWhere(_db.measurementUnits, (t) => const Constant(true));
      batch.deleteWhere(_db.relationshipToOwners, (t) => const Constant(true));
      batch.deleteWhere(_db.damageNatures, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageSubCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauseCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauses, (t) => const Constant(true));
      
      batch.deleteWhere(_db.costingSheetCatalogs, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheetVersions, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheetItems, (t) => const Constant(true));

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

      batch.insertAll(_db.measurementUnits, data.measurementUnits.map((e) => MeasurementUnitsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
        code: Value(e.code),
        category: e.category,
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

      // Hierarchical Pricing
      batch.insertAll(_db.costingSheetCatalogs, data.costingSheetCatalogs.map((e) => CostingSheetCatalogsCompanion.insert(
        id: e.id,
        name: e.name,
        description: Value(e.description),
        createdAt: Value(e.createdAt),
        createdBy: e.createdBy,
      )));

      batch.insertAll(_db.costingSheetVersions, data.costingSheetVersions.map((e) => CostingSheetVersionsCompanion.insert(
        id: e.id,
        catalogId: e.catalogId,
        versionNumber: e.versionNumber,
        status: e.status,
        effectiveFrom: e.effectiveFrom,
        effectiveTo: Value(e.effectiveTo),
        createdAt: Value(e.createdAt),
        createdBy: e.createdBy,
        approvedAt: Value(e.approvedAt),
        approvedBy: Value(e.approvedBy),
      )));

      batch.insertAll(_db.costingSheetItems, data.costingSheetItems.map((e) => CostingSheetItemsCompanion.insert(
        id: e.id,
        versionId: e.versionId,
        classificationId: e.classificationId,
        measurementUnitId: Value(e.measurementUnitId),
        unitPrice: e.unitPrice,
        createdAt: Value(e.createdAt),
      )));

      // Backward compatibility: If the server sends flat costingSheets, 
      // we map them to a special Local Server Version for now.
      if (data.legacyCostingSheets.isNotEmpty) {
        final serverLegacyCatalogId = 'LEGACY-CATALOG-SERVER';
        final serverLegacyVersionId = 'LEGACY-VERSION-SERVER';

        batch.insert(_db.costingSheetCatalogs, CostingSheetCatalogsCompanion.insert(
          id: serverLegacyCatalogId,
          name: 'Server Legacy Catalog',
          description: const Value('Wrapper for flat pricing items from server.'),
          createdBy: 'System',
        ), mode: InsertMode.insertOrIgnore);

        batch.insert(_db.costingSheetVersions, CostingSheetVersionsCompanion.insert(
          id: serverLegacyVersionId,
          catalogId: serverLegacyCatalogId,
          versionNumber: 1,
          status: 2, // Active
          effectiveFrom: DateTime(2000),
          createdBy: 'System',
        ), mode: InsertMode.insertOrIgnore);

        batch.insertAll(_db.costingSheetItems, data.legacyCostingSheets.map((e) => CostingSheetItemsCompanion.insert(
          id: e.id,
          versionId: serverLegacyVersionId,
          classificationId: e.classificationId,
          measurementUnitId: Value(e.measurementUnitId),
          unitPrice: e.unitPrice,
          createdAt: Value(e.createdAt),
        )));
      }
    });
  }
}
