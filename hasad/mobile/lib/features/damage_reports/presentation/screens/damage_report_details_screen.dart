import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:intl/intl.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'package:mobile/features/damage_reports/presentation/widgets/attachment_form_sheet.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_attachment.dart';

String _getStatusLabel(BuildContext context, String? status) {
  if (status == null || status.isEmpty) return '...';
  final l10n = AppLocalizations.of(context)!;
  switch (status) {
    case 'Draft': return l10n.status_Draft;
    case 'TechReview': return l10n.status_TechReview;
    case 'ArchiveDir': return l10n.status_ArchiveDir;
    case 'DirManager': return l10n.status_DirManager;
    case 'MinTechReview': return l10n.status_MinTechReview;
    case 'LegalReview': return l10n.status_LegalReview;
    case 'ProcReview': return l10n.status_ProcReview;
    case 'MinArchive': return l10n.status_MinArchive;
    case 'GenManager': return l10n.status_GenManager;
    case 'Completed': return l10n.status_Completed;
  // Legacy mapping for audit history
    case 'Submitted': return l10n.status_TechReview;
    case 'TechnicalReview': return l10n.status_ArchiveDir;
    case 'SupervisorReview': return l10n.status_DirManager;
    case 'MinistryReview': return l10n.status_MinTechReview;
    case 'Archive': return l10n.status_MinArchive;
    case 'Approved': return l10n.status_Completed;
    default: return status;
  }
}

class DamageReportDetailsScreen extends ConsumerWidget {
  final DamageReport report;
  final Farm? farm;

  const DamageReportDetailsScreen({
    super.key,
    required this.report,
    this.farm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the report for reactive updates (sync status, etc.)
    final reportAsync = ref.watch(damageReportStreamProvider(report.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(report.permanentFormNumber.isNotEmpty
            ? report.permanentFormNumber
            : report.temporaryFormNumber),
      ),
      body: reportAsync.when(
        data: (liveReport) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, ref, liveReport ?? report),
          child: _buildContent(context, ref, liveReport ?? report),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      bottomNavigationBar: _WorkflowActionBar(report: reportAsync.value ?? report),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, DamageReport liveReport) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (liveReport.syncStatus == 'failed' || liveReport.syncStatus == 'conflict')
                    _SyncErrorBanner(report: liveReport),
                  _HeaderSection(report: liveReport, farm: farm),
                  const Divider(height: 32),
                  _ItemsSection(report: liveReport),
                  const Divider(height: 32),
                  _AttachmentsSection(report: liveReport),
                  const Divider(height: 32),
                  _HistorySection(reportId: liveReport.id),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(BuildContext context, WidgetRef ref, DamageReport report) async {
    debugPrint("----------------------------------------");
    debugPrint("[Flutter UI] Pull-to-Refresh triggered for report ID: ${report.id}");
    try {
      final repo = ref.read(damageReportRepositoryProvider);

      // 1. Fetch latest report data and history from server and update local DB
      await repo.refreshReport(report.id);
      debugPrint("[Flutter UI] refreshReport completed successfully");

      // 2. Invalidate providers to force UI rebuild from local DB
      ref.invalidate(damageReportStreamProvider(report.id));
      ref.invalidate(damageReportHistoryProvider(report.id));
      ref.invalidate(attachmentsByReportProvider(report.id));
      ref.invalidate(damageReportsListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
        );
      }

    } catch (e, stackTrace) {
      debugPrint("[Flutter UI ERROR] Exception during _onRefresh: $e");
      debugPrint("[Flutter UI STACKTRACE]: $stackTrace");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل التحديث: $e")),
        );
      }
    }
    debugPrint("----------------------------------------");
  }
}

