import 'package:dio/dio.dart';
import 'package:mobile/features/farmers/domain/compensation.dart';

abstract class CompensationRepository {
  Future<Compensation?> getByReportId(String reportId);
  Future<Compensation> create(String reportId, String remarks);
  Future<Compensation> update(Compensation compensation);
}

class CompensationRepositoryImpl implements CompensationRepository {
  final Dio _dio;

  CompensationRepositoryImpl(this._dio);

  @override
  Future<Compensation?> getByReportId(String reportId) async {
    final response = await _dio.get('/v1/compensations/report/$reportId');
    if (response.data == null || response.data['data'] == null) {
      return null;
    }
    return Compensation.fromJson(response.data['data']);
  }

  @override
  Future<Compensation> create(String reportId, String remarks) async {
    final response = await _dio.post(
      '/v1/compensations',
      data: {
        'clientId': DateTime.now().toIso8601String(), // Simple clientId for now
        'damageReportId': reportId,
        'remarks': remarks,
      },
    );
    return Compensation.fromJson(response.data['data']);
  }

  @override
  Future<Compensation> update(Compensation compensation) async {
    final response = await _dio.put(
      '/v1/compensations/${compensation.id}',
      data: {
        'id': compensation.id,
        'approvedAmount': compensation.approvedAmount,
        'status': compensation.status,
        'remarks': compensation.remarks,
        'rowVersion': compensation.rowVersion,
      },
    );
    return Compensation.fromJson(response.data['data']);
  }
}
