# HASAD - Synchronization Documentation

## Strategy
Offline-first synchronization with a background queue.

## Components
- **SyncQueue**: Local database table tracking pending changes.
- **SyncStatus**: Pending, Syncing, Completed, Failed, Conflict, Invalid.
- **BackgroundService**: Native-compatible background worker to push updates.

## Sync Rules
- **Idempotent Delete**: DELETE operations returning `404 Not Found` are treated as successful if a `serverId` was provided, enabling local cleanup of records already removed from the server.
- **Reactive Filtering**: All `watch` streams must filter out records where `isPendingDelete == true` to ensure immediate UI responsiveness during background deletion.
- **Operation Collapsing**: `CREATE` + `UPDATE` collapses to `CREATE`. `CREATE` + `DELETE` collapses to a local `hardDelete`.

## Conflict Resolution
- Most reports use **Last-Write-Wins**.
- Ownership changes require **Manual Resolution**.
