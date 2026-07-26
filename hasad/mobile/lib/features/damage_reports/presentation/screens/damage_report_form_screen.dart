import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart';
import 'package:mobile/l10n/app_localizations.dart';

class DamageReportFormScreen extends ConsumerStatefulWidget {
  final String reportId;

  const DamageReportFormScreen({super.key, required this.reportId});

  @override
  ConsumerState<DamageReportFormScreen> createState() =>
      _DamageReportFormScreenState();
}

class _DamageReportFormScreenState
    extends ConsumerState<DamageReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(damageReportStreamProvider(widget.reportId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editAssessment),
      ),
      body: reportAsync.when(
        data: (report) {
          if (report == null) return Center(child: Text(l10n.noData));
          return Column(
            children: [
              Expanded(child: _buildAssessmentBody(report, l10n)),
              if (_canEdit(report))
                FormSaveFooter(
                  label: l10n.submitForReview,
                  onSave: report.items.isEmpty ? null : () => _confirmSubmit(report),
                  isLoading: ref.watch(damageReportFormProvider).isLoading,
                  isValid: report.items.isNotEmpty,
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  bool _canEdit(DamageReport report) {
     return report.statusId == DamageReportStatus.pendingTechnicalVerification ||
            report.statusId == DamageReportStatus.draft;
  }

  Widget _buildAssessmentBody(DamageReport report, AppLocalizations l10n) {
    final isReadOnly = !_canEdit(report);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReportNumberHeader(report, l10n),
            const SizedBox(height: 24),
            _buildHeaderSummary(report, l10n),
            const Divider(height: 48),
            _buildItemsHeader(report, isReadOnly, l10n),
            const SizedBox(height: 8),
            if (report.items.isEmpty)
               Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(l10n.noData)))
            else
              ...report.items.map((item) => _buildItemTile(item, report, isReadOnly, l10n)),
            const SizedBox(height: 24),
            _buildValuationSummary(report, l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSummary(DamageReport report, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.incidentDetails, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSummaryRow(l10n.dateOfBirth, DateFormat.yMMMd().format(report.damageDate)),
            _buildSummaryRow(l10n.agriculturalSector, report.agriculturalSectorId.toString()),
            _buildSummaryRow(l10n.damageCause, report.damageCauseId.toString()),
            if (report.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('${l10n.notes}: ${report.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildReportNumberHeader(DamageReport report, AppLocalizations l10n) {
    final number = report.reportNumber.isNotEmpty ? report.reportNumber : 
                   (report.permanentFormNumber.isNotEmpty ? report.permanentFormNumber : report.temporaryFormNumber);
    
    Color statusColor = Colors.grey;
    String statusLabel = report.syncStatus;
    
    switch (report.syncStatus) {
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = l10n.pendingSync;
        break;
      case 'syncing':
        statusColor = Colors.blue;
        statusLabel = l10n.syncing;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusLabel = l10n.synced;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusLabel = l10n.syncError;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(l10n.reportNumber, style: TextStyle(fontSize: 12, color: statusColor)),
          Text(number, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: statusColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${l10n.status}: ${_getStatusLabel(context, report.statusId)}', style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 8),
              Container(width: 1, height: 10, color: Colors.grey),
              const SizedBox(width: 8),
              Text(statusLabel, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
            ],
          ),
          if (report.syncStatus == 'failed' || report.syncStatus == 'conflict')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(l10n.retrySync),
                onPressed: () {
                   // This would typically trigger a manual sync or mark for retry
                   // For now, we rely on BackgroundSyncService background processing
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Sync will be retried automatically when online.')),
                   );
                },
              ),
            ),
          if (report.lastSyncError != null && report.syncStatus != 'completed')
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                report.lastSyncError!,
                style: const TextStyle(fontSize: 10, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsHeader(DamageReport report, bool isReadOnly, AppLocalizations l10n) {
    final canAddItems = report.syncStatus == 'completed';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.damageReports,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!canAddItems && !isReadOnly)
                Text(
                  l10n.awaitingSyncToEnableItems,
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
            ],
          ),
        ),
        if (!isReadOnly && canAddItems)
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => _addItem(report),
          ),
      ],
    );
  }

  Widget _buildItemTile(DamageItem item, DamageReport report, bool isReadOnly, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.measurementUnitSnapshot),
        subtitle: Text('${l10n.quantity}: ${item.quantity}, ${l10n.technicalLoss}: ${item.estimatedLoss} EUR'),
        trailing: !isReadOnly ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _addItem(report, existingItem: item),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteItem(item.id),
            ),
          ],
        ) : null,
      ),
    );
  }

  Widget _buildValuationSummary(DamageReport report, AppLocalizations l10n) {
    final total = report.items.fold(0.0, (sum, i) => sum + i.estimatedLoss);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l10n.totalTechnicalValuation, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '${total.toStringAsFixed(2)} EUR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _addItem(DamageReport report, {DamageItem? existingItem}) async {
    final lockedNatureId =
        report.items.isNotEmpty ? report.items.first.damageNatureId : null;

    final result = await showModalBottomSheet<DamageItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DamageItemFormSheet(
        reportId: report.id,
        sectorId: report.agriculturalSectorId,
        existingItem: existingItem,
        lockedNatureId: lockedNatureId,
      ),
    );

    if (result != null) {
      if (existingItem != null) {
        await ref
            .read(damageReportFormProvider.notifier)
            .updateDamageItem(result);
      } else {
        await ref.read(damageReportFormProvider.notifier).addDamageItem(result);
      }
    }
  }

  Future<void> _deleteItem(String itemId) async {
    await ref.read(damageReportFormProvider.notifier).deleteDamageItem(itemId);
  }

  void _confirmSubmit(DamageReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text(
            'Are you sure you want to submit this assessment? It will become read-only.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(damageReportFormProvider.notifier).submitReport(report.id);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(BuildContext context, String statusId) {
    final l10n = AppLocalizations.of(context)!;
    switch (statusId) {
      case 'Draft':
        return l10n.status_Draft;
      case 'TechReview':
        return l10n.status_TechReview;
      case 'Completed':
        return l10n.status_Completed;
      default:
        return statusId;
    }
  }
}

