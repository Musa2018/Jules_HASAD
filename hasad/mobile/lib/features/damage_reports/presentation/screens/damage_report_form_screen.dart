import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_status.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_cause_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_cause_selector.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_item_form_sheet.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DamageReportFormScreen extends ConsumerStatefulWidget {
  final Farm farm;
  final DamageReport? report;

  const DamageReportFormScreen({super.key, required this.farm, this.report});

  @override
  ConsumerState<DamageReportFormScreen> createState() =>
      _DamageReportFormScreenState();
}

class _DamageReportFormScreenState
    extends ConsumerState<DamageReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _localId;
  late DateTime _damageDate;
  late DateTime _documentationDate;
  late TextEditingController _notesController;
  List<DamageItem> _items = [];
  bool _initialized = false;
  int _currentStep = 0; // 0: Header, 1: Assessment

  DamageReport? _activeReport;
  DamageNature? _selectedNature;

  @override
  void initState() {
    super.initState();
    _activeReport = widget.report;
    _localId = widget.report?.id ?? const Uuid().v4();
    _damageDate = widget.report?.damageDate ?? DateTime.now();
    _documentationDate = widget.report?.documentationDate ?? DateTime.now();
    _notesController = TextEditingController(text: widget.report?.notes);
    _items = widget.report?.items.toList() ?? [];
    
    if (widget.report != null && widget.report!.reportNumber.isNotEmpty) {
      _currentStep = 1;
    }
  }

  void _initializeWizard() async {
    if (_initialized) return;
    if (widget.report != null) {
      final categories = await ref.read(damageCauseCategoriesProvider.future);
      final refData = await ref.read(referenceDataProvider.future);
      
      // Load Nature
      if (widget.report!.damageNatureId != 0) {
        _selectedNature = refData.damageNatures.where((n) => n.id == widget.report!.damageNatureId).firstOrNull;
      }

      ref.read(damageCauseWizardProvider.notifier).loadFromIds(
        widget.report!.damageCauseCategoryId,
        widget.report!.damageCauseId,
        categories,
        refData.damageCauses,
      );
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _totalEstimatedLoss =>
      _items.fold(0.0, (sum, item) => sum + item.estimatedLoss);

  Future<void> _save({bool submit = false}) async {
    final causeState = ref.read(damageCauseWizardProvider);
    
    if (_selectedNature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a damage nature.')),
      );
      return;
    }

    if (causeState.selectedCause == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a damage cause.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (submit && _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one damage item is required for submission.')),
      );
      return;
    }

    final report = DamageReport(
      id: _localId,
      reportNumber: widget.report?.reportNumber ?? '',
      temporaryFormNumber: widget.report?.temporaryFormNumber ?? '',
      damageYear: _damageDate.year,
      farmId: widget.farm.id,
      farmerId: widget.farm.farmerId,
      damageDate: _damageDate,
      documentationDate: _documentationDate,
      damageNatureId: _selectedNature!.id,
      damageCauseCategoryId: causeState.selectedCategory!.id,
      damageCauseId: causeState.selectedCause!.id,
      governorateId: widget.farm.governorateId,
      directorateId: widget.farm.directorateId,
      localityId: widget.farm.localityId,
      statusId: widget.report?.statusId ?? DamageReportStatus.draft,
      notes: _notesController.text.trim(),
      rowVersion: widget.report?.rowVersion ?? '',
      items: _items,
    );

    if (widget.report == null && _currentStep == 0) {
      await ref
          .read(damageReportFormProvider.notifier)
          .createDamageReport(report);
    } else {
      await ref
          .read(damageReportFormProvider.notifier)
          .updateDamageReport(report);
    }

    if (mounted && ref.read(damageReportFormProvider).success) {
      final savedReport = ref.read(damageReportFormProvider).createdReport;
      setState(() {
        _activeReport = savedReport;
        if (savedReport != null) {
          _localId = savedReport.id;
          _items = savedReport.items.toList();
        }
      });

      if (submit) {
        await ref.read(damageReportFormProvider.notifier).submitReport(_localId);
      } else if (_currentStep == 0) {
        setState(() {
          _currentStep = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Header saved. You can now add damage items.')),
        );
        return; // Stay on screen for Step 2
      }

      if (mounted && ref.read(damageReportFormProvider).success) {
        ref.invalidate(damageReportsListByFarmProvider(widget.farm.id));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeWizard();
    final state = ref.watch(damageReportFormProvider);
    final causeState = ref.watch(damageCauseWizardProvider);

    final isReadOnly = _activeReport != null && _activeReport!.statusId != DamageReportStatus.draft;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.report == null ? 'Add Damage Report' : 'Edit Damage Report',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_currentStep == 0) ..._buildHeaderFields(state, causeState, isReadOnly),
              if (_currentStep == 1) ..._buildAssessmentFields(state, isReadOnly),
            ],
          ),
        ),
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
      ],
    );
  }

  List<Widget> _buildHeaderFields(DamageReportFormState state, DamageCauseWizardState causeState, bool isReadOnly) {
    return [
      _buildFarmInfo(),
      const Divider(height: 32),
      _buildDateTile('Damage Date', _damageDate, isReadOnly ? null : (picked) => setState(() => _damageDate = picked)),
      _buildReadOnlyField('Documentation Date', DateFormat.yMMMd().format(_documentationDate)),
      const SizedBox(height: 16),
      _buildNatureSelector(isReadOnly),
      const SizedBox(height: 16),
      _buildCauseSelector(causeState, isReadOnly),
      const SizedBox(height: 16),
      TextFormField(
        controller: _notesController,
        readOnly: isReadOnly,
        decoration: const InputDecoration(
          labelText: 'Notes',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      const SizedBox(height: 32),
      if (!isReadOnly)
        ElevatedButton(
          onPressed: state.isLoading ? null : () => _save(),
          child: state.isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save & Next'),
        )
      else
        ElevatedButton(
          onPressed: () => setState(() => _currentStep = 1),
          child: const Text('View Assessment'),
        ),
    ];
  }

  List<Widget> _buildAssessmentFields(DamageReportFormState state, bool isReadOnly) {
    return [
      _buildReportNumberHeader(),
      const SizedBox(height: 24),
      _buildItemsHeader(isReadOnly),
      const SizedBox(height: 8),
      if (_items.isEmpty)
        const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No damage items added yet.')))
      else
        ..._items.map((item) => _buildItemTile(item, isReadOnly)),
      const SizedBox(height: 24),
      _buildValuationSummary(),
      const SizedBox(height: 32),
      if (!isReadOnly) ...[
        ElevatedButton(
          onPressed: state.isLoading ? null : () => _save(),
          child: state.isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save Draft'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: state.isLoading || _items.isEmpty ? null : () => _confirmSubmit(),
          child: const Text('Submit for Review'),
        ),
      ],
      const SizedBox(height: 12),
      TextButton(
        onPressed: () => setState(() => _currentStep = 0),
        child: const Text('Back to Header'),
      ),
    ];
  }

  Widget _buildReportNumberHeader() {
    final number = _activeReport?.reportNumber;
    final display = (number == null || number.isEmpty) ? 'PENDING SYNC' : number;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          const Text('Official Report Number', style: TextStyle(fontSize: 12, color: Colors.green)),
          Text(display, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
        ],
      ),
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

  Widget _buildNatureSelector(bool isReadOnly) {
    final naturesAsync = ref.watch(naturesProvider);
    return naturesAsync.when(
      data: (items) => DropdownButtonFormField<DamageNature>(
        value: _selectedNature,
        decoration: const InputDecoration(labelText: 'Damage Nature', border: OutlineInputBorder()),
        items: items.map((n) => DropdownMenuItem(value: n, child: Text(n.nameAr))).toList(),
        onChanged: isReadOnly ? null : (val) => setState(() => _selectedNature = val),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => Text('Error loading natures: $err'),
    );
  }

  Widget _buildCauseSelector(DamageCauseWizardState state, bool isReadOnly) {
    return InkWell(
      onTap: isReadOnly ? null : _showCauseSelector,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isReadOnly ? Colors.grey[300]! : Colors.grey),
          borderRadius: BorderRadius.circular(4),
          color: isReadOnly ? Colors.grey[100] : null,
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: isReadOnly ? Colors.grey : null),
                    )
                  else
                    const Text('Select Cause', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (!isReadOnly) const Icon(Icons.arrow_drop_down),
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

  Widget _buildItemsHeader(bool isReadOnly) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Damage Assessment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!isReadOnly)
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => _addItem(),
          ),
      ],
    );
  }

  Widget _buildItemTile(DamageItem item, bool isReadOnly) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.measurementUnitSnapshot),
        subtitle: Text('Quantity: ${item.quantity}, Loss: ${item.estimatedLoss}'),
        trailing: !isReadOnly ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _addItem(existingItem: item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _items.remove(item)),
            ),
          ],
        ) : null,
      ),
    );
  }

  Widget _buildValuationSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Technical Valuation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${_totalEstimatedLoss.toStringAsFixed(2)} EUR',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile(String label, DateTime date, Function(DateTime)? onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(DateFormat.yMMMd().format(date)),
      trailing: onPicked != null ? const Icon(Icons.calendar_today) : null,
      onTap: onPicked != null ? () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onPicked(picked);
      } : null,
    );
  }

  void _addItem({DamageItem? existingItem}) async {
    final result = await showModalBottomSheet<DamageItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DamageItemFormSheet(
        reportId: _localId,
        nature: _selectedNature!,
        existingItem: existingItem,
      ),
    );

    if (result != null) {
      setState(() {
        if (existingItem != null) {
          final index = _items.indexOf(existingItem);
          _items[index] = result;
        } else {
          _items.add(result);
        }
      });
    }
  }

  void _confirmSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit this report for review? It will become read-only.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _save(submit: true);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
