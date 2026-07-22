import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/farmers/domain/damage_report_attachment.dart';
import 'package:path/path.dart' as p_path;

abstract class DamageReportAttachmentRepository {
  Future<DamageReportAttachment> uploadAttachment(
    DamageReportAttachment attachment,
  );
  Future<void> deleteAttachment(String id);
  Future<List<DamageReportAttachment>> getAttachmentsByReport(String reportId);
}

class RemoteDamageReportAttachmentRepository
    implements DamageReportAttachmentRepository {
  final Dio _dio;

  RemoteDamageReportAttachmentRepository(this._dio);

  @override
  Future<DamageReportAttachment> uploadAttachment(
    DamageReportAttachment attachment,
  ) async {
    final file = File(attachment.localPath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p_path.basename(file.path),
      ),
      'clientId': attachment.id,
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/damage-reports/${attachment.damageReportId}/attachments',
        data: formData,
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageReportAttachment(
        id: data['clientId'],
        damageReportId: attachment.damageReportId,
        localPath: attachment.localPath,
        remotePath: data['remoteUrl'],
        uploadStatus: 'completed',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          throw SyncValidationException(_errorsFromEnvelope(body));
        }
      }
      throw SyncException(['Upload failed: $e']);
    } catch (e) {
      throw SyncException(['Upload failed: $e']);
    }
  }

  @override
  Future<void> deleteAttachment(String id) async {
    try {
      await _dio.delete('/v1/attachments/$id');
    } on DioException catch (e) {
      throw SyncException(['Delete failed: $e']);
    }
  }

  @override
  Future<List<DamageReportAttachment>> getAttachmentsByReport(
    String reportId,
  ) async {
    return [];
  }

  List<String> _errorsFromEnvelope(Map<String, dynamic>? envelope) {
    final errors = envelope?['errors'];
    if (errors is List) {
      return errors.whereType<String>().toList();
    }
    return const [];
  }
}
