import 'package:dio/dio.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart' as domain;

class RemoteFarmerRepository implements FarmerRepository {
  final Dio _dio;

  RemoteFarmerRepository(this._dio);

  @override
  Future<List<domain.Farmer>> getFarmers({int pageNumber = 1, int pageSize = 10}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/farmers',
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
      
      final items = data['items'] as List;
      return items.map((e) => domain.Farmer.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw FarmerException(_errorsFromDio(e));
    }
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
  Future<domain.Farmer> createFarmer(domain.Farmer farmer) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/farmers',
        data: {
          'id': farmer.id, // Pass client-generated ID
          'name': farmer.name,
          'nationalId': farmer.nationalId,
          'phoneNumber': farmer.phoneNumber,
          'address': farmer.address,
        },
      );
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
  Future<domain.Farmer> updateFarmer(domain.Farmer farmer) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/v1/farmers/${farmer.id}',
        data: {
          'id': farmer.id,
          'name': farmer.name,
          'nationalId': farmer.nationalId,
          'phoneNumber': farmer.phoneNumber,
          'address': farmer.address,
          'rowVersion': farmer.rowVersion, // Pass version for concurrency check
        },
      );
      final envelope = response.data;
      final data = envelope?['data'];
      if (envelope?['succeeded'] != true || data == null) {
        throw FarmerException(_errorsFromEnvelope(envelope));
      }
      return domain.Farmer.fromJson(data);
    } on DioException catch (e) {
       // Check for 409 Conflict
      if (e.response?.statusCode == 409) {
        throw FarmerException(['CONFLICT: The record has been modified by another user.']);
      }
      throw FarmerException(_errorsFromDio(e));
    }
  }

  @override
  Future<void> deleteFarmer(String id) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/v1/farmers/$id');
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
