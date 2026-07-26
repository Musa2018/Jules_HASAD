import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';

class PullSyncCoordinator {
  final AppDatabase _db;
  final FarmerRepository _farmerRepository;
  final FarmRepository _farmRepository;

  PullSyncCoordinator(
    this._db,
    this._farmerRepository,
    this._farmRepository,
  );

  Future<void> synchronizeAll() async {
    await synchronizeFarmers();
    await synchronizeFarms();
  }

  Future<void> synchronizeFarmers() async {
    await _synchronizeEntity('farmer', _farmerRepository.synchronize);
  }

  Future<void> synchronizeFarms() async {
    await _synchronizeEntity('farm', _farmRepository.synchronize);
  }

  Future<void> _synchronizeEntity(
    String entityName,
    Future<void> Function({DateTime? updatedSince}) syncFunc,
  ) async {
    final metadata = await (_db.select(_db.syncMetadata)
          ..where((t) => t.entityName.equals(entityName)))
        .getSingleOrNull();

    final lastSync = metadata?.lastSyncedAt;
    final now = DateTime.now();

    try {
      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entityName: entityName,
              lastSyncStatus: const Value('syncing'),
            ),
          );

      await syncFunc(updatedSince: lastSync);

      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entityName: entityName,
              lastSyncedAt: Value(now),
              lastSyncStatus: const Value('completed'),
              lastSyncError: const Value(null),
            ),
          );
    } catch (e) {
      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entityName: entityName,
              lastSyncStatus: const Value('failed'),
              lastSyncError: Value(e.toString()),
            ),
          );
      rethrow;
    }
  }
}
