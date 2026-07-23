import 'package:dio/dio.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/dto/damage_report_sync_dto.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';

class RemoteDamageReportRepository implements DamageReportRepository {
  final Dio _dio;

  RemoteDamageReportRepository(this._dio);

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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/damage-reports',
        data: DamageReportSyncDto.toCreateJson(report),
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
  Future<DamageItem> addDamageItem(DamageItem item) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/damage-reports/${item.damageReportId}/items',
        data: DamageReportSyncDto.itemToCreateJson(item)..addAll({
          'damageReportId': item.damageReportId,
        }),
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

  List<String> _errorsFromDio(DioException e) {
    final body = e.response?.data;
    if (e.response?.statusCode == 400 && body is Map<String, dynamic>) {
      throw SyncValidationException(_errorsFromEnvelope(body));
    }
    if (body is Map<String, dynamic>) {
      return _errorsFromEnvelope(body);
    }
    return const [];
  }

  List<String> _errorsFromEnvelope(Map<String, dynamic>? envelope) {
    final errors = envelope?['errors'];
    if (errors is List) {
      return errors.whereType<String>().toList();
    }
    return const [];
  }
}
