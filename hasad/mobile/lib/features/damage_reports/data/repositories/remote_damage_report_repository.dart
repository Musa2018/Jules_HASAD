import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/dto/damage_report_sync_dto.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_workflow_history.dart' as domain_history;

class RemoteDamageReportRepository implements DamageReportRepository {
  final Dio _dio;

  RemoteDamageReportRepository(this._dio);

  @override
  Future<List<DamageReport>> getDamageReports() async {
    return []; // Headless global listing is not supported by backend
  }

  @override
  Stream<List<DamageReport>> watchDamageReports() {
    return Stream.fromFuture(getDamageReports());
  }

  @override
  Future<List<DamageReport>> getDamageReportsByFarm(String farmId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/damage-reports/farm/$farmId',
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      final items = data as List;
      return items
          .map((e) => DamageReport.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Stream<List<DamageReport>> watchDamageReportsByFarm(String farmId) {
    return Stream.fromFuture(getDamageReportsByFarm(farmId));
  }

  @override
  Future<DamageReport> getDamageReport(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/damage-reports/$id',
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageReport.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<DamageReport> createDamageReport(DamageReport report) async {
    return createDamageReportFromJson(DamageReportSyncDto.toCreateJson(report));
  }

  @override
  Future<DamageReport> createDamageReportFromJson(Map<String, dynamic> json) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/damage-reports',
        data: json,
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageReport.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<DamageReport> updateDamageReport(DamageReport report) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/damage-reports/${report.id}',
        data: DamageReportSyncDto.toUpdateJson(report),
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageReport.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw SyncConflictException([
          'CONFLICT: The record has been modified by another user.',
        ]);
      }
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> deleteDamageReport(String id) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/v1/damage-reports/$id',
      );
      if (response.data?['succeeded'] != true) {
        throw SyncException(_errorsFromEnvelope(response.data));
      }
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> cancelDeleteDamageReport(String id) async {
    // Local-only operation
  }

  @override
  Future<void> submitReport(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        "/v1/damage-reports/$id/submit",
      );
      final envelope = response.data;
      if (envelope == null || envelope["succeeded"] != true) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> transitionReport(String id, String toStatus,
      {String? comment, bool isOverride = false}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        "/v1/damage-reports/$id/transition",
        data: {
          'id': id,
          'toStatus': toStatus,
          'comment': comment,
          'isOverride': isOverride,
        },
      );
      final envelope = response.data;
      if (envelope == null || envelope["succeeded"] != true) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<List<domain_history.DamageWorkflowHistory>> getReportHistory(
      String id) async {
    try {
      final response = await _dio.get(
        "/v1/damage-reports/$id/history",
      );
      
      final dynamic responseData = response.data;
      final Map<String, dynamic> envelope;
      
      if (responseData is List) {
        // Backend returned a raw list instead of a Result envelope
        envelope = {'succeeded': true, 'data': responseData};
      } else if (responseData is Map<String, dynamic>) {
        envelope = responseData;
      } else {
        throw SyncException(['استجابة غير متوقعة من السيرفر']);
      }

      final data = envelope['data'];
      if (envelope['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }

      final items = data as List;
      return items.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        
        // DTO Alignment: Ensure required strings have defaults if null 
        // to prevent parsing crash while respecting nullable comment.
        return domain_history.DamageWorkflowHistory(
          id: '', // Local ID assigned during persistence
          serverId: map['id']?.toString() ?? map['serverId']?.toString(),
          fromStatus: map['fromStatus']?.toString() ?? '',
          toStatus: map['toStatus']?.toString() ?? '',
          changedByUserId: map['changedByUserId']?.toString() ?? '',
          changedByUserName: map['changedByUserName']?.toString() ?? '',
          changedAt: map['changedAt'] != null ? DateTime.parse(map['changedAt'].toString()) : null,
          comment: map['comment']?.toString(),
          isOverride: map['isOverride'] == true,
        );
      }).toList();
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Stream<List<domain_history.DamageWorkflowHistory>> watchReportHistory(
      String id) {
    return Stream.fromFuture(getReportHistory(id));
  }

  @override
  Future<void> syncWorkflowHistory(String localId, String serverId) async {
    // Remote-only repository doesn't persist locally.
    await getReportHistory(serverId);
  }

  @override
  Future<DamageItem> addDamageItem(DamageItem item) async {
    try {
      final payload = DamageReportSyncDto.itemToCreateJson(item);
      
      // Ensure DamageReportId is present and matches the URL parameter
      // The backend AddDamageItemCommand expects 'DamageReportId' or 'damageReportId'
      payload['damageReportId'] = item.damageReportId;

      if (kDebugMode) {
        debugPrint('--- ADD DAMAGE ITEM PAYLOAD ---');
        debugPrint('URL ID: ${item.damageReportId}');
        debugPrint('Payload: $payload');
        debugPrint('-------------------------------');
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/damage-reports/${item.damageReportId}/items',
        data: payload,
      );
      final envelope = response.data;
      final data = envelope?['data'];

      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageItem.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<DamageItem> updateDamageItem(DamageItem item) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/damage-reports/items/${item.id}',
        data: DamageReportSyncDto.itemToUpdateJson(item),
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return DamageItem.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw SyncConflictException([
          'CONFLICT: The record has been modified by another user.',
        ]);
      }
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> deleteDamageItem(String id) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/v1/damage-reports/items/$id',
      );
      if (response.data?['succeeded'] != true) {
        throw SyncException(_errorsFromEnvelope(response.data));
      }
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> retrySync(String id) async {
    // Remote-only repo doesn't have a queue
  }

  @override
  Future<void> retryAllFailedSyncs() async {
    // Remote-only repo doesn't have a queue
  }

  @override
  Future<void> synchronize({DateTime? updatedSince}) async {
    // Remote repository is always "in sync" with itself.
  }

  @override
  Future<void> refreshReport(String id) async {
    await getDamageReport(id);
  }

  List<String> _errorsFromDio(DioException e) {
    final body = e.response?.data;
    
    if (kDebugMode && e.response != null) {
      debugPrint('--- API ERROR LOG ---');
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('Path: ${e.requestOptions.path}');
      debugPrint('Method: ${e.requestOptions.method}');
      debugPrint('Response Data: ${e.response?.data}');
      
      // Explicitly log validation errors if present
      if (body is Map<String, dynamic> && body.containsKey('errors')) {
        debugPrint('Validation Errors: ${body['errors']}');
      }
      debugPrint('---------------------');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ['انتهت مهلة الاتصال بالسيرفر. يرجى التأكد من جودة الإنترنت.'];
    }

    if (e.type == DioExceptionType.connectionError) {
      return ['فشل الاتصال بالسيرفر. يرجى التأكد من أنك متصل بالإنترنت.'];
    }

    if (e.response?.statusCode == 404) {
      throw SyncNotFoundException(['السجل غير موجود على السيرفر (404).']);
    }
    
    if (e.response?.statusCode == 400 && body is Map<String, dynamic>) {
      final errors = _errorsFromEnvelope(body);
      if (errors.isNotEmpty) {
        throw SyncValidationException(errors);
      }
      final message = body['message'] ?? body['title'] ?? 'طلب غير صحيح (400)';
      throw SyncValidationException([message.toString()]);
    }

    if (e.response?.statusCode == 409 && body is Map<String, dynamic>) {
      final code = body['code'] as String?;
      final errors = _errorsFromEnvelope(body);
      throw SyncConflictException(
        errors.isNotEmpty ? errors : ['تنبيه: تم تعديل السجل من قبل مستخدم آخر (تعارض 409).'],
        code: code,
      );
    }

    if (e.response?.statusCode == 500) {
      return ['خطأ داخلي في السيرفر (500). يرجى المحاولة لاحقاً.'];
    }

    if (body is Map<String, dynamic>) {
      final errors = _errorsFromEnvelope(body);
      if (errors.isNotEmpty) return errors;
    }

    // Fallback: Return the underlying Dio error message if nothing else is found
    final fallbackMessage = e.message ?? e.toString();
    return [fallbackMessage.isNotEmpty ? fallbackMessage : 'حدث خطأ غير متوقع أثناء الاتصال.'];
  }

  List<String> _errorsFromEnvelope(Map<String, dynamic>? envelope) {
    final errors = envelope?['errors'];
    if (errors is List) {
      return errors.whereType<String>().toList();
    }
    return const [];
  }
}