class _SyncErrorBanner extends ConsumerWidget {
  final DamageReport report;
  const _SyncErrorBanner({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(damageReportFormProvider);
    final isLoading = formState.isLoading;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync_problem, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                report.syncStatus == 'conflict' ? (l10n.localeName == 'ar' ? "تعارض في البيانات" : "Data Conflict") : l10n.syncError,
                style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
              )
                  : TextButton.icon(
                onPressed: () async {
                  debugPrint("----------------------------------------");
                  debugPrint("[Flutter UI] User clicked 'إعادة محاولة المزامنة' (Retry) for report ID: ${report.id}");

                  try {
                    final success = await ref
                        .read(damageReportFormProvider.notifier)
                        .retryReportSync(report.id);

                    if (context.mounted) {
                      ref.invalidate(damageReportStreamProvider(report.id));
                      ref.invalidate(damageReportHistoryProvider(report.id));
                      ref.invalidate(damageReportsListProvider);
                    }

                    debugPrint("[Flutter UI] retryReportSync result: $success");
                  } catch (e, stackTrace) {
                    debugPrint("[Flutter UI ERROR] Exception during retryReportSync: $e");
                    debugPrint("[Flutter UI STACKTRACE]: $stackTrace");
                  }
                  debugPrint("----------------------------------------");
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
                style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              ),
            ],
          ),
          if (report.lastSyncError != null && report.lastSyncError!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 32, left: 8),
              child: SelectableText(
                report.lastSyncError!,
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 13,
                  fontFamily: 'monospace', // To highlight technical errors
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (report.syncStatus == 'failed' || report.syncStatus == 'conflict')
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 32, left: 8),
              child: Text(
                l10n.localeName == 'ar' 
                  ? "فشل الاتصال أو لم يتم إرسال الطلب للسيرفر بشكل صحيح."
                  : "Connection failed or request was not sent properly to the server.",
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderSection extends ConsumerWidget {
  final DamageReport report;
  final Farm? farm;
  const _HeaderSection({required this.report, this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final farmAsync = ref.watch(farmByServerIdStreamProvider(report.farmId));
    final displayFarm = farm ?? farmAsync.value;

    final farmerAsync = ref.watch(farmerByServerIdStreamProvider(report.farmerId));

    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(report.governorateId));
    final locAsync = ref.watch(localitiesProvider((report.governorateId, report.directorateId)));

    String govName = report.governorateId;
    String dirName = report.directorateId;
    String locName = report.localityId;

    govAsync.whenData((list) {
      final match = list.where((e) => e.id == report.governorateId).firstOrNull;
      if (match != null) govName = isAr ? match.nameAr : match.nameEn;
    });

    dirAsync.whenData((list) {
      final match = list.where((e) => e.id == report.directorateId).firstOrNull;
      if (match != null) dirName = isAr ? match.nameAr : match.nameEn;
    });

    locAsync.whenData((list) {
      final match = list.where((e) => e.id == report.localityId).firstOrNull;
      if (match != null) locName = isAr ? match.nameAr : match.nameEn;
    });

    final lat = displayFarm?.latitude;
    final lon = displayFarm?.longitude;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${l10n.status}: ${_getStatusLabel(context, report.statusId)}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(report.statusId),
                ),
              ),
            ),
            if (report.syncStatus != "completed") ...[
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  report.syncStatus == 'pending' 
                      ? l10n.pendingSync 
                      : (report.syncStatus == 'syncing' 
                          ? (l10n.localeName == 'ar' ? 'جاري المزامنة...' : 'Syncing...') 
                          : report.syncStatus),
                ),
                backgroundColor: report.syncStatus == 'syncing' ? Colors.blue.shade100 : Colors.orange.shade100,
                avatar: report.syncStatus == 'syncing' 
                    ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : null,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(label: l10n.farmerName, value: farmerAsync.value?.fullName ?? report.farmerId),
        _InfoRow(label: "المزرعة", value: displayFarm?.localFarmName ?? report.farmId),
        _InfoRow(label: l10n.locationSection, value: "$govName / $dirName / $locName"),
        if (lat != null && lon != null)
          _InfoRow(
            label: "الإحداثيات الجغرافية",
            value: "${l10n.latitude}: ${lat.toStringAsFixed(5)}, ${l10n.longitude}: ${lon.toStringAsFixed(5)}",
          ),
        _InfoRow(label: "تاريخ الضرر", value: report.damageDate != null ? DateFormat("yyyy-MM-dd").format(report.damageDate!) : '...'),
        _InfoRow(label: l10n.reportNumber, value: report.permanentFormNumber.isNotEmpty ? report.permanentFormNumber : report.temporaryFormNumber),
        _InfoRow(
          label: "إجمالي الضرر",
          value: "${(report.totalDamage > 0 ? report.totalDamage : report.items.fold(0.0, (sum, item) => sum + item.estimatedLoss)).toStringAsFixed(2)} €",
        ),
        _InfoRow(label: l10n.notes, value: report.notes),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft': return Colors.grey;
      case 'TechReview':
      case 'MinTechReview':
      case 'Submitted':
        return Colors.blue;
      case 'Completed':
      case 'Approved':
        return Colors.green;
      case 'Rejected': return Colors.red;
      default: return Colors.black;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ItemsSection extends ConsumerWidget {
  final DamageReport report;
  const _ItemsSection({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final refDataAsync = ref.watch(referenceDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.damageReports, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...report.items.map((item) {
          final classificationName = refDataAsync.maybeWhen(
            data: (data) {
              final match = data.damageClassifications
                  .where((c) => c.id == item.classificationId)
                  .firstOrNull;
              return match != null
                  ? (isAr ? match.nameAr : match.nameEn)
                  : item.classificationId.toString();
            },
            orElse: () => item.classificationId.toString(),
          );

          return Card(
            child: ListTile(
              title: Text("${l10n.assessmentItem}: $classificationName"),
              subtitle: Text(
                "${l10n.quantity}: ${item.quantity} - ${l10n.technicalLoss}: ${item.estimatedLoss}",
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AttachmentsSection extends ConsumerWidget {
  final DamageReport report;
  const _AttachmentsSection({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachmentsAsync = ref.watch(attachmentsByReportProvider(report.id));
    final auth = ref.watch(authProvider);

    // Visibility rule: show add button only if has items (for field staff) OR is Archive stage
    final bool canAdd = (report.items.isNotEmpty && (auth.hasRole('AgriculturalEngineer') || auth.hasRole('FieldSurveyor')) && (report.statusId == 'Draft' || report.statusId == 'PendingTechnicalVerification')) ||
                        (auth.hasRole('ArchiveOfficer') && report.statusId == 'ArchiveDir') ||
                        (auth.hasRole('ChiefArchiveOfficer') && report.statusId == 'MinArchive');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("المرفقات والوثائق", style: Theme.of(context).textTheme.titleLarge),
            if (canAdd)
              IconButton(
                icon: const Icon(Icons.add_a_photo, color: Colors.green),
                onPressed: () => _addAttachment(context, ref),
              ),
          ],
        ),
        const SizedBox(height: 8),
        attachmentsAsync.when(
          data: (list) => list.isEmpty
              ? const Text("لا توجد مرفقات.")
              : _buildAttachmentsList(context, ref, list, canAdd),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text("خطأ: $e"),
        ),
      ],
    );
  }

  Widget _buildAttachmentsList(BuildContext context, WidgetRef ref, List<DamageReportAttachment> list, bool canAdd) {
    final typesAsync = ref.watch(documentTypesProvider);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final docType = typesAsync.value?.where((t) => t.id == item.documentTypeId).firstOrNull;
        final typeName = docType != null 
            ? (isAr ? docType.nameAr : docType.nameEn)
            : _getDocTypeName(item.documentTypeId);

        return Card(
          child: ListTile(
            leading: _getDocIcon(item.documentTypeId),
            title: Text(item.documentName),
            subtitle: Text("$typeName - ${item.documentDate != null ? DateFormat('yyyy-MM-dd').format(item.documentDate!) : ''}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.syncStatus == 'completed' ? Icons.cloud_done : Icons.cloud_upload_outlined,
                  color: item.syncStatus == 'completed' ? Colors.green : Colors.orange,
                  size: 18
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    // Logic to view file
                  },
                ),
                if (canAdd)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ref.read(damageReportFormProvider.notifier).deleteAttachment(item.id);
                      ref.invalidate(attachmentsByReportProvider(report.id));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addAttachment(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<DamageReportAttachment>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AttachmentFormSheet(reportId: report.id),
    );

    if (result != null) {
      await ref.read(attachmentRepositoryProvider).uploadAttachment(result);
      ref.invalidate(attachmentsByReportProvider(report.id));
    }
  }

  Icon _getDocIcon(int typeId) {
    switch (typeId) {
      case 1: return const Icon(Icons.image);
      case 2: return const Icon(Icons.badge);
      case 3: return const Icon(Icons.description);
      case 4: return const Icon(Icons.picture_as_pdf, color: Colors.red);
      default: return const Icon(Icons.attach_file);
    }
  }

  String _getDocTypeName(int typeId) {
    switch (typeId) {
      case 1: return "صورة الموقع";
      case 2: return "صورة هوية";
      case 3: return "أوراق ملكية";
      case 4: return "استمارة ضرر";
      case 8: return "شهادة ضرر";
      default: return "أخرى";
    }
  }
}

class _HistorySection extends ConsumerWidget {
  final String reportId;
  const _HistorySection({required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final historyAsync = ref.watch(damageReportHistoryProvider(reportId));

    final bool showIntegrated = auth.hasRole('SuperAdmin') || 
                                auth.hasRole('GeneralManager') || 
                                auth.hasRole('ProceduralReviewer');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("سجل الحركات", style: Theme.of(context).textTheme.titleLarge),
            if (showIntegrated)
              TextButton.icon(
                icon: const Icon(Icons.analytics),
                label: const Text("السجل المتكامل (Log)"),
                onPressed: () => _showAuditLog(context, ref),
              ),
          ],
        ),
        const SizedBox(height: 8),
        historyAsync.when(
          data: (history) => history.isEmpty
              ? const Text("لا يوجد سجل حركات بعد.")
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text("من ${_getStatusLabel(context, item.fromStatus)} إلى ${_getStatusLabel(context, item.toStatus)}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("بواسطة: ${item.changedByUserName.isNotEmpty ? item.changedByUserName : item.changedByUserId} في ${item.changedAt != null ? DateFormat("yyyy-MM-dd HH:mm").format(item.changedAt!) : '...'}"),
                    if (item.comment != null && item.comment!.isNotEmpty) Text("تعليق: ${item.comment}", style: const TextStyle(fontStyle: FontStyle.italic)),
                    if (item.isOverride) const Text("(تجاوز إداري)", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text("خطأ في تحميل السجل: $e"),
        ),
      ],
    );
  }

  void _showAuditLog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          final auditLogAsync = ref.watch(damageReportAuditLogProvider(reportId));
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("سجل العمليات المتكامل (Audit Log)", style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                Expanded(
                  child: auditLogAsync.when(
                    data: (logs) => ListView.builder(
                      controller: scrollController,
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return ListTile(
                          leading: _getLogIcon(log.eventType),
                          title: Text(log.description),
                          subtitle: Text("${log.performedBy} | ${DateFormat('yyyy-MM-dd HH:mm').format(log.eventDate)}"),
                          trailing: log.metadata != null ? const Icon(Icons.comment) : null,
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("خطأ: $e")),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Icon _getLogIcon(String type) {
    switch (type) {
      case 'Farmer': return const Icon(Icons.person, color: Colors.blue);
      case 'Farm': return const Icon(Icons.landscape, color: Colors.green);
      case 'Report': return const Icon(Icons.assignment, color: Colors.orange);
      case 'Transition': return const Icon(Icons.swap_horiz, color: Colors.purple);
      default: return const Icon(Icons.info_outline);
    }
  }
}

class _WorkflowActionBar extends ConsumerWidget {
  final DamageReport report;
  const _WorkflowActionBar({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final formState = ref.watch(damageReportFormProvider);
    final status = report.statusId;
    final isBusy = formState.isLoading || report.syncStatus == 'pending' || report.syncStatus == 'syncing';

    final List<Widget> actions = [];

    if (status == DamageReportStatus.draft || status == DamageReportStatus.pendingTechnicalVerification) {
      if (auth.hasRole("AgriculturalEngineer") || auth.hasRole("FieldSurveyor")) {
        actions.add(_ActionButton(
          label: "تعديل التقييم",
          icon: Icons.edit,
          color: isBusy ? Colors.grey : Colors.blue,
          onPressed: isBusy ? null : () => context.push(AppRoutes.editDamageReport, extra: report.id),
        ));

        actions.add(_ActionButton(
          label: "إرسال للمراجعة",
          icon: Icons.send,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleSubmit(context, ref),
        ));
      }
    } else if (status == DamageReportStatus.techReview) {
      if (auth.hasRole("TechnicalReviewer")) {
        actions.add(_ActionButton(
          label: "تحويل للأرشفة",
          icon: Icons.verified_user,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'ArchiveDir'),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للتعديل",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'Draft', needsComment: true),
        ));
      }
    } else if (status == 'ArchiveDir') {
      if (auth.hasRole("ArchiveOfficer")) {
        actions.add(_ActionButton(
          label: "تحويل للمدير",
          icon: Icons.check_circle,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'DirManager'),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للمراجعة",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'TechReview', needsComment: true),
        ));
      }
    } else if (status == DamageReportStatus.dirManager) {
      if (auth.hasRole("DirectorateManager") || auth.hasRole("Director") || auth.hasRole("Supervisor")) {
        actions.add(_ActionButton(
          label: "اعتماد المديرية",
          icon: Icons.approval,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.minTechReview),
        ));
        actions.add(_ActionButton(
          label: "إرجاع (متعدد)",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.red,
          onPressed: isBusy ? null : () => _handleMultiStepReturn(context, ref),
        ));
      }
    } else if (status == DamageReportStatus.minTechReview) {
      if (auth.hasRole("MinistryTechReviewer")) {
        actions.add(_ActionButton(
          label: "تحويل للقانونية",
          icon: Icons.gavel,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.legalReview),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للمديرية",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.dirManager, needsComment: true),
        ));
      }
    } else if (status == DamageReportStatus.legalReview) {
      if (auth.hasRole("LegalReviewer")) {
        actions.add(_ActionButton(
          label: "تحويل للأرشفة",
          icon: Icons.archive,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.minArchive),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للفنية",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.minTechReview, needsComment: true),
        ));
      }
    } else if (status == DamageReportStatus.minArchive) {
      if (auth.hasRole("ChiefArchiveOfficer")) {
        actions.add(_ActionButton(
          label: "تحويل للإجرائية",
          icon: Icons.next_plan,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.procReview),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للقانونية",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.legalReview, needsComment: true),
        ));
      }
    } else if (status == DamageReportStatus.procReview) {
      if (auth.hasRole("ProceduralReviewer")) {
        actions.add(_ActionButton(
          label: "تحويل للمدير العام",
          icon: Icons.person_add,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.genManager),
        ));
        // ProceduralReviewer cannot return as per rules (Forward Only)
      }
    } else if (status == DamageReportStatus.genManager) {
      if (auth.hasRole("GeneralManager")) {
        actions.add(_ActionButton(
          label: "اعتماد نهائي",
          icon: Icons.verified,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, DamageReportStatus.completed),
        ));
        actions.add(_ActionButton(
          label: "إرجاع (متعدد)",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.red,
          onPressed: isBusy ? null : () => _handleMultiStepReturn(context, ref),
        ));
      }
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: actions,
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    debugPrint("----------------------------------------");
    debugPrint("[Flutter UI] User clicked 'إرسال للمراجعة' for report ID: ${report.id}");

    final notifier = ref.read(damageReportFormProvider.notifier);

    try {
      final success = await notifier.submitReport(report.id);

      if (context.mounted) {
        ref.invalidate(damageReportStreamProvider(report.id));
        ref.invalidate(damageReportHistoryProvider(report.id));
        ref.invalidate(damageReportsListProvider);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إرسال التقرير للمراجعة بنجاح")),
          );
        } else {
          final errors = ref.read(damageReportFormProvider).errors;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("فشل إرسال التقرير: ${errors.join(', ')}")),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("[Flutter UI EXCEPTION] Exception caught during submitReport: $e");
      debugPrint("[Flutter UI STACKTRACE]: $stackTrace");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ غير متوقع: $e")),
        );
      }
    }
    debugPrint("----------------------------------------");
  }

  void _handleTransition(BuildContext context, WidgetRef ref, String toStatus, {bool needsComment = false}) async {
    String? comment;
    if (needsComment) {
      comment = await _showCommentDialog(context);
      if (comment == null) return; // Cancelled
    }

    final notifier = ref.read(damageReportFormProvider.notifier);
    final success = await notifier.transitionReport(report.id, toStatus, comment: comment);

    if (context.mounted) {
      ref.invalidate(damageReportStreamProvider(report.id));
      ref.invalidate(damageReportHistoryProvider(report.id));
      ref.invalidate(attachmentsByReportProvider(report.id));
      ref.invalidate(damageReportsListProvider);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم تحديث الحالة إلى ${_getStatusLabel(context, toStatus)}")),
        );
      } else {
        final errors = ref.read(damageReportFormProvider).errors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تحديث الحالة: ${errors.join(', ')}")),
        );
      }
    }
  }

  void _handleMultiStepReturn(BuildContext context, WidgetRef ref) async {
    final List<String> allStatuses = DamageReportStatus.all;
    final int currentIndex = allStatuses.indexOf(report.statusId);
    
    if (currentIndex <= 0) return;

    final List<String> previousStatuses = allStatuses.sublist(0, currentIndex);

    final selectedStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("اختيار مرحلة الإرجاع"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: previousStatuses.length,
            itemBuilder: (context, index) {
              final s = previousStatuses[index];
              return ListTile(
                title: Text(_getStatusLabel(context, s)),
                onTap: () => Navigator.pop(context, s),
              );
            },
          ),
        ),
      ),
    );

    if (selectedStatus != null) {
      if (context.mounted) {
        _handleTransition(context, ref, selectedStatus, needsComment: true);
      }
    }
  }

  Future<String?> _showCommentDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة تعليق"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "أدخل سبب الإرجاع..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("إرسال")),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }
}
