import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/agricultural_assistance/domain/agricultural_assistance.dart';
import 'package:mobile/features/agricultural_assistance/presentation/agricultural_assistance_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class AgriculturalAssistanceScreen extends ConsumerWidget {
  final String reportId;

  const AgriculturalAssistanceScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final assistanceAsync = ref.watch(assistanceDecisionProvider(reportId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.agriculturalAssistance)),
      body: assistanceAsync.when(
        data: (assistance) => assistance == null
            ? _NoAssistanceView(reportId: reportId)
            : _AssistanceDetailView(assistance: assistance),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }
}

class _NoAssistanceView extends ConsumerStatefulWidget {
  final String reportId;
  const _NoAssistanceView({required this.reportId});

  @override
  ConsumerState<_NoAssistanceView> createState() =>
      __NoAssistanceViewState();
}

class __NoAssistanceViewState extends ConsumerState<_NoAssistanceView> {
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actionState = ref.watch(assistanceActionProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.calculate_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          Text(l10n.noAssistance, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          TextField(
            controller: _remarksController,
            decoration: InputDecoration(
              labelText: l10n.remarks,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: actionState.isLoading
                ? null
                : () async {
                    await ref
                        .read(assistanceActionProvider.notifier)
                        .calculate(widget.reportId, _remarksController.text);
                    ref.invalidate(assistanceDecisionProvider(widget.reportId));
                  },
            child: actionState.isLoading
                ? const CircularProgressIndicator()
                : Text(l10n.calculateAssistance),
          ),
        ],
      ),
    );
  }
}

class _AssistanceDetailView extends ConsumerWidget {
  final AgriculturalAssistance assistance;
  const _AssistanceDetailView({required this.assistance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authProvider);
    final roles = auth.session?.roles ?? [];

    final canManage =
        roles.contains('SuperAdmin') || roles.contains('Administrator');
    final canSubmit = canManage || roles.contains('AgriculturalEngineer');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DataRow(
            label: l10n.calculatedAmount,
            value: '${assistance.calculatedAmount}',
          ),
          _DataRow(
            label: l10n.approvedAmount,
            value: '${assistance.approvedAmount}',
          ),
          _DataRow(label: l10n.status, value: assistance.status),
          _DataRow(label: l10n.remarks, value: assistance.remarks),
          const SizedBox(height: 40),

          if (assistance.status == 'Calculated' && canSubmit)
            ElevatedButton(
              onPressed: () => _handleAction(
                ref,
                () => ref
                    .read(assistanceActionProvider.notifier)
                    .submit(assistance),
              ),
              child: const Text('Submit for Approval'),
            ),

          if (assistance.status == 'Submitted' && canManage) ...[
            ElevatedButton(
              onPressed: () => _handleAction(
                ref,
                () => ref
                    .read(assistanceActionProvider.notifier)
                    .approve(
                      assistance,
                      assistance.calculatedAmount,
                      'Approved by admin',
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.approve),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _handleAction(
                ref,
                () => ref
                    .read(assistanceActionProvider.notifier)
                    .reject(assistance, 'Rejected by admin'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],

          if (assistance.status == 'Approved' && canManage)
            ElevatedButton(
              onPressed: () => _handleAction(
                ref,
                () => ref
                    .read(assistanceActionProvider.notifier)
                    .pay(assistance, 'Paid out'),
              ),
              child: Text(l10n.paid),
            ),

          if ((assistance.status == 'Calculated' ||
                  assistance.status == 'Rejected') &&
              canSubmit) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => _handleAction(
                ref,
                () => ref
                    .read(assistanceActionProvider.notifier)
                    .recalculate(assistance),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Recalculate'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleAction(
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    await action();
    ref.invalidate(assistanceDecisionProvider(assistance.damageReportId));
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
