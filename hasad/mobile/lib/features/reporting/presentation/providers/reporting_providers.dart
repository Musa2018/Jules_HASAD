import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/reporting/data/local/report_snapshot_db.dart';
import 'package:mobile/features/reporting/data/remote/report_api_client.dart';
import 'package:mobile/features/reporting/domain/models/report_metadata.dart';

final reportSnapshotDbProvider = Provider((ref) => LocalReportSnapshotDb.instance);

final reportApiClientProvider = Provider((ref) {
  final dio = ref.watch(apiDioProvider);
  return ReportApiClient(dio);
});

final reportMetadataProvider = FutureProvider.family<ReportDefinitionMetadata, String>((ref, reportId) async {
  final client = ref.watch(reportApiClientProvider);
  return await client.getMetadata(reportId);
});

final reportExecutionProvider = StateNotifierProvider.family<ReportExecutionNotifier, AsyncValue<ReportResultDto>, ReportRequest>((ref, request) {
  return ReportExecutionNotifier(ref.watch(reportApiClientProvider), request);
});

class ReportExecutionNotifier extends StateNotifier<AsyncValue<ReportResultDto>> {
  final ReportApiClient _client;
  final ReportRequest _request;

  ReportExecutionNotifier(this._client, this._request) : super(const AsyncValue.loading()) {
    execute();
  }

  Future<void> execute() async {
    state = const AsyncValue.loading();
    try {
      final result = await _client.executeReport(_request);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final savedSnapshotsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final db = ref.watch(reportSnapshotDbProvider);
  return await db.getSnapshots();
});
