import 'package:dio/dio.dart';
import 'package:mobile/features/admin/domain/directorate.dart';
import 'package:mobile/features/admin/domain/governorate.dart';
import 'package:mobile/features/admin/domain/role.dart';

class UsersException implements Exception {
  final List<String> errors;
  UsersException(this.errors);

  @override
  String toString() => errors.isEmpty ? 'User management operation failed.' : errors.join('\n');
}

abstract class UsersRepository {
  Future<List<Role>> getRoles();
  Future<List<Governorate>> getGovernorates();
  Future<List<Directorate>> getDirectorates({String? governorateId});
}

class UsersRepositoryImpl implements UsersRepository {
  final Dio _dio;

  UsersRepositoryImpl(this._dio);

  @override
  Future<List<Role>> getRoles() async {
    return _getMany('/v1/Users/roles', (json) => Role.fromJson(json));
  }

  @override
  Future<List<Governorate>> getGovernorates() async {
    return _getMany('/v1/Users/governorates', (json) => Governorate.fromJson(json));
  }

  @override
  Future<List<Directorate>> getDirectorates({String? governorateId}) async {
    return _getMany(
      '/v1/Users/directorates',
      (json) => Directorate.fromJson(json),
      queryParameters: governorateId != null ? {'governorateId': governorateId} : null,
    );
  }

  Future<List<T>> _getMany<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      final envelope = response.data;
      final data = envelope?['data'];

      if (envelope?['succeeded'] != true || data is! List) {
        throw UsersException(_errorsFromEnvelope(envelope));
      }

      return data.map((json) => fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw UsersException(_errorsFromDio(e));
    }
  }

  List<String> _errorsFromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return _errorsFromEnvelope(data);
    }
    return [];
  }

  List<String> _errorsFromEnvelope(Map<String, dynamic>? envelope) {
    final errors = envelope?['errors'];
    if (errors is List) {
      return errors.whereType<String>().toList();
    }
    return [];
  }
}
