import 'package:dio/dio.dart';
import 'package:mobile/features/reporting/domain/models/report_metadata.dart';

class ReportApiClient {
  final Dio _dio;

  ReportApiClient(this._dio);

  Future<ReportDefinitionMetadata> getMetadata(String reportId) async {
    final response = await _dio.get('/api/report/$reportId/metadata');
    return ReportDefinitionMetadata.fromJson(response.data);
  }

  Future<ReportResultDto> executeReport(ReportRequest request) async {
    final response = await _dio.post(
      '/api/report/execute',
      data: request.toJson(),
    );
    return ReportResultDto.fromJson(response.data);
  }

  Future<List<int>> downloadExcel(ReportRequest request) async {
    final response = await _dio.post(
      '/api/report/export/excel',
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data as List<int>;
  }

  Future<List<int>> downloadPdf(ReportRequest request) async {
    final response = await _dio.post(
      '/api/report/export/pdf',
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data as List<int>;
  }
}
