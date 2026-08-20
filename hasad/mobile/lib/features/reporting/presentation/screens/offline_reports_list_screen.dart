import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/reporting/presentation/providers/reporting_providers.dart';
import 'dart:convert';

class OfflineReportsListScreen extends ConsumerWidget {
  const OfflineReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotsAsync = ref.watch(savedSnapshotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير المحفوظة'),
      ),
      body: snapshotsAsync.when(
        data: (snapshots) {
          if (snapshots.isEmpty) {
            return const Center(child: Text('لا توجد تقارير محفوظة حالياً'));
          }
          return ListView.builder(
            itemCount: snapshots.length,
            itemBuilder: (context, index) {
              final snapshot = snapshots[index];
              return ListTile(
                title: Text(snapshot['Title']),
                subtitle: Text('تاريخ الحفظ: ${snapshot['SavedAt']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ref.read(reportSnapshotDbProvider).deleteSnapshot(snapshot['SnapshotId']);
                    ref.invalidate(savedSnapshotsProvider);
                  },
                ),
                onTap: () => _viewSnapshot(context, snapshot),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  void _viewSnapshot(BuildContext context, Map<String, dynamic> snapshot) {
    final columns = List<String>.from(jsonDecode(snapshot['ColumnsJson']));
    final data = List<Map<String, dynamic>>.from(jsonDecode(snapshot['DataJson']));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfflineReportViewerScreen(
          title: snapshot['Title'],
          columns: columns,
          rows: data,
        ),
      ),
    );
  }
}

class OfflineReportViewerScreen extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<Map<String, dynamic>> rows;

  const OfflineReportViewerScreen({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
            columns: columns
                .map((col) => DataColumn(
                      label: Text(
                        col,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
            rows: rows
                .map((row) => DataRow(
                      cells: columns
                          .map((col) => DataCell(Text('${row[col] ?? "-"}')))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
