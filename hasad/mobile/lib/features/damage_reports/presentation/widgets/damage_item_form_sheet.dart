import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_item.dart';
import 'package:mobile/features/damage_reports/domain/services/valuation_engine.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_item_selection_provider.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/costing_item_selector.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class DamageItemFormSheet extends ConsumerStatefulWidget {
  final String reportId;
  final int sectorId;
  final DamageItem? existingItem;
  final int? lockedNatureId;

  const DamageItemFormSheet({
    super.key,
    required this.reportId,
    required this.sectorId,
    this.existingItem,
    this.lockedNatureId,
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
      
      // Initialize selection if editing (Optional: Future enhancement)
    }
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
    final state = ref.watch(damageItemSelectionProvider);
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
              child: state.selectedCosting == null
                  ? CostingItemSelector(scrollController: scrollController)
                  : _buildDetailsForm(state, l10n),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsForm(DamageItemSelectionState state, AppLocalizations l10n) {
    final costing = state.selectedCosting!;
    
    final unitAsync = costing.measurementUnitId != null
        ? ref.watch(measurementUnitByIdProvider(costing.measurementUnitId!))
        : const AsyncValue<MeasurementUnit?>.data(null);
    
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final unitName = unitAsync.when(
      data: (u) => u != null ? (isAr ? u.nameAr : u.nameEn) : 'Unit',
      loading: () => '...',
      error: (_, _) => 'Unit',
    );

    final estimatedLoss = ValuationEngine.calculateEstimatedLoss(
      quantity: _quantity,
      unitPrice: costing.unitPrice,
      damagePercentage: _percentage,
    );

    final actionsAsync = ref.watch(actionsProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSelectionPath(state, isAr),
                  const SizedBox(height: 24),
                  _buildPricingPreview(costing, l10n, unitName),
                  const SizedBox(height: 24),
                  actionsAsync.when(
                    data: (actions) => DropdownButtonFormField<DamageAction>(
                      initialValue: state.action,
                      decoration: InputDecoration(labelText: l10n.damageAction),
                      items: actions.map((a) => DropdownMenuItem(
                        value: a,
                        child: Text(isAr ? a.nameAr : a.nameEn),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(damageItemSelectionProvider.notifier).setAction(val);
                        }
                      },
                      validator: (v) => v == null ? l10n.requiredField : null,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => Text(l10n.noData),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: l10n.quantity,
                      suffixText: unitName,
                    ),
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
                ],
              ),
            ),
          ),
        ),
        FormSaveFooter(
          onSave: () => _save(unitName),
          isLoading: false,
          isValid: _formKey.currentState?.validate() ?? true,
        ),
        TextButton(
          onPressed: () => ref.read(damageItemSelectionProvider.notifier).reset(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildSelectionPath(DamageItemSelectionState state, bool isAr) {
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
            isAr ? state.classification!.nameAr : state.classification!.nameEn,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${isAr ? state.nature?.nameAr : state.nature?.nameEn} > ${isAr ? state.category?.nameAr : state.category?.nameEn} > ${isAr ? state.subCategory?.nameAr : state.subCategory?.nameEn}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingPreview(CostingSheetItem costing, AppLocalizations l10n, String unitName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.unitPriceSnapshot, style: const TextStyle(fontSize: 12)),
            Text(
              '${costing.unitPrice} EUR / $unitName',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Code', style: TextStyle(fontSize: 12)),
            Text(costing.code, style: const TextStyle(fontWeight: FontWeight.bold)),
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

    final state = ref.read(damageItemSelectionProvider);
    final costing = state.selectedCosting!;

    final item = DamageItem(
      id: widget.existingItem?.id ?? const Uuid().v4(),
      damageReportId: widget.reportId,
      damageNatureId: state.nature?.id ?? 0,
      damageActionId: state.action?.id ?? 0,
      classificationId: state.classification!.id,
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
