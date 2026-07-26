import 'package:dio/dio.dart';
import 'package:mobile/core/exceptions/sync_exceptions.dart';
import '../domain/lookup_entities.dart';
import '../domain/reference_data.dart';
import 'reference_data_repository.dart';

class RemoteReferenceDataRepository implements ReferenceDataRepository {
  final Dio _dio;

  RemoteReferenceDataRepository(this._dio);

  @override
  Future<ReferenceData> getReferenceData({bool forceRefresh = false}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/referencedata');
      final envelope = response.data;
      final data = envelope?['data'];
      
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      
      return ReferenceData.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<List<DamageNature>> getNatures() => throw UnimplementedError();

  @override
  Future<List<DamageAction>> getActions() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/referencedata/actions');
      final envelope = response.data;
      final data = envelope?['data'];
      
      if (envelope?['succeeded'] != true || data == null) {
        throw SyncException(_errorsFromEnvelope(envelope));
      }
      
      return (data as List)
          .map((e) => DamageAction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw SyncException(_errorsFromDio(e));
    }
  }

  @override
  Future<List<DamageCategory>> getCategories(int natureId) =>
      throw UnimplementedError();

  @override
  Future<List<DamageSubCategory>> getSubCategories(int categoryId) =>
      throw UnimplementedError();

  @override
  Future<List<DamageClassification>> getClassifications(int subCategoryId) =>
      throw UnimplementedError();

  @override
  Future<CostingSheetItem?> getActiveCostingSheet(int classificationId) =>
      throw UnimplementedError();

  @override
  Future<List<DamageClassification>> searchClassifications(String query) =>
      throw UnimplementedError();

  @override
  Future<List<DamageCauseCategory>> getDamageCauseCategories() =>
      throw UnimplementedError();

  @override
  Future<List<DamageCause>> getDamageCauses(int categoryId) =>
      throw UnimplementedError();

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
