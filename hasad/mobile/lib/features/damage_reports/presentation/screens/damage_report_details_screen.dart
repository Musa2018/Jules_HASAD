import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:intl/intl.dart';
import 'package:mobile/l10n/app_localizations.dart';

String _getStatusLabel(BuildContext context, String status) {
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
        data: (liveReport) => _buildContent(context, ref, liveReport ?? report),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      bottomNavigationBar: _WorkflowActionBar(report: reportAsync.value ?? report),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, DamageReport liveReport) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HeaderSection(report: liveReport),
        const Divider(height: 32),
        _ItemsSection(report: liveReport),
        const Divider(height: 32),
        _HistorySection(reportId: liveReport.id),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final DamageReport report;
  const _HeaderSection({required this.report});

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "حالة التقرير: ${_getStatusLabel(context, report.statusId)}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(report.statusId),
                  ),
            ),
            if (report.syncStatus != "completed")
              Chip(
                label: Text(report.syncStatus),
                backgroundColor: Colors.orange.shade100,
              ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(label: "تاريخ الضرر", value: DateFormat("yyyy-MM-dd").format(report.damageDate)),
        _InfoRow(label: "رقم الاستمارة", value: report.permanentFormNumber.isNotEmpty ? report.permanentFormNumber : report.temporaryFormNumber),
        _InfoRow(label: "الملاحظات", value: report.notes),
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

class _ItemsSection extends StatelessWidget {
  final DamageReport report;
  const _ItemsSection({required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("الأصناف المتضررة", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...report.items.map((item) => Card(
              child: ListTile(
                title: Text("الصنف: ${item.classificationId}"),
                subtitle: Text("الكمية: ${item.quantity} - الخسارة المتوقعة: ${item.estimatedLoss}"),
              ),
            )),
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

                    
                    // Actually, I'll use a local function or move the label logic
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text("من ${_getStatusLabel(context, item.fromStatus)} إلى ${_getStatusLabel(context, item.toStatus)}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("بواسطة: ${item.changedByUserId} في ${DateFormat("yyyy-MM-dd HH:mm").format(item.changedAt)}"),
                          if (item.comment != null) Text("تعليق: ${item.comment}", style: const TextStyle(fontStyle: FontStyle.italic)),
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
    final status = report.statusId;

    // Determine allowed actions based on role and current status
    final List<Widget> actions = [];

    if (status == 'Draft') {
      if (auth.hasRole("AgriculturalEngineer") || auth.hasRole("FieldSurveyor")) {
        actions.add(_ActionButton(
          label: "إرسال للمراجعة",
          icon: Icons.send,
          color: Colors.blue,
          onPressed: () => _handleTransition(context, ref, 'TechReview'),
        ));
      }
    } else if (status == 'TechReview') {
      if (auth.hasRole("TechnicalReviewer")) {
        actions.add(_ActionButton(
          label: "تحويل للأرشفة",
          icon: Icons.verified_user,
          color: Colors.green,
          onPressed: () => _handleTransition(context, ref, 'ArchiveDir'),
        ));
        actions.add(_ActionButton(
          label: "إرجاع للتعديل",
          icon: Icons.assignment_return,
          color: Colors.orange,
          onPressed: () => _handleTransition(context, ref, 'Draft', needsComment: true),
        ));
      }
    } else if (status == 'ArchiveDir') {
       if (auth.hasRole("ArchiveOfficer")) {
         actions.add(_ActionButton(
           label: "تحويل للمدير",
           icon: Icons.check_circle,
           color: Colors.green,
           onPressed: () => _handleTransition(context, ref, 'DirManager'),
         ));
          actions.add(_ActionButton(
          label: "إرجاع للمراجعة",
          icon: Icons.assignment_return,
          color: Colors.orange,
          onPressed: () => _handleTransition(context, ref, 'TechReview', needsComment: true),
        ));
       }
    } else if (status == 'DirManager') {
       if (auth.hasRole("DirectorateManager") || auth.hasRole("Director") || auth.hasRole("Supervisor")) {
         actions.add(_ActionButton(
           label: "اعتماد المديرية",
           icon: Icons.approval,
           color: Colors.green,
           onPressed: () => _handleTransition(context, ref, 'MinTechReview'),
         ));
          actions.add(_ActionButton(
          label: "إرجاع للأرشفة",
          icon: Icons.assignment_return,
          color: Colors.orange,
          onPressed: () => _handleTransition(context, ref, 'ArchiveDir', needsComment: true),
        ));
       }
    }
    // ... add more as roles are assigned to users
    // ... add more for other states

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

  void _handleTransition(BuildContext context, WidgetRef ref, String toStatus, {bool needsComment = false}) async {
    String? comment;
    if (needsComment) {
       comment = await _showCommentDialog(context);
       if (comment == null) return; // Cancelled
    }

    try {
      final repository = ref.read(damageReportRepositoryProvider);
      await repository.transitionReport(report.id, toStatus, comment: comment);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم تحديث الحالة إلى $toStatus")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تحديث الحالة: $e")),
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
  final VoidCallback onPressed;

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
