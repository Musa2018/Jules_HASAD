import 'package:dio/dio.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/core/utils/debug_logger.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/data/farmer_sync_dtos.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;

class RemoteFarmerRepository implements FarmerRepository {
  final Dio _dio;

  RemoteFarmerRepository(this._dio);

  @override
  Future<List<domain.Farmer>> getFarmers({
    int pageNumber = 1,
    int pageSize = 10,
    String? idNumber,
    String? name,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/farmers',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'idNumber': idNumber,
          'name': name,
        },
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }

      final items = data['items'] as List;
      return items
          .map((e) => domain.Farmer.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<domain.Farmer?> findByIdNumber(String idNumber) async {
    final results = await getFarmers(idNumber: idNumber, pageSize: 1);
    return results.isEmpty ? null : results.first;
  }

  @override
  Future<domain.Farmer> getFarmer(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/farmers/$id');
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Stream<domain.Farmer?> watchFarmer(String id) {
    throw UnimplementedError('Remote repository does not support watching.');
  }

  @override
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    try {
      final fullPayload = FarmerSyncDto.toCreateJson(farmer);

      if (DebugLogger.enableSyncDebug) {
        DebugLogger.logHeader('FARMER CREATE PAYLOAD');
        DebugLogger.logJson(fullPayload);
        DebugLogger.logFooter();
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/farmers',
        data: fullPayload,
      );
      final envelope = response.data;
      final responseData = envelope?['data'];
      if (envelope?['succeeded'] != true || responseData == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(responseData);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer) async {
    if (farmer.rowVersion.isEmpty) {
      throw SyncException(['RowVersion is required for updates.']);
    }

    try {
      final fullPayload = FarmerSyncDto.toUpdateJson(farmer);

      if (DebugLogger.enableSyncDebug) {
        DebugLogger.logHeader('FARMER UPDATE PAYLOAD');
        DebugLogger.logJson(fullPayload);
        DebugLogger.logFooter();
      }

      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/farmers/${farmer.serverId ?? farmer.id}',
        data: fullPayload,
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(data);
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
  Future<void> deleteFarmer(String id) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/v1/farmers/$id',
      );
      final envelope = response.data;
      if (envelope?['succeeded'] != true) {
        throw SyncException(_errorsFromEnvelope(envelope));
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
