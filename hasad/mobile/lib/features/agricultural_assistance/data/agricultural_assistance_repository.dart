import 'package:dio/dio.dart';
import 'package:mobile/features/agricultural_assistance/domain/agricultural_assistance.dart';

abstract class AgriculturalAssistanceRepository {
  Future<AgriculturalAssistance?> getByReportId(String reportId);
  Future<AgriculturalAssistance> create(String reportId, String remarks);
  Future<AgriculturalAssistance> recalculate(String id, String rowVersion);
  Future<AgriculturalAssistance> submit(String id, String rowVersion);
  Future<AgriculturalAssistance> approve(
    String id,
    double amount,
    String remarks,
    String rowVersion,
  );
  Future<AgriculturalAssistance> reject(String id, String remarks, String rowVersion);
  Future<AgriculturalAssistance> markAsPaid(String id, String remarks, String rowVersion);
}

class AgriculturalAssistanceRepositoryImpl implements AgriculturalAssistanceRepository {
  final Dio _dio;

  AgriculturalAssistanceRepositoryImpl(this._dio);

  @override
  Future<AgriculturalAssistance?> getByReportId(String reportId) async {
    final response = await _dio.get('/v1/assistances/report/$reportId');
    if (response.data == null || response.data['data'] == null) {
      return null;
    }
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> create(String reportId, String remarks) async {
    final response = await _dio.post(
      '/v1/assistances',
      data: {
        'clientId': DateTime.now().toIso8601String(),
        'damageReportId': reportId,
        'remarks': remarks,
      },
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> recalculate(String id, String rowVersion) async {
    final response = await _dio.post(
      '/v1/assistances/$id/recalculate',
      data: {'id': id, 'rowVersion': rowVersion},
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> submit(String id, String rowVersion) async {
    final response = await _dio.post(
      '/v1/assistances/$id/submit',
      data: {'id': id, 'rowVersion': rowVersion},
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> approve(
    String id,
    double amount,
    String remarks,
    String rowVersion,
  ) async {
    final response = await _dio.post(
      '/v1/assistances/$id/approve',
      data: {
        'id': id,
        'approvedAmount': amount,
        'remarks': remarks,
        'rowVersion': rowVersion,
      },
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> reject(
    String id,
    String remarks,
    String rowVersion,
  ) async {
    final response = await _dio.post(
      '/v1/assistances/$id/reject',
      data: {'id': id, 'remarks': remarks, 'rowVersion': rowVersion},
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }

  @override
  Future<AgriculturalAssistance> markAsPaid(
    String id,
    String remarks,
    String rowVersion,
  ) async {
    final response = await _dio.post(
      '/v1/assistances/$id/pay',
      data: {'id': id, 'remarks': remarks, 'rowVersion': rowVersion},
    );
    return AgriculturalAssistance.fromJson(response.data['data']);
  }
}
