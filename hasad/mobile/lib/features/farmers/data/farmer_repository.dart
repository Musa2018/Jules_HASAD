import 'package:drift/drift.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;
import 'package:uuid/uuid.dart';

class FarmerException implements Exception {
  final List<String> errors;
  FarmerException(this.errors);
  @override
  String toString() => errors.isEmpty ? 'An error occurred.' : errors.join('\n');
}

abstract class FarmerRepository {
  Future<List<domain.Farmer>> getFarmers({int pageNumber = 1, int pageSize = 10});
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
  Future<List<domain.Farmer>> getFarmers({int pageNumber = 1, int pageSize = 10}) async {
    final items = await (_db.select(_db.farmers)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(pageSize, offset: (pageNumber - 1) * pageSize))
        .get();

    return items.map((e) => domain.Farmer(
          id: e.id,
          name: e.name,
          nationalId: e.nationalId,
          phoneNumber: e.phoneNumber,
          address: e.address,
          rowVersion: e.rowVersion,
        )).toList();
  }

  @override
  Future<domain.Farmer> getFarmer(String id) async {
    final e = await (_db.select(_db.farmers)..where((t) => t.id.equals(id))).getSingle();
    return domain.Farmer(
      id: e.id,
      name: e.name,
      nationalId: e.nationalId,
      phoneNumber: e.phoneNumber,
      address: e.address,
      rowVersion: e.rowVersion,
    );
  }

  @override
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    final localId = farmer.id.isEmpty ? const Uuid().v4() : farmer.id;
    final companion = FarmersCompanion.insert(
      id: localId,
      name: farmer.name,
      nationalId: farmer.nationalId,
      phoneNumber: farmer.phoneNumber,
      address: farmer.address,
      rowVersion: Value(farmer.rowVersion),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.farmers).insert(companion);

    final createdFarmer = farmer.copyWith(id: localId);

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
        name: Value(farmer.name),
        nationalId: Value(farmer.nationalId),
        phoneNumber: Value(farmer.phoneNumber),
        address: Value(farmer.address),
        rowVersion: Value(farmer.rowVersion),
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
