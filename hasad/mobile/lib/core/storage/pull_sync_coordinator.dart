import 'package:drift/drift.dart';
import 'package:mobile/core/storage/database.dart';

class PullSyncCoordinator {
  final AppDatabase _db;

  PullSyncCoordinator(this._db);

  Future<void> synchronizeEntity(
    String entityName,
    Future<void> Function({DateTime? updatedSince}) syncFunc,
  ) async {
    final metadata = await (_db.select(_db.syncMetadata)
          ..where((t) => t.entity.equals(entityName)))
        .getSingleOrNull();

    final lastSync = metadata?.lastSyncedAt;
    final now = DateTime.now();

    try {
      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entity: entityName,
              lastSyncStatus: const Value('syncing'),
            ),
          );

      await syncFunc(updatedSince: lastSync);

      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entity: entityName,
              lastSyncedAt: Value(now),
              lastSyncStatus: const Value('completed'),
              lastSyncError: const Value(null),
            ),
          );
    } catch (e) {
      await _db.into(_db.syncMetadata).insertOnConflictUpdate(
            SyncMetadataCompanion.insert(
              entity: entityName,
              lastSyncStatus: const Value('failed'),
              lastSyncError: Value(e.toString()),
            ),
          );
      rethrow;
    }
  }
}
