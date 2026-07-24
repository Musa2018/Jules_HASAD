import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/services/valuation_engine.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/classification_selector.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class DamageItemFormSheet extends ConsumerStatefulWidget {
  final String reportId;
  final DamageNature nature;
  final DamageItem? existingItem;

  const DamageItemFormSheet({
    super.key,
    required this.reportId,
    required this.nature,
    this.existingItem,
  });

  @override
  ConsumerState<DamageItemFormSheet> createState() => _DamageItemFormSheetState();
}

class _DamageItemFormSheetState extends ConsumerState<DamageItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _percentageController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _quantityController.text = widget.existingItem!.quantity.toString();
      _percentageController.text = widget.existingItem!.damagePercentage.toString();
      _areaController.text = widget.existingItem!.affectedArea.toString();
    }

    Future.microtask(() {
      ref.read(classificationWizardProvider.notifier).setNature(widget.nature);
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _percentageController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  double get _quantity => double.tryParse(_quantityController.text) ?? 0.0;
  double get _percentage => double.tryParse(_percentageController.text) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(classificationWizardProvider);
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.assessmentItem,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Divider(),
            Expanded(
              child: state.selectedClassification == null
                  ? const ClassificationSelector()
                  : _buildDetailsForm(state, l10n),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsForm(ClassificationWizardState state, AppLocalizations l10n) {
    final costing = state.resolvedCosting;
    
    final unitAsync = costing?.measurementUnitId != null
        ? ref.watch(measurementUnitByIdProvider(costing!.measurementUnitId!))
        : const AsyncValue<MeasurementUnit?>.data(null);
    
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final unitName = unitAsync.when(
      data: (u) => u != null ? (isAr ? u.nameAr : u.nameEn) : 'Unit',
      loading: () => '...',
      error: (_, __) => 'Unit',
    );

    final estimatedLoss = ValuationEngine.calculateEstimatedLoss(
      quantity: _quantity,
      unitPrice: costing?.unitPrice ?? 0.0,
      damagePercentage: _percentage,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectionPath(state),
            const SizedBox(height: 24),
            if (costing == null)
              _buildPricingMissingWarning(l10n)
            else
              _buildPricingPreview(costing, l10n),
            const SizedBox(height: 24),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: l10n.quantity),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _percentageController,
              decoration: InputDecoration(labelText: l10n.damagePercentage),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final val = double.tryParse(v ?? '');
                if (val == null) return l10n.requiredField;
                if (val < 0 || val > 100) return l10n.invalidValue;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(labelText: l10n.affectedAreaOptional),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            _buildValuationPreview(estimatedLoss, l10n),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: costing == null ? null : () => _save(unitName),
              child: Text(l10n.save),
            ),
            TextButton(
              onPressed: () => ref.read(classificationWizardProvider.notifier).reset(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionPath(ClassificationWizardState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.selectedClassification!.nameAr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${state.selectedNature!.nameAr} > ${state.selectedCategory!.nameAr} > ${state.selectedSubCategory!.nameAr}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingMissingWarning(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.pricingNotFound,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingPreview(dynamic costing, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.unitPriceSnapshot, style: const TextStyle(fontSize: 12)),
            Text(
              '${costing.unitPrice} EUR',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Version', style: TextStyle(fontSize: 12)),
            Text('Active v1.0', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildValuationPreview(double loss, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.technicalValuation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$loss EUR',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _save(String unitName) {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(classificationWizardProvider);
    final costing = state.resolvedCosting!;

    final item = DamageItem(
      id: widget.existingItem?.id ?? const Uuid().v4(),
      damageReportId: widget.reportId,
      classificationId: state.selectedClassification!.id,
      costingSheetId: costing.id,
      costingSheetItemId: costing.id,
      calculatedUnitPrice: costing.unitPrice,
      measurementUnitSnapshot: unitName,
      affectedArea: double.tryParse(_areaController.text) ?? 0.0,
      damagePercentage: _percentage,
      quantity: _quantity,
      estimatedLoss: ValuationEngine.calculateEstimatedLoss(
        quantity: _quantity,
        unitPrice: costing.unitPrice,
        damagePercentage: _percentage,
      ),
    );

    Navigator.of(context).pop(item);
  }
}
