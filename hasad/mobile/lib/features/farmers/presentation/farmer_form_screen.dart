import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/core/utils/validators.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmerFormScreen extends ConsumerStatefulWidget {
  final Farmer? farmer;
  final String? initialIdNumber;
  final bool isSubWorkflow;

  const FarmerFormScreen({
    super.key,
    this.farmer,
    this.initialIdNumber,
    this.isSubWorkflow = false,
  });

  @override
  ConsumerState<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends ConsumerState<FarmerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _firstNameArController;
  late TextEditingController _fatherNameArController;
  late TextEditingController _grandfatherNameArController;
  late TextEditingController _familyNameArController;
  late TextEditingController _firstNameEnController;
  late TextEditingController _fatherNameEnController;
  late TextEditingController _grandfatherNameEnController;
  late TextEditingController _familyNameEnController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneController;
  late TextEditingController _familySizeController;
  late TextEditingController _addressController;

  // Other fields
  DateTime? _birthDate;
  Gender _gender = Gender.unspecified;
  int _idTypeId = 1;
  String? _selectedGovernorateId;
  String? _selectedLocalityId;

  bool _isFormValid = true;

  @override
  void initState() {
    super.initState();
    final f = widget.farmer;
    
    _firstNameArController = TextEditingController(text: f?.firstNameAr)..addListener(_updateValidationState);
    _fatherNameArController = TextEditingController(text: f?.fatherNameAr)..addListener(_updateValidationState);
    _grandfatherNameArController = TextEditingController(text: f?.grandfatherNameAr)..addListener(_updateValidationState);
    _familyNameArController = TextEditingController(text: f?.familyNameAr)..addListener(_updateValidationState);
    
    _firstNameEnController = TextEditingController(text: f?.firstNameEn)..addListener(_updateValidationState);
    _fatherNameEnController = TextEditingController(text: f?.fatherNameEn)..addListener(_updateValidationState);
    _grandfatherNameEnController = TextEditingController(text: f?.grandfatherNameEn)..addListener(_updateValidationState);
    _familyNameEnController = TextEditingController(text: f?.familyNameEn)..addListener(_updateValidationState);
    
    _idNumberController = TextEditingController(text: f?.idNumber ?? widget.initialIdNumber)..addListener(_updateValidationState);
    _phoneController = TextEditingController(text: f?.phoneNumber)..addListener(_updateValidationState);
    _familySizeController = TextEditingController(text: f?.familySize.toString() ?? '1')..addListener(_updateValidationState);
    _addressController = TextEditingController(text: f?.address)..addListener(_updateValidationState);
    
    _birthDate = f?.birthDate;
    _gender = f?.gender ?? Gender.unspecified;
    _idTypeId = f?.idTypeId ?? 1;
    _selectedGovernorateId = f?.governorateId;
    _selectedLocalityId = f?.localityId;
  }

  void _updateValidationState() {
    if (_formKey.currentState == null) return;
    final isValid = _formKey.currentState!.validate();
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _firstNameArController.dispose();
    _fatherNameArController.dispose();
    _grandfatherNameArController.dispose();
    _familyNameArController.dispose();
    _firstNameEnController.dispose();
    _fatherNameEnController.dispose();
    _grandfatherNameEnController.dispose();
    _familyNameEnController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _familySizeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1980),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isFormValid = false);
      return;
    }
    if (_birthDate == null) {
      setState(() => _isFormValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectDate)),
      );
      return;
    }

    final farmer = Farmer(
      id: widget.farmer?.id ?? '',
      serverId: widget.farmer?.serverId,
      idTypeId: _idTypeId,
      idNumber: _idNumberController.text.trim(),
      firstNameAr: _firstNameArController.text.trim(),
      fatherNameAr: _fatherNameArController.text.trim(),
      grandfatherNameAr: _grandfatherNameArController.text.trim(),
      familyNameAr: _familyNameArController.text.trim(),
      firstNameEn: _firstNameEnController.text.trim(),
      fatherNameEn: _fatherNameEnController.text.trim(),
      grandfatherNameEn: _grandfatherNameEnController.text.trim(),
      familyNameEn: _familyNameEnController.text.trim(),
      birthDate: _birthDate!,
      gender: _gender,
      phoneNumber: _phoneController.text.trim(),
      familySize: int.tryParse(_familySizeController.text) ?? 1,
      governorateId: _selectedGovernorateId,
      localityId: _selectedLocalityId,
      legacyGovernorateId: widget.farmer?.legacyGovernorateId ?? '',
      legacyLocalityId: widget.farmer?.legacyLocalityId ?? '',
      address: _addressController.text.trim(),
      rowVersion: widget.farmer?.rowVersion ?? '',
      syncStatus: widget.farmer?.syncStatus ?? 'pending',
    );

    if (widget.farmer == null) {
      await ref.read(farmerFormProvider.notifier).createFarmer(farmer);
    } else {
      await ref.read(farmerFormProvider.notifier).updateFarmer(farmer);
    }

    if (mounted && ref.read(farmerFormProvider).success) {
      final message = widget.farmer == null
          ? AppLocalizations.of(context)!.farmerCreatedSuccessfully
          : AppLocalizations.of(context)!.farmerUpdatedSuccessfully;
      
      ref.invalidate(farmersListProvider);
      if (widget.farmer != null) {
        ref.invalidate(farmerProvider(widget.farmer!.id));
      }

      final createdFarmer = ref.read(farmerFormProvider).farmer;
      
      // Return the created/updated farmer to the previous screen
      if (mounted) {
        Navigator.of(context).pop(createdFarmer);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(farmerFormProvider);
    final govsAsync = ref.watch(governoratesProvider);
    
    final locsAsync = _selectedGovernorateId != null
        ? ref.watch(localitiesProvider((_selectedGovernorateId, null)))
        : const AsyncValue<List<Locality>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmer == null ? l10n.addFarmer : l10n.editFarmer),
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
              
              _buildSection(
                l10n.identitySection,
                [
                  DropdownButtonFormField<int>(
                    initialValue: _idTypeId,
                    decoration: InputDecoration(labelText: l10n.idType),
                    items: [
                      DropdownMenuItem(value: 1, child: Text(l10n.nationalId)),
                      DropdownMenuItem(value: 2, child: Text(l10n.jerusalemId)),
                      DropdownMenuItem(value: 3, child: Text(l10n.passport)),
                    ],
                    onChanged: (v) => setState(() => _idTypeId = v ?? 1),
                    validator: (v) => (v == null || v == 0) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idNumberController,
                    decoration: InputDecoration(labelText: l10n.idNumber),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      final id = v.trim();
                      switch (_idTypeId) {
                        case 1:
                          if (!Validators.isValidPalestinianId(id)) {
                            return l10n.invalidPalestinianId;
                          }
                          break;
                        case 2:
                          if (!Validators.isNumeric(id)) {
                            return l10n.mustBeNumeric;
                          }
                          break;
                        case 3:
                          if (!Validators.isAlphanumeric(id)) {
                            return l10n.mustBeAlphanumeric;
                          }
                          break;
                      }
                      return null;
                    },
                  ),
                ],
              ),

              _buildSection(
                l10n.arabicNameSection,
                [
                  TextFormField(
                    controller: _firstNameArController,
                    decoration: InputDecoration(labelText: l10n.firstName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fatherNameArController,
                    decoration: InputDecoration(labelText: l10n.secondName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _grandfatherNameArController,
                    decoration: InputDecoration(labelText: l10n.thirdName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _familyNameArController,
                    decoration: InputDecoration(labelText: l10n.fourthName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                ],
              ),

              _buildSection(
                l10n.englishNameSection,
                [
                  TextFormField(
                    controller: _firstNameEnController,
                    decoration: InputDecoration(labelText: l10n.firstName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fatherNameEnController,
                    decoration: InputDecoration(labelText: l10n.secondName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _grandfatherNameEnController,
                    decoration: InputDecoration(labelText: l10n.thirdName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _familyNameEnController,
                    decoration: InputDecoration(labelText: l10n.fourthName),
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                ],
              ),

              _buildSection(
                l10n.demographicsSection,
                [
                  InkWell(
                    onTap: _selectDate,
                    child: FormField<DateTime>(
                      initialValue: _birthDate,
                      validator: (v) {
                        if (_birthDate == null) return l10n.requiredField;
                        if (!Validators.isAtLeast18(_birthDate!)) {
                          return l10n.mustBe18;
                        }
                        if (_birthDate!.isAfter(DateTime.now())) {
                          return l10n.cannotBeInFuture;
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                labelText: l10n.dateOfBirth,
                                suffixIcon: const Icon(Icons.calendar_today),
                                errorText: state.errorText,
                              ),
                              child: Text(
                                _birthDate == null 
                                    ? l10n.selectDate 
                                    : DateFormat.yMd(Localizations.localeOf(context).toString()).format(_birthDate!),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Gender>(
                    initialValue: _gender,
                    decoration: InputDecoration(labelText: l10n.gender),
                    items: [
                      DropdownMenuItem(value: Gender.unspecified, child: Text(l10n.unspecified)),
                      DropdownMenuItem(value: Gender.male, child: Text(l10n.male)),
                      DropdownMenuItem(value: Gender.female, child: Text(l10n.female)),
                    ],
                    onChanged: (v) => setState(() => _gender = v ?? Gender.unspecified),
                    validator: (v) => (v == null || v == Gender.unspecified) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: l10n.mobileNumber),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _familySizeController,
                    decoration: InputDecoration(labelText: l10n.familySize),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      final size = int.tryParse(v);
                      if (size == null || size < 1) return l10n.invalidFamilySize;
                      return null;
                    },
                  ),
                ],
              ),

              _buildSection(
                l10n.personalAddressSection,
                [
                  govsAsync.when(
                    data: (govs) => SearchableLookupField<Governorate>(
                      label: l10n.governorate,
                      items: govs,
                      itemLabel: (g) => Localizations.localeOf(context).languageCode == 'ar' ? g.nameAr : g.nameEn,
                      value: govs.where((g) => g.id == _selectedGovernorateId).firstOrNull,
                      onChanged: (v) => setState(() {
                        _selectedGovernorateId = v?.id;
                        _selectedLocalityId = null;
                      }),
                      validator: (v) => v == null ? l10n.requiredField : null,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                  ),
                  const SizedBox(height: 16),
                  _selectedGovernorateId == null
                      ? InputDecorator(
                          decoration: InputDecoration(labelText: l10n.village),
                          child: Text(l10n.governorate),
                        )
                      : locsAsync.when(
                          data: (locs) => SearchableLookupField<Locality>(
                            label: l10n.village,
                            items: locs,
                            itemLabel: (d) => Localizations.localeOf(context).languageCode == 'ar' ? d.nameAr : d.nameEn,
                            value: locs.where((d) => d.id == _selectedLocalityId).firstOrNull,
                            onChanged: (v) => setState(() => _selectedLocalityId = v?.id),
                            validator: (v) => v == null ? l10n.requiredField : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text(e.toString()),
                        ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: l10n.address),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for persistent button
            ],
          ),
        ),
      ),
      bottomNavigationBar: FormSaveFooter(
        isLoading: state.isLoading,
        isValid: _isFormValid,
        onSave: _save,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }
}
