import 'package:drift/drift.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/data/damage_report_attachment_repository.dart';
import 'package:mobile/features/farmers/domain/damage_report_attachment.dart'
    as domain;
import 'package:uuid/uuid.dart';

class OfflineFirstDamageReportAttachmentRepository
    implements DamageReportAttachmentRepository {
  final AppDatabase _db;
  final BackgroundSyncService _syncService;

  OfflineFirstDamageReportAttachmentRepository(this._db, this._syncService);

  @override
  Future<domain.DamageReportAttachment> uploadAttachment(
    domain.DamageReportAttachment attachment,
  ) async {
    final localId = attachment.id.isEmpty ? const Uuid().v4() : attachment.id;

    await _db
        .into(_db.damageReportAttachments)
        .insert(
          _mapToCompanion(attachment).copyWith(
            id: Value(localId),
            uploadStatus: const Value('pending'),
            syncStatus: const Value('pending'),
          ),
        );

    final createdAttachment = attachment.copyWith(id: localId);

    await _syncService.addToQueue(
      localId: localId,
      entityType: 'attachment',
      operation: 'upload',
      data: createdAttachment.toJson(),
    );

    return createdAttachment;
  }

  @override
  Future<void> deleteAttachment(String id) async {
    final local = await (_db.select(_db.damageReportAttachments)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (local == null) return;

    await (_db.update(_db.damageReportAttachments)
          ..where((t) => t.id.equals(id)))
        .write(
      const DamageReportAttachmentsCompanion(
        isPendingDelete: Value(true),
        syncStatus: Value('pending'),
      ),
    );

    await _syncService.addToQueue(
      localId: id,
      entityType: 'attachment',
      operation: 'delete',
      data: {
        'id': local.serverId ?? local.id,
        'serverId': local.serverId,
        'clientId': local.id,
      },
    );
  }

  @override
  Future<List<domain.DamageReportAttachment>> getAttachmentsByReport(
    String reportId,
  ) async {
    final items = await (_db.select(
      _db.damageReportAttachments,
    )..where((t) => t.damageReportId.equals(reportId) & t.isPendingDelete.equals(false))).get();

    return items
        .map(
          (e) => domain.DamageReportAttachment(
            id: e.id,
            serverId: e.serverId,
            damageReportId: e.damageReportId,
            localPath: e.localPath,
            remotePath: e.remotePath,
            uploadStatus: e.uploadStatus,
            syncStatus: e.syncStatus,
            lastSyncError: e.lastSyncError,
          ),
        )
        .toList();
  }

  DamageReportAttachmentsCompanion _mapToCompanion(domain.DamageReportAttachment attachment) {
    return DamageReportAttachmentsCompanion.insert(
      id: attachment.id,
      serverId: Value(attachment.serverId),
      damageReportId: attachment.damageReportId,
      localPath: attachment.localPath,
      remotePath: Value(attachment.remotePath),
      uploadStatus: Value(attachment.uploadStatus),
      syncStatus: Value(attachment.syncStatus),
      lastSyncError: Value(attachment.lastSyncError),
    );
  }
}
