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
  Future<void> synchronize({DateTime? updatedSince}) async {
    final remoteData = await _remote.getReferenceData(forceRefresh: true);
    await _saveToLocal(remoteData);
  }

  @override
  Future<List<domain.DamageNature>> getNatures() async {
    final items = await _db.select(_db.damageNatures).get();
    return items
        .map((e) => domain.DamageNature(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
        .toList();
  }

  @override
  Future<List<domain.DamageAction>> getActions() async {
    final items = await _db.select(_db.damageActions).get();
    return items
        .map((e) => domain.DamageAction(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
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

  @override
  Future<List<domain.CostingSheetItem>> searchCostingItems(String query) async {
    // 1. Robust Fetch: Join items with classifications to get names for searching
    final queryExp = _db.select(_db.costingSheetItems).join([
      leftOuterJoin(
        _db.damageClassifications,
        _db.damageClassifications.id
            .equalsExp(_db.costingSheetItems.classificationId),
      ),
      leftOuterJoin(
        _db.costingSheetVersions,
        _db.costingSheetVersions.id.equalsExp(_db.costingSheetItems.versionId),
      ),
    ]);

    final rows = await queryExp.get();

    // 2. Map and filter in memory to avoid complex SQL join issues on small datasets
    final items = rows.map((row) {
      final item = row.readTable(_db.costingSheetItems);
      final cl = row.readTableOrNull(_db.damageClassifications);
      final ver = row.readTableOrNull(_db.costingSheetVersions);
      
      return (item: item, classification: cl, version: ver);
    }).toList();

    final filtered = items.where((e) {
      // Filter for Active versions only (status 2) if version exists
      if (e.version != null && e.version!.status != 2) return false;
      
      if (query.isEmpty) return true;
      
      final pattern = query.toLowerCase();
      final codeMatch = e.item.code.toLowerCase().contains(pattern);
      final nameArMatch = e.classification?.nameAr.contains(pattern) ?? false;
      final nameEnMatch = e.classification?.nameEn.toLowerCase().contains(pattern) ?? false;
      
      return codeMatch || nameArMatch || nameEnMatch;
    }).toList();

    return filtered.map((e) => domain.CostingSheetItem(
      id: e.item.id,
      code: e.item.code,
      versionId: e.item.versionId,
      classificationId: e.item.classificationId,
      measurementUnitId: e.item.measurementUnitId,
      unitPrice: e.item.unitPrice,
      createdAt: e.item.createdAt,
    )).toList();
  }

  Future<ReferenceData> _loadFromLocal() async {
    final ownership = await _db.select(_db.ownershipTypes).get();
    final sectors = await _db.select(_db.agriculturalSectors).get();
    final political = await _db.select(_db.politicalClassifications).get();
    final areaUnits = await _db.select(_db.areaUnits).get(); // Legacy
    final measurementUnits = await _db.select(_db.measurementUnits).get();
    final relationships = await _db.select(_db.relationshipToOwners).get();
    final documentTypes = await _db.select(_db.documentTypes).get();

    // Damage Hierarchy
    final natures = await _db.select(_db.damageNatures).get();
    final actions = await _db.select(_db.damageActions).get();
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
      documentTypes: documentTypes
          .map((e) => domain.DocumentType(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn, isActive: e.isActive))
          .toList(),
      damageNatures: natures
          .map((e) => domain.DamageNature(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
          .toList(),
      damageActions: actions
          .map((e) => domain.DamageAction(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn))
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
              code: e.code,
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
        data.documentTypes.isNotEmpty &&
        data.damageNatures.isNotEmpty &&
        data.costingSheetItems.isNotEmpty;
  }

  Future<void> _saveToLocal(ReferenceData data) async {
    await _db.batch((batch) {
      // 1. ABSOLUTE PURGE: Clear all lookup tables to avoid ID conflicts after server resets
      batch.deleteWhere(_db.ownershipTypes, (t) => const Constant(true));
      batch.deleteWhere(_db.agriculturalSectors, (t) => const Constant(true));
      batch.deleteWhere(_db.politicalClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.areaUnits, (t) => const Constant(true));
      batch.deleteWhere(_db.measurementUnits, (t) => const Constant(true));
      batch.deleteWhere(_db.relationshipToOwners, (t) => const Constant(true));
      batch.deleteWhere(_db.documentTypes, (t) => const Constant(true));
      batch.deleteWhere(_db.damageNatures, (t) => const Constant(true));
      batch.deleteWhere(_db.damageActions, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageSubCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauseCategories, (t) => const Constant(true));
      batch.deleteWhere(_db.damageCauses, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheetCatalogs, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheetVersions, (t) => const Constant(true));
      batch.deleteWhere(_db.costingSheetItems, (t) => const Constant(true));

      // 2. INSERT FRESH DATA
      batch.insertAll(_db.ownershipTypes, data.ownershipTypes.map((e) => OwnershipTypesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);
      
      batch.insertAll(_db.agriculturalSectors, data.agriculturalSectors.map((e) => AgriculturalSectorsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.politicalClassifications, data.politicalClassifications.map((e) => PoliticalClassificationsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.areaUnits, data.areaUnits.map((e) => AreaUnitsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.measurementUnits, data.measurementUnits.map((e) => MeasurementUnitsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
        code: Value(e.code),
        category: e.category,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.relationshipToOwners, data.relationshipToOwners.map((e) => RelationshipToOwnersCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.documentTypes, data.documentTypes.map((e) => DocumentTypesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
        isActive: Value(e.isActive),
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageNatures, data.damageNatures.map((e) => DamageNaturesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageActions, data.damageActions.map((e) => DamageActionsCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageCategories, data.damageCategories.map((e) => DamageCategoriesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageSubCategories, data.damageSubCategories.map((e) => DamageSubCategoriesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageClassifications, data.damageClassifications.map((e) => DamageClassificationsCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageCauseCategories, data.damageCauseCategories.map((e) => DamageCauseCategoriesCompanion.insert(
        id: Value(e.id),
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.damageCauses, data.damageCauses.map((e) => DamageCausesCompanion.insert(
        id: Value(e.id),
        parentId: e.parentId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
      )), mode: InsertMode.insertOrReplace);

      // Hierarchical Pricing
      batch.insertAll(_db.costingSheetCatalogs, data.costingSheetCatalogs.map((e) => CostingSheetCatalogsCompanion.insert(
        id: e.id,
        name: e.name,
        description: Value(e.description),
        createdAt: Value(e.createdAt),
        createdBy: e.createdBy,
      )), mode: InsertMode.insertOrReplace);

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
      )), mode: InsertMode.insertOrReplace);

      batch.insertAll(_db.costingSheetItems, data.costingSheetItems.map((e) => CostingSheetItemsCompanion.insert(
        id: e.id,
        code: Value(e.code),
        versionId: e.versionId,
        classificationId: e.classificationId,
        measurementUnitId: Value(e.measurementUnitId),
        unitPrice: e.unitPrice,
        createdAt: Value(e.createdAt),
      )), mode: InsertMode.insertOrReplace);

      // Backward compatibility: Only process legacy list if modern hierarchy is missing
      if (data.costingSheetItems.isEmpty && data.legacyCostingSheets.isNotEmpty) {
        final serverLegacyCatalogId = 'LEGACY-CATALOG-SERVER';
        final serverLegacyVersionId = 'LEGACY-VERSION-SERVER';

        batch.insert(_db.costingSheetCatalogs, CostingSheetCatalogsCompanion.insert(
          id: serverLegacyCatalogId,
          name: 'Server Legacy Catalog',
          description: const Value('Wrapper for flat pricing items from server.'),
          createdBy: 'System',
        ), mode: InsertMode.insertOrReplace);

        batch.insert(_db.costingSheetVersions, CostingSheetVersionsCompanion.insert(
          id: serverLegacyVersionId,
          catalogId: serverLegacyCatalogId,
          versionNumber: 1,
          status: 2, // Active
          effectiveFrom: DateTime(2000),
          createdBy: 'System',
        ), mode: InsertMode.insertOrReplace);

        batch.insertAll(_db.costingSheetItems, data.legacyCostingSheets.map((e) => CostingSheetItemsCompanion.insert(
          id: e.id,
          code: Value(e.code),
          versionId: serverLegacyVersionId,
          classificationId: e.classificationId,
          measurementUnitId: Value(e.measurementUnitId),
          unitPrice: e.unitPrice,
          createdAt: Value(e.createdAt),
        )), mode: InsertMode.insertOrReplace);
      }
    });
  }
}
