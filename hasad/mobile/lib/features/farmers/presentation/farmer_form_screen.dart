import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'package:mobile/features/farmers/domain/gender.dart';

class FarmerFormScreen extends ConsumerStatefulWidget {
  final Farmer? farmer;
  final String? initialIdNumber;

  const FarmerFormScreen({super.key, this.farmer, this.initialIdNumber});

  @override
  ConsumerState<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends ConsumerState<FarmerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nationalIdController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.farmer?.name);
    _nationalIdController = TextEditingController(
      text: widget.farmer?.nationalId ?? widget.initialIdNumber,
    );
    _phoneController = TextEditingController(text: widget.farmer?.phoneNumber);
    _addressController = TextEditingController(text: widget.farmer?.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final farmer = Farmer(
      id: widget.farmer?.id ?? '',
      serverId: widget.farmer?.serverId,
      idTypeId: widget.farmer?.idTypeId ?? 1,
      idNumber: _nationalIdController.text.trim(),
      firstNameAr: widget.farmer?.firstNameAr ?? _nameController.text.trim(),
      fatherNameAr: widget.farmer?.fatherNameAr ?? '',
      grandfatherNameAr: widget.farmer?.grandfatherNameAr ?? '',
      familyNameAr: widget.farmer?.familyNameAr ?? '',
      firstNameEn: widget.farmer?.firstNameEn ?? '',
      fatherNameEn: widget.farmer?.fatherNameEn ?? '',
      grandfatherNameEn: widget.farmer?.grandfatherNameEn ?? '',
      familyNameEn: widget.farmer?.familyNameEn ?? '',
      birthDate: widget.farmer?.birthDate ?? DateTime(1900),
      gender: widget.farmer?.gender ?? Gender.unspecified,
      phoneNumber: _phoneController.text.trim(),
      familySize: widget.farmer?.familySize ?? 1,
      governorateId: widget.farmer?.governorateId ?? '',
      localityId: widget.farmer?.localityId ?? '',
      address: _addressController.text.trim(),
      rowVersion: widget.farmer?.rowVersion ?? '',
    );

    if (widget.farmer == null) {
      await ref.read(farmerFormProvider.notifier).createFarmer(farmer);
    } else {
      await ref.read(farmerFormProvider.notifier).updateFarmer(farmer);
    }

    if (mounted && ref.read(farmerFormProvider).success) {
      ref.invalidate(farmersListProvider);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(farmerFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmer == null ? l10n.addFarmer : l10n.editFarmer),
        actions: [
          if (widget.farmer != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: state.isLoading ? null : _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.errors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    state.errors.join('\n'),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.farmerName),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nationalIdController,
                decoration: InputDecoration(labelText: l10n.nationalId),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: l10n.phoneNumber),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: l10n.address),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isLoading ? null : _save,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(farmerFormProvider.notifier)
          .deleteFarmer(widget.farmer!.id);
      if (mounted && ref.read(farmerFormProvider).success) {
        ref.invalidate(farmersListProvider);
        Navigator.of(context).pop();
      }
    }
  }
}
