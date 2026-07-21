import 'package:dio/dio.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
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
        throw FarmerException(_errorsFromEnvelope(envelope));
      }

      final items = data['items'] as List;
      return items
          .map((e) => domain.Farmer.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw FarmerException(_errorsFromDio(e));
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
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(data);
    } on DioException catch (e) {
      throw FarmerException(_errorsFromDio(e));
    }
  }

  @override
  Stream<domain.Farmer?> watchFarmer(String id) {
    throw UnimplementedError('Remote repository does not support watching.');
  }

  @override
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    try {
      final payload = farmer.toJson();
      payload.remove('id'); // Remove local Drift ID from payload

      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/farmers',
        data: {
          ...payload,
          'clientId': farmer.id, // Ensure clientId is set to local UUID
        },
      );
      final envelope = response.data;
      final responseData = envelope?['data'];
      if (envelope?['succeeded'] != true || responseData == null) {
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(responseData);
    } on DioException catch (e) {
      throw FarmerException(_errorsFromDio(e));
    }
  }

  @override
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/farmers/${farmer.serverId ?? farmer.id}',
        data: {
          ...farmer.toJson(),
          'id': farmer.serverId ?? farmer.id,
          'clientId': farmer.id,
        },
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw FarmerException([
          'CONFLICT: The record has been modified by another user.',
        ]);
      }
      throw FarmerException(_errorsFromDio(e));
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
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
    } on DioException catch (e) {
      throw FarmerException(_errorsFromDio(e));
    }
  }

  List<String> _errorsFromDio(DioException e) {
    final body = e.response?.data;
    if (e.response?.statusCode == 400 && body is Map<String, dynamic>) {
      throw FarmerValidationException(_errorsFromEnvelope(body));
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
