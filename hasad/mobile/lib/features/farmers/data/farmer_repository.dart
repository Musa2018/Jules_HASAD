import 'package:drift/drift.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:uuid/uuid.dart';

class FarmerException implements Exception {
  final List<String> errors;
  FarmerException(this.errors);
  @override
  String toString() =>
      errors.isEmpty ? 'An error occurred.' : errors.join('\n');
}

abstract class FarmerRepository {
  Future<List<domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
  });
  Future<domain.Farmer> getFarmer(String id);
  Future<domain.Farmer> createFarmer(domain.Farmer farmer);
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer);
  Future<void> deleteFarmer(String id);
}

class OfflineFirstFarmerRepository implements FarmerRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstFarmerRepository(this._db, this._syncService);

  @override
  Future<List<domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final items =
        await (_db.select(_db.farmers)
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
              ..limit(pageSize, offset: (pageNumber - 1) * pageSize))
            .get();

    return items.map(_mapToDomain).toList();
  }

  @override
  Future<domain.Farmer> getFarmer(String id) async {
    final e = await (_db.select(
      _db.farmers,
    )..where((t) => t.id.equals(id))).getSingle();
    return _mapToDomain(e);
  }

  domain.Farmer _mapToDomain(FarmerLocal e) {
    return domain.Farmer(
      id: e.id,
      serverId: e.serverId,
      clientId: e.id,
      idTypeId: e.idTypeId,
      idNumber: e.idNumber,
      firstNameAr: e.firstNameAr,
      fatherNameAr: e.fatherNameAr,
      grandfatherNameAr: e.grandfatherNameAr,
      familyNameAr: e.familyNameAr,
      firstNameEn: e.firstNameEn,
      fatherNameEn: e.fatherNameEn,
      grandfatherNameEn: e.grandfatherNameEn,
      familyNameEn: e.familyNameEn,
      birthDate: e.birthDate ?? DateTime(1900),
      gender: Gender.values[e.gender],
      phoneNumber: e.phoneNumber,
      familySize: e.familySize,
      governorateId: e.governorateId,
      localityId: e.localityId,
      address: e.address,
      rowVersion: e.rowVersion,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  @override
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    final localId = farmer.id.isEmpty ? const Uuid().v4() : farmer.id;
    final companion = FarmersCompanion.insert(
      id: localId,
      serverId: Value(farmer.serverId),
      idTypeId: Value(farmer.idTypeId),
      idNumber: Value(farmer.idNumber),
      firstNameAr: Value(farmer.firstNameAr),
      fatherNameAr: Value(farmer.fatherNameAr),
      grandfatherNameAr: Value(farmer.grandfatherNameAr),
      familyNameAr: Value(farmer.familyNameAr),
      firstNameEn: Value(farmer.firstNameEn),
      fatherNameEn: Value(farmer.fatherNameEn),
      grandfatherNameEn: Value(farmer.grandfatherNameEn),
      familyNameEn: Value(farmer.familyNameEn),
      birthDate: Value(farmer.birthDate),
      gender: Value(farmer.gender.index),
      phoneNumber: Value(farmer.phoneNumber),
      familySize: Value(farmer.familySize),
      governorateId: Value(farmer.governorateId),
      localityId: Value(farmer.localityId),
      address: Value(farmer.address),
      rowVersion: Value(farmer.rowVersion),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.farmers).insert(companion);

    final createdFarmer = farmer.copyWith(id: localId, clientId: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'farmer',
      operation: 'create',
      data: createdFarmer.toJson(),
    );

    return createdFarmer;
  }

  @override
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer) async {
    await (_db.update(_db.farmers)..where((t) => t.id.equals(farmer.id))).write(
      FarmersCompanion(
        serverId: Value(farmer.serverId),
        idTypeId: Value(farmer.idTypeId),
        idNumber: Value(farmer.idNumber),
        firstNameAr: Value(farmer.firstNameAr),
        fatherNameAr: Value(farmer.fatherNameAr),
        grandfatherNameAr: Value(farmer.grandfatherNameAr),
        familyNameAr: Value(farmer.familyNameAr),
        firstNameEn: Value(farmer.firstNameEn),
        fatherNameEn: Value(farmer.fatherNameEn),
        grandfatherNameEn: Value(farmer.grandfatherNameEn),
        familyNameEn: Value(farmer.familyNameEn),
        birthDate: Value(farmer.birthDate),
        gender: Value(farmer.gender.index),
        phoneNumber: Value(farmer.phoneNumber),
        familySize: Value(farmer.familySize),
        governorateId: Value(farmer.governorateId),
        localityId: Value(farmer.localityId),
        address: Value(farmer.address),
        rowVersion: Value(farmer.rowVersion),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: farmer.id,
      entityType: 'farmer',
      operation: 'update',
      data: farmer.toJson(),
    );

    return farmer;
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await (_db.delete(_db.farmers)..where((t) => t.id.equals(id))).go();

    await _syncService.addToQueue(
      localId: id,
      entityType: 'farmer',
      operation: 'delete',
      data: {},
    );
  }
}
