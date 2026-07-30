import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_cause_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_cause_selector.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DamageReportHeaderScreen extends ConsumerStatefulWidget {
  final Farm farm;

  const DamageReportHeaderScreen({super.key, required this.farm});

  @override
  ConsumerState<DamageReportHeaderScreen> createState() =>
      _DamageReportHeaderScreenState();
}

class _DamageReportHeaderScreenState extends ConsumerState<DamageReportHeaderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _localId;
  late DateTime _damageDate;
  late DateTime _documentationDate;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _localId = const Uuid().v4();
    _damageDate = DateTime.now();
    _documentationDate = DateTime.now();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final causeState = ref.read(damageCauseWizardProvider);
    if (causeState.selectedCause == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a damage cause.')),
      );
      return;
    }

    final report = DamageReport(
      id: _localId,
      farmId: widget.farm.id,
      damageDate: _damageDate,
      documentationDate: _documentationDate,
      agriculturalSectorId: widget.farm.agriculturalSectorId,
      damageCauseCategoryId: causeState.selectedCategory!.id,
      damageCauseId: causeState.selectedCause!.id,
      notes: _notesController.text.trim(),
      statusId: DamageReportStatus.pendingTechnicalVerification,
    );

    try {
      await ref.read(damageReportFormProvider.notifier).createDamageReport(report);

      if (mounted) {
        final formState = ref.read(damageReportFormProvider);
        if (formState.success) {
          final created = formState.createdReport;
          if (created != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Damage report header saved. Waiting for synchronization to add items.')),
            );
            context.pop();
          }
        } else if (formState.errors.isNotEmpty) {
          final l10n = AppLocalizations.of(context)!;
          String message = formState.errors.first;
          if (message.contains('already exists')) {
            message = l10n.duplicateReportError;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(damageReportFormProvider);
    final causeState = ref.watch(damageCauseWizardProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newDamageReport),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFarmInfo(),
                    const Divider(height: 32),
                    _buildDateTile(l10n.damageDate, _damageDate, (picked) => setState(() => _damageDate = picked)),
                    _buildReadOnlyField(l10n.documentationDate, DateFormat.yMMMd().format(_documentationDate)),
                    const SizedBox(height: 16),
                    _buildSectorDisplay(l10n),
                    const SizedBox(height: 16),
                    _buildCauseSelector(causeState, l10n),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.notes,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          FormSaveFooter(
            onSave: _save,
            isLoading: state.isLoading,
            isValid: state.errors.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildFarmInfo() {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(widget.farm.governorateId));
    final locAsync = ref.watch(localitiesProvider((widget.farm.governorateId, widget.farm.directorateId)));

    String govName = widget.farm.governorateId;
    String dirName = widget.farm.directorateId;
    String locName = widget.farm.localityId;

    govAsync.whenData((list) {
      final match = list.where((e) => e.id == widget.farm.governorateId).firstOrNull;
      if (match != null) govName = isAr ? match.nameAr : match.nameEn;
    });

    dirAsync.whenData((list) {
      final match = list.where((e) => e.id == widget.farm.directorateId).firstOrNull;
      if (match != null) dirName = isAr ? match.nameAr : match.nameEn;
    });

    locAsync.whenData((list) {
      final match = list.where((e) => e.id == widget.farm.localityId).firstOrNull;
      if (match != null) locName = isAr ? match.nameAr : match.nameEn;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.farm.localFarmName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          '${l10n.basin}: ${widget.farm.basin}, ${l10n.parcel}: ${widget.farm.parcel}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '${l10n.locationSection}: $govName / $dirName / $locName',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (widget.farm.latitude != null && widget.farm.longitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${l10n.latitude}: ${widget.farm.latitude!.toStringAsFixed(5)}, ${l10n.longitude}: ${widget.farm.longitude!.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blueGrey),
            ),
          ),
      ],
    );
  }

  Widget _buildDateTile(String label, DateTime date, Function(DateTime) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(DateFormat.yMMMd().format(date)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onPicked(picked);
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSectorDisplay(AppLocalizations l10n) {
    final refDataAsync = ref.watch(referenceDataProvider);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return refDataAsync.when(
      data: (data) {
        final sector = data.agriculturalSectors
            .where((n) => n.id == widget.farm.agriculturalSectorId)
            .firstOrNull;
        final sectorName = sector != null
            ? (isAr ? sector.nameAr : sector.nameEn)
            : widget.farm.agriculturalSectorId.toString();

        return _buildReadOnlyField(l10n.agriculturalSector, sectorName);
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }

  Widget _buildCauseSelector(DamageCauseWizardState state, AppLocalizations l10n) {
    return InkWell(
      onTap: _showCauseSelector,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.damageCause, style: const TextStyle(fontSize: 12)),
                  if (state.selectedCause != null)
                    Text(
                      '${state.selectedCategory!.nameAr} - ${state.selectedCause!.nameAr}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  else
                    Text(l10n.selectCause, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCauseSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.6,
        child: DamageCauseSelector(),
      ),
    );
  }
}
