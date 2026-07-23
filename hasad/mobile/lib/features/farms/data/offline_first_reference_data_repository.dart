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

  Future<ReferenceData> _loadFromLocal() async {
    final ownership = await _db.select(_db.ownershipTypes).get();
    final sectors = await _db.select(_db.agriculturalSectors).get();
    final political = await _db.select(_db.politicalClassifications).get();
    final units = await _db.select(_db.areaUnits).get();
    final relationships = await _db.select(_db.relationshipToOwners).get();

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
    );
  }

  bool _isDataComplete(ReferenceData data) {
    return data.ownershipTypes.isNotEmpty &&
        data.agriculturalSectors.isNotEmpty &&
        data.politicalClassifications.isNotEmpty &&
        data.areaUnits.isNotEmpty &&
        data.relationshipToOwners.isNotEmpty;
  }

  Future<void> _saveToLocal(ReferenceData data) async {
    await _db.batch((batch) {
      // Clear existing to ensure sync
      batch.deleteWhere(_db.ownershipTypes, (t) => const Constant(true));
      batch.deleteWhere(_db.agriculturalSectors, (t) => const Constant(true));
      batch.deleteWhere(_db.politicalClassifications, (t) => const Constant(true));
      batch.deleteWhere(_db.areaUnits, (t) => const Constant(true));
      batch.deleteWhere(_db.relationshipToOwners, (t) => const Constant(true));

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
    });
  }
}
