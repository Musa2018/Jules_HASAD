import 'package:dio/dio.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/data/farm_sync_dtos.dart';
import 'package:mobile/features/farms/domain/farm.dart';

class RemoteFarmRepository implements FarmRepository {
  final Dio _dio;

  RemoteFarmRepository(this._dio);

  @override
  Future<List<Farm>> getFarmsByFarmer(String farmerId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/farms/farmer/$farmerId',
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      final items = data as List;
      return items
          .map((e) => Farm.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<Farm> getFarm(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/farms/$id');
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return Farm.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<Farm> createFarm(Farm farm, {AuthSession? session}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/farms',
        data: FarmSyncDto.toCreateJson(farm),
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return Farm.fromJson(data);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<Farm> updateFarm(Farm farm, {AuthSession? session}) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/farms/${farm.serverId ?? farm.id}',
        data: FarmSyncDto.toUpdateJson(farm),
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      return Farm.fromJson(data);
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
  Future<void> deleteFarm(String id, {AuthSession? session}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/v1/farms/$id');
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
