import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_cause_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_cause_selector.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
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
  late TextEditingController _settlementController;
  late TextEditingController _companyController;

  AgriculturalSector? _selectedSector;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _localId = const Uuid().v4();
    _damageDate = DateTime.now();
    _documentationDate = DateTime.now();
    _notesController = TextEditingController();
    _settlementController = TextEditingController();
    _companyController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _settlementController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _initializeLookup() async {
    if (_initialized) return;
    final refData = await ref.read(referenceDataProvider.future);
    
    setState(() {
      _selectedSector = refData.agriculturalSectors
          .where((n) => n.id == widget.farm.agriculturalSectorId)
          .firstOrNull;
      _initialized = true;
    });
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

    if (_selectedSector == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an agricultural sector.')),
      );
      return;
    }

    final report = DamageReport(
      id: _localId,
      farmId: widget.farm.id,
      damageDate: _damageDate,
      documentationDate: _documentationDate,
      agriculturalSectorId: _selectedSector!.id,
      damageCauseCategoryId: causeState.selectedCategory!.id,
      damageCauseId: causeState.selectedCause!.id,
      settlementName: _settlementController.text.trim(),
      companyName: _companyController.text.trim(),
      notes: _notesController.text.trim(),
      statusId: DamageReportStatus.pendingTechnicalVerification,
    );

    await ref.read(damageReportFormProvider.notifier).createDamageReport(report);

    if (mounted && ref.read(damageReportFormProvider).success) {
      final created = ref.read(damageReportFormProvider).createdReport;
      if (created != null) {
        // Navigate to Assessment Screen (Step 2)
        // For now, we'll pop and let the list handle it, or navigate forward.
        // The plan says: Header Screen -> Successful Save -> Assessment Screen.
        // I'll need to define the route for Assessment Screen.
        // Navigator.of(context).pushReplacementNamed('/damage-reports/assessment', arguments: created.id);
        
        // Temporary: Just pop and show success.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Header saved successfully.')),
        );
        Navigator.of(context).pop(created.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeLookup();
    final state = ref.watch(damageReportFormProvider);
    final causeState = ref.watch(damageCauseWizardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Damage Report'),
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
                    _buildDateTile('Damage Date', _damageDate, (picked) => setState(() => _damageDate = picked)),
                    _buildReadOnlyField('Documentation Date', DateFormat.yMMMd().format(_documentationDate)),
                    const SizedBox(height: 16),
                    _buildSectorSelector(),
                    const SizedBox(height: 16),
                    _buildCauseSelector(causeState),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _settlementController,
                      decoration: const InputDecoration(
                        labelText: 'Settlement Name (If applicable)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company Name (If applicable)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'General Notes',
                        border: OutlineInputBorder(),
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
            isSaving: state.isLoading,
            errors: state.errors,
          ),
        ],
      ),
    );
  }

  Widget _buildFarmInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.farm.localFarmName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'Basin: ${widget.farm.basin}, Parcel: ${widget.farm.parcel}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Location: ${widget.farm.governorateId} / ${widget.farm.directorateId}',
          style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildSectorSelector() {
    final refDataAsync = ref.watch(referenceDataProvider);
    return refDataAsync.when(
      data: (data) => DropdownButtonFormField<AgriculturalSector>(
        value: _selectedSector,
        decoration: const InputDecoration(
            labelText: 'Agricultural Sector', border: OutlineInputBorder()),
        items: data.agriculturalSectors
            .map((n) => DropdownMenuItem(value: n, child: Text(n.nameAr)))
            .toList(),
        onChanged: (val) => setState(() => _selectedSector = val),
        validator: (val) => val == null ? 'Required' : null,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }

  Widget _buildCauseSelector(DamageCauseWizardState state) {
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
                  const Text('Damage Cause', style: TextStyle(fontSize: 12)),
                  if (state.selectedCause != null)
                    Text(
                      '${state.selectedCategory!.nameAr} - ${state.selectedCause!.nameAr}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  else
                    const Text('Select Cause', style: TextStyle(color: Colors.grey)),
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
