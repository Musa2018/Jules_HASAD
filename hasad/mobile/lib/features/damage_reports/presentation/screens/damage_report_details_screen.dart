import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:intl/intl.dart';
import 'package:mobile/l10n/app_localizations.dart';

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
  final Farm farm;

  const DamageReportDetailsScreen({
    super.key,
    required this.report,
    required this.farm,
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
  final Farm farm;
  const _HeaderSection({required this.report, required this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(farm.governorateId));
    final locAsync = ref.watch(localitiesProvider((farm.governorateId, farm.directorateId)));

    String govName = farm.governorateId;
    String dirName = farm.directorateId;
    String locName = farm.localityId;

    govAsync.whenData((list) {
      final match = list.where((e) => e.id == farm.governorateId).firstOrNull;
      if (match != null) govName = isAr ? match.nameAr : match.nameEn;
    });

    dirAsync.whenData((list) {
      final match = list.where((e) => e.id == farm.directorateId).firstOrNull;
      if (match != null) dirName = isAr ? match.nameAr : match.nameEn;
    });

    locAsync.whenData((list) {
      final match = list.where((e) => e.id == farm.localityId).firstOrNull;
      if (match != null) locName = isAr ? match.nameAr : match.nameEn;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${l10n.status}: ${_getStatusLabel(context, report.statusId)}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(report.statusId),
              ),
            ),
            if (report.syncStatus != "completed")
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
        ),
        const SizedBox(height: 16),
        _InfoRow(label: "المزرعة", value: farm.localFarmName),
        _InfoRow(label: l10n.locationSection, value: "$govName / $dirName / $locName"),
        if (farm.latitude != null && farm.longitude != null)
          _InfoRow(
            label: "الإحداثيات الجغرافية",
            value: "${l10n.latitude}: ${farm.latitude!.toStringAsFixed(5)}, ${l10n.longitude}: ${farm.longitude!.toStringAsFixed(5)}",
          ),
        _InfoRow(label: "تاريخ الضرر", value: report.damageDate != null ? DateFormat("yyyy-MM-dd").format(report.damageDate!) : '...'),
        _InfoRow(label: l10n.reportNumber, value: report.permanentFormNumber.isNotEmpty ? report.permanentFormNumber : report.temporaryFormNumber),
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

class _HistorySection extends ConsumerWidget {
  final String reportId;
  const _HistorySection({required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(damageReportHistoryProvider(reportId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("سجل الحركات (Workflow History)", style: Theme.of(context).textTheme.titleLarge),
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
    } else if (status == 'DirManager') {
      if (auth.hasRole("DirectorateManager") || auth.hasRole("Director") || auth.hasRole("Supervisor")) {
        actions.add(_ActionButton(
          label: "اعتماد المديرية",
          icon: Icons.approval,
          color: isBusy ? Colors.grey : Colors.green,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'MinTechReview'),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للأرشفة",
          icon: Icons.assignment_return,
          color: isBusy ? Colors.grey : Colors.orange,
          onPressed: isBusy ? null : () => _handleTransition(context, ref, 'ArchiveDir', needsComment: true),
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