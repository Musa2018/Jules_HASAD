import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
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
          
          final isReady = report.isReadyForReview;
          final canEdit = _canEdit(report);

          return Column(
            children: [
              Expanded(child: _buildAssessmentBody(report, l10n)),
              if (canEdit)
                FormSaveFooter(
                  label: isReady ? l10n.submitForReview : l10n.saveLocallyAndSync,
                  onSave: (report.hasItems) ? (isReady ? () => _confirmSubmit(report) : () => _saveAssessmentProgress(context)) : null,
                  isLoading: ref.watch(damageReportFormProvider).isLoading,
                  isValid: report.hasItems,
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _saveAssessmentProgress(BuildContext context) {
    // Items are already saved and synced individually in this architecture.
    // This button just provides feedback and perhaps returns to the list.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assessment progress saved. Items will sync in the background.')),
    );
    context.pop(); // Go back to the list
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
    final refDataAsync = ref.watch(referenceDataProvider);
    final farmAsync = ref.watch(farmStreamProvider(report.farmId));
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.incidentDetails, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildSummaryRow(l10n.damageDate, report.damageDate != null ? DateFormat.yMMMd().format(report.damageDate!) : '...'),
            
            // Resolve Agricultural Sector from Farm + Reference Data
            farmAsync.when(
              data: (farm) {
                if (farm == null) return _buildSummaryRow(l10n.agriculturalSector, '...');
                
                return refDataAsync.when(
                  data: (refData) {
                    final sector = refData.agriculturalSectors
                        .where((s) => s.id == farm.agriculturalSectorId)
                        .firstOrNull;
                    final sectorName = sector != null 
                        ? (isAr ? sector.nameAr : sector.nameEn) 
                        : farm.agriculturalSectorId.toString();
                    return _buildSummaryRow(l10n.agriculturalSector, sectorName);
                  },
                  loading: () => _buildSummaryRow(l10n.agriculturalSector, '...'),
                  error: (_, _) => _buildSummaryRow(l10n.agriculturalSector, 'Error'),
                );
              },
              loading: () => _buildSummaryRow(l10n.agriculturalSector, '...'),
              error: (_, _) => _buildSummaryRow(l10n.agriculturalSector, 'Error'),
            ),

            // Resolve Damage Cause from Reference Data
            refDataAsync.when(
              data: (data) {
                final cause = data.damageCauses
                    .where((c) => c.id == report.damageCauseId)
                    .firstOrNull;
                final causeName = cause != null
                    ? (isAr ? cause.nameAr : cause.nameEn)
                    : report.damageCauseId.toString();

                return _buildSummaryRow(l10n.damageCause, causeName);
              },
              loading: () => _buildSummaryRow(l10n.damageCause, '...'),
              error: (err, _) => _buildSummaryRow(l10n.damageCause, 'Error'),
            ),
            
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
                   (report.temporaryFormNumber.isNotEmpty ? report.temporaryFormNumber : report.id.substring(0, 8));
    
    Color statusColor = _getWorkflowColor(report);
    String statusLabel = _getWorkflowLabel(context, report.workflowStateKey);

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
    final canAddItems = report.isHeaderSynced;
    
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(damageReportFormProvider.notifier)
                  .submitReport(report.id);

              if (success && context.mounted) {
                // Fetch the farm to pass it back to the list screen
                final farm = await ref.read(farmStreamProvider(report.farmId).future);
                if (context.mounted) {
                  context.go(AppRoutes.damageReports, extra: farm);
                }
              }
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

  String _getWorkflowLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'status_TechReview':
        return l10n.status_TechReview;
      case 'status_Completed':
        return l10n.status_Completed;
      case 'workflowState_DraftHeader':
        return l10n.workflowState_DraftHeader;
      case 'workflowState_HeaderSynced':
        return l10n.workflowState_HeaderSynced;
      case 'workflowState_HeaderSyncFailed':
        return l10n.workflowState_HeaderSyncFailed;
      case 'workflowState_AssessmentInProgress':
        return l10n.workflowState_AssessmentInProgress;
      case 'workflowState_AssessmentPendingSync':
        return l10n.workflowState_AssessmentPendingSync;
      case 'workflowState_ReadyForReview':
        return l10n.workflowState_ReadyForReview;
      default:
        return key;
    }
  }

  Color _getWorkflowColor(DamageReport report) {
    if (report.statusId == 'Submitted' ||
        report.statusId == DamageReportStatus.techReview) {
      return Colors.blue;
    }
    if (report.statusId == DamageReportStatus.completed) return Colors.green;
    if (!report.isHeaderSynced) return Colors.orange;
    if (report.isReadyForReview) return Colors.teal;
    return Colors.grey[700]!;
  }
}

