import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/reporting/domain/models/report_metadata.dart';
import 'package:mobile/features/reporting/presentation/providers/reporting_providers.dart';
import 'package:mobile/features/reporting/presentation/widgets/dynamic_filter_form.dart';

class DynamicReportViewerScreen extends ConsumerStatefulWidget {
  final String reportId;
  final String title;

  const DynamicReportViewerScreen({
    super.key,
    required this.reportId,
    required this.title,
  });

  @override
  ConsumerState<DynamicReportViewerScreen> createState() => _DynamicReportViewerScreenState();
}

class _DynamicReportViewerScreenState extends ConsumerState<DynamicReportViewerScreen> {
  ReportRequest _request = const ReportRequest(reportId: '');

  @override
  void initState() {
    super.initState();
    _request = ReportRequest(reportId: widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    final metadataAsync = ref.watch(reportMetadataProvider(widget.reportId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: 'حفظ نسخة غير متصلة',
            onPressed: () => _saveOffline(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleExport(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'EXCEL', child: Text('تصدير Excel')),
              const PopupMenuItem(value: 'PDF', child: Text('تصدير PDF')),
            ],
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: metadataAsync.when(
        data: (metadata) => _buildReportContent(metadata),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildReportContent(ReportDefinitionMetadata metadata) {
    final resultAsync = ref.watch(reportExecutionProvider(_request));

    return resultAsync.when(
      data: (result) => _buildTable(result),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ في جلب البيانات: $err')),
    );
  }

  Widget _buildTable(ReportResultDto result) {
    if (result.rows.isEmpty) {
      return const Center(child: Text('لا توجد بيانات مطابقة للفلاتر'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
          columns: result.columns
              .map((col) => DataColumn(
                    label: Text(
                      col,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          rows: result.rows
              .map((row) => DataRow(
                    cells: result.columns
                        .map((col) => DataCell(Text('${row[col] ?? "-"}')))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    final metadata = ref.read(reportMetadataProvider(widget.reportId)).asData?.value;
    if (metadata == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: DynamicFilterForm(
            metadata: metadata,
            onFiltersChanged: (filters) {
              setState(() {
                _request = _request.copyWith(filters: filters, pageIndex: 1);
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _saveOffline(BuildContext context) async {
    final result = ref.read(reportExecutionProvider(_request)).asData?.value;
    if (result == null) return;

    await ref.read(reportSnapshotDbProvider).saveSnapshot(
          reportId: widget.reportId,
          title: widget.title,
          filterSummary: 'Applied Filters',
          columns: result.columns,
          data: result.rows,
          summary: result.aggregates,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ نسخة من التقرير في الذاكرة المحلية بنجاح')),
    );
  }

  Future<void> _handleExport(String format) async {
    final client = ref.read(reportApiClientProvider);
    final exportRequest = _request.copyWith(exportFormat: format);

    try {
      if (format == 'EXCEL') {
        final bytes = await client.downloadExcel(exportRequest);
        // TODO: Save file and open
      } else {
        final bytes = await client.downloadPdf(exportRequest);
        // TODO: Save file and open
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم استخراج ملف $format بنجاح')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في التصدير: $e')),
      );
    }
  }
}
