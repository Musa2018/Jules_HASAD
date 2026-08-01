import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_sync_status_badge.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class DamageReportCard extends ConsumerWidget {
  final DamageReport report;

  const DamageReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final dateFormat = DateFormat.yMd(locale);
    final authService = ref.watch(authorizationServiceProvider);

    // Lookups
    final farmAsync = ref.watch(farmStreamProvider(report.farmId));
    final farmerAsync = ref.watch(farmerStreamProvider(report.farmerId));
    final refDataAsync = ref.watch(referenceDataProvider);
    
    // Location lookups based on report data (snapshots)
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(report.governorateId));
    final locAsync = ref.watch(localitiesProvider((report.governorateId, report.directorateId)));

    String locationText = report.localityId;
    govAsync.whenData((govs) {
      final gov = govs.where((g) => g.id == report.governorateId).firstOrNull;
      if (gov != null) {
        dirAsync.whenData((dirs) {
          final dir = dirs.where((d) => d.id == report.directorateId).firstOrNull;
          if (dir != null) {
            locAsync.whenData((locs) {
              final loc = locs.where((l) => l.id == report.localityId).firstOrNull;
              if (loc != null) {
                locationText = "${isAr ? gov.nameAr : gov.nameEn} / ${isAr ? dir.nameAr : dir.nameEn} / ${isAr ? loc.nameAr : loc.nameEn}";
              }
            });
          }
        });
      }
    });

    String causeText = report.damageCauseId.toString();
    refDataAsync.whenData((data) {
      final cause = data.damageCauses.where((c) => c.id == report.damageCauseId).firstOrNull;
      if (cause != null) causeText = isAr ? cause.nameAr : cause.nameEn;
    });

    final title = report.reportNumber.isNotEmpty 
        ? report.reportNumber 
        : (report.temporaryFormNumber.isNotEmpty ? report.temporaryFormNumber : report.id.substring(0, 8));

    final workflowLabel = _getWorkflowLabel(context, report.workflowStateKey);

    return Opacity(
      opacity: report.isDeleted == true ? 0.6 : 1.0,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => context.push(AppRoutes.damageReportDetails, extra: {
            'report': report,
            'farm': farmAsync.value,
          }),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: report.isDeleted == true ? TextDecoration.lineThrough : null,
                                ),
                          ),
                          Text(
                            workflowLabel,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getWorkflowColor(report),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FarmerSyncStatusBadge(
                      status: report.isDeleted == true ? 'pending_delete' : report.syncStatus,
                    ),
                  ],
                ),
                if (report.lastSyncError != null && report.syncStatus == 'failed')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${l10n.syncError}: ${report.lastSyncError}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Divider(height: 24),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: l10n.farmerName,
                  value: farmerAsync.when(
                    data: (f) => f?.fullName ?? report.farmerId,
                    loading: () => "...",
                    error: (_, _) => report.farmerId,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.agriculture_outlined,
                  label: l10n.farm,
                  value: farmAsync.when(
                    data: (f) => f?.localFarmName ?? report.farmId,
                    loading: () => "...",
                    error: (_, _) => report.farmId,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: l10n.damageDate,
                        value: dateFormat.format(report.damageDate),
                      ),
                    ),
                    Expanded(
                      child: _StatusBadge(statusId: report.statusId),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.report_problem_outlined,
                  label: l10n.damageCause,
                  value: causeText,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: l10n.locationSection,
                  value: locationText,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (report.isDeleted != true) ...[
                      if (_canAddItems(report))
                        TextButton.icon(
                          onPressed: () => context.push(AppRoutes.editDamageReport, extra: report.id),
                          icon: Icon(
                            report.hasItems ? Icons.edit_note : Icons.add_circle_outline,
                            size: 18,
                          ),
                          label: Text(report.hasItems ? l10n.editAssessment : l10n.addAssessmentItem),
                        )
                      else if (!report.isHeaderSynced)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            l10n.awaitingSyncToAddItems,
                            style: TextStyle(color: Colors.orange[800], fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () => context.push(AppRoutes.damageReportDetails, extra: {
                          'report': report,
                          'farm': farmAsync.value,
                        }),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(l10n.details),
                      ),
                      if (_canDelete(report, authService))
                        TextButton.icon(
                          onPressed: () => _confirmDelete(context, ref),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: Text(l10n.delete),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                        ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: () => ref.read(damageReportRepositoryProvider).cancelDeleteDamageReport(report.id),
                        icon: const Icon(Icons.undo),
                        label: Text(l10n.cancelDelete),
                      ),
                      if (report.syncStatus == 'failed')
                        TextButton.icon(
                          onPressed: () => ref.read(damageReportFormProvider.notifier).deleteDamageReport(report.id),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retry),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getWorkflowLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'status_TechReview': return l10n.status_TechReview;
      case 'status_Completed': return l10n.status_Completed;
      case 'workflowState_DraftHeader': return l10n.workflowState_DraftHeader;
      case 'workflowState_HeaderSynced': return l10n.workflowState_HeaderSynced;
      case 'workflowState_HeaderSyncFailed': return l10n.workflowState_HeaderSyncFailed;
      case 'workflowState_AssessmentInProgress': return l10n.workflowState_AssessmentInProgress;
      case 'workflowState_AssessmentPendingSync': return l10n.workflowState_AssessmentPendingSync;
      case 'workflowState_ReadyForReview': return l10n.workflowState_ReadyForReview;
      default: return key;
    }
  }

  Color _getWorkflowColor(DamageReport report) {
    if (report.statusId == 'Submitted' || report.statusId == DamageReportStatus.techReview) return Colors.blue;
    if (report.statusId == DamageReportStatus.completed) return Colors.green;
    if (!report.isHeaderSynced) return Colors.orange;
    if (report.isReadyForReview) return Colors.teal;
    return Colors.grey[700]!;
  }

  bool _canAddItems(DamageReport report) {
    // Phase 2 requirement: Header must be synchronized (have serverId and official report number)
    return report.isHeaderSynced && 
           (report.statusId == DamageReportStatus.draft || 
            report.statusId == DamageReportStatus.pendingTechnicalVerification);
  }

  bool _canDelete(DamageReport report, AuthorizationService auth) {
    // Only allow deletion of drafts or pending reports by authorized users
    return (report.statusId == DamageReportStatus.draft || 
            report.statusId == DamageReportStatus.pendingTechnicalVerification) &&
           auth.canManageFarmers(); // Reusing farmer management permission for now as a proxy for survey management
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(damageReportFormProvider.notifier).deleteDamageReport(report.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String statusId;
  const _StatusBadge({required this.statusId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label = statusId;
    Color color = Colors.grey;

    switch (statusId) {
      case 'Draft':
        label = l10n.status_Draft;
        color = Colors.grey;
        break;
      case 'TechReview':
      case 'MinTechReview':
      case 'Submitted':
        label = l10n.status_TechReview;
        color = Colors.blue;
        break;
      case 'Completed':
      case 'Approved':
        label = l10n.status_Completed;
        color = Colors.green;
        break;
      default:
        // Try to use the helper if available or just show statusId
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
