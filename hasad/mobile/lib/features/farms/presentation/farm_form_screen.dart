import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmFormScreen extends ConsumerStatefulWidget {
  final Farmer farmer;
  final Farm? farm;

  const FarmFormScreen({super.key, required this.farmer, this.farm});

  @override
  ConsumerState<FarmFormScreen> createState() => _FarmFormScreenState();
}

class _FarmFormScreenState extends ConsumerState<FarmFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _basinController;
  late TextEditingController _parcelController;
  late TextEditingController _areaController;
  late TextEditingController _notesController;

  // Selected values
  String? _selectedGovernorateId;
  String? _selectedDirectorateId;
  String? _selectedLocalityId;
  int? _selectedOwnershipTypeId;
  String? _selectedOwnerFarmerId;
  Farmer? _selectedOwnerFarmer;
  int? _selectedRelationshipToOwnerId;
  int? _selectedAreaUnitId;
  int? _selectedAgriculturalSectorId;
  int? _selectedPoliticalClassificationId;

  // Scoping flags
  bool _isGovReadOnly = false;
  bool _isDirReadOnly = false;

  @override
  void initState() {
    super.initState();
    final f = widget.farm;
    _nameController = TextEditingController(text: f?.localFarmName);
    _basinController = TextEditingController(text: f?.basin);
    _parcelController = TextEditingController(text: f?.parcel);
    _areaController = TextEditingController(text: f?.area.toString() ?? '');
    _notesController = TextEditingController(text: f?.notes);

    _selectedGovernorateId = f?.governorateId;
    _selectedDirectorateId = f?.directorateId;
    _selectedLocalityId = f?.localityId;
    _selectedOwnershipTypeId = f?.ownershipTypeId ?? 1;
    _selectedOwnerFarmerId = f?.ownerFarmerId;
    _selectedRelationshipToOwnerId = f?.relationshipToOwnerId;

    if (_selectedOwnerFarmerId != null) {
      _loadOwnerFarmer();
    }
    _selectedAreaUnitId = f?.areaUnitId ?? 1;
    _selectedAgriculturalSectorId = f?.agriculturalSectorId ?? 1;
    _selectedPoliticalClassificationId = f?.politicalClassificationId ?? 1;

    // Apply scoping logic on init if creating new farm
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyScoping();
    });
  }

  void _applyScoping() {
    final session = ref.read(authProvider).session;
    if (session == null) return;

    final roles = session.roles;
    if (roles.contains('AgriculturalEngineer') || roles.contains('FieldSurveyor')) {
      setState(() {
        if (widget.farm == null) {
          _selectedGovernorateId = session.governorateId;
          _selectedDirectorateId = session.directorateId;
        }
        _isGovReadOnly = true;
        _isDirReadOnly = true;
      });
    } else if (roles.contains('Director')) {
      setState(() {
        if (widget.farm == null) {
          _selectedGovernorateId = session.governorateId;
        }
        _isGovReadOnly = true;
      });
    }
  }

  Future<void> _loadOwnerFarmer() async {
    if (_selectedOwnerFarmerId == null) return;
    try {
      final farmer = await ref.read(farmerRepositoryProvider).getFarmer(_selectedOwnerFarmerId!);
      if (mounted) {
        setState(() => _selectedOwnerFarmer = farmer);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basinController.dispose();
    _parcelController.dispose();
    _areaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final farm = Farm(
      id: widget.farm?.id ?? '',
      serverId: widget.farm?.serverId,
      farmerId: widget.farmer.id,
      localFarmName: _nameController.text.trim(),
      ownershipTypeId: _selectedOwnershipTypeId ?? 1,
      ownerFarmerId: _selectedOwnerFarmerId,
      relationshipToOwnerId: _selectedRelationshipToOwnerId,
      governorateId: _selectedGovernorateId ?? '',
      directorateId: _selectedDirectorateId ?? '',
      localityId: _selectedLocalityId ?? '',
      basin: _basinController.text.trim(),
      parcel: _parcelController.text.trim(),
      area: double.tryParse(_areaController.text) ?? 0,
      areaUnitId: _selectedAreaUnitId ?? 1,
      agriculturalSectorId: _selectedAgriculturalSectorId ?? 1,
      politicalClassificationId: _selectedPoliticalClassificationId ?? 1,
      notes: _notesController.text.trim(),
      rowVersion: widget.farm?.rowVersion ?? '',
      syncStatus: widget.farm?.syncStatus ?? 'pending',
    );

    if (widget.farm == null) {
      await ref.read(farmFormProvider.notifier).createFarm(farm);
    } else {
      await ref.read(farmFormProvider.notifier).updateFarm(farm);
    }

    if (mounted && ref.read(farmFormProvider).success) {
      ref.invalidate(farmsListByFarmerProvider(widget.farmer.id));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.farm == null
                ? AppLocalizations.of(context)!.farmCreatedSuccessfully
                : AppLocalizations.of(context)!.farmUpdatedSuccessfully,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final state = ref.watch(farmFormProvider);

    // Location Lookups
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = _selectedGovernorateId != null
        ? ref.watch(directoratesProvider(_selectedGovernorateId))
        : const AsyncValue<List<Directorate>>.data([]);
    final locAsync = _selectedDirectorateId != null
        ? ref.watch(localitiesProvider((_selectedGovernorateId, _selectedDirectorateId)))
        : const AsyncValue<List<Locality>>.data([]);

    // Entity Lookups
    final ownershipAsync = ref.watch(ownershipTypesProvider);
    final sectorAsync = ref.watch(agriculturalSectorsProvider);
    final pClassAsync = ref.watch(politicalClassificationsProvider);
    final areaUnitsAsync = ref.watch(areaUnitsProvider);
    final relationshipAsync = ref.watch(relationshipToOwnersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farm == null ? l10n.addFarm : l10n.editFarm),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.errors.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.red.shade50,
                  child: Text(
                    state.errors.join('\n'),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              _buildSection(l10n.locationSection, [
                govAsync.when(
                  data: (items) => SearchableLookupField<Governorate>(
                    label: l10n.governorate,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedGovernorateId).firstOrNull,
                    enabled: !_isGovReadOnly,
                    onChanged: (v) => setState(() {
                      _selectedGovernorateId = v?.id;
                      _selectedDirectorateId = null;
                      _selectedLocalityId = null;
                    }),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
                const SizedBox(height: 16),
                dirAsync.when(
                  data: (items) => SearchableLookupField<Directorate>(
                    label: l10n.directorate,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedDirectorateId).firstOrNull,
                    enabled: !_isDirReadOnly && _selectedGovernorateId != null,
                    onChanged: (v) => setState(() {
                      _selectedDirectorateId = v?.id;
                      _selectedLocalityId = null;
                    }),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
                const SizedBox(height: 16),
                locAsync.when(
                  data: (items) => SearchableLookupField<Locality>(
                    label: l10n.locality,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedLocalityId).firstOrNull,
                    enabled: _selectedDirectorateId != null,
                    onChanged: (v) => setState(() => _selectedLocalityId = v?.id),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
              ]),

              _buildSection(l10n.farmInfoSection, [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.farmName),
                  validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _basinController,
                        decoration: InputDecoration(labelText: l10n.basin),
                        validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _parcelController,
                        decoration: InputDecoration(labelText: l10n.parcel),
                        validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
                      ),
                    ),
                  ],
                ),
              ]),

              _buildSection(l10n.areaAndSectorSection, [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _areaController,
                        decoration: InputDecoration(labelText: l10n.landArea),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.requiredField;
                          if (double.tryParse(v) == null || double.parse(v) <= 0) return l10n.invalidValue;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: areaUnitsAsync.when(
                        data: (items) => SearchableLookupField<AreaUnit>(
                          label: l10n.unit,
                          items: items,
                          itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                          value: items.where((i) => i.id == _selectedAreaUnitId).firstOrNull,
                          onChanged: (v) => setState(() => _selectedAreaUnitId = v?.id),
                          validator: (v) => v == null ? l10n.requiredField : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text(e.toString()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                sectorAsync.when(
                  data: (items) => SearchableLookupField<AgriculturalSector>(
                    label: l10n.agriculturalSector,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedAgriculturalSectorId).firstOrNull,
                    onChanged: (v) => setState(() => _selectedAgriculturalSectorId = v?.id),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
                const SizedBox(height: 16),
                pClassAsync.when(
                  data: (items) => SearchableLookupField<PoliticalClassification>(
                    label: l10n.politicalClassification,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedPoliticalClassificationId).firstOrNull,
                    onChanged: (v) => setState(() => _selectedPoliticalClassificationId = v?.id),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
              ]),

              _buildSection(l10n.ownershipSection, [
                ownershipAsync.when(
                  data: (items) => SearchableLookupField<OwnershipType>(
                    label: l10n.ownershipType,
                    items: items,
                    itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                    value: items.where((i) => i.id == _selectedOwnershipTypeId).firstOrNull,
                    onChanged: (v) => setState(() {
                      _selectedOwnershipTypeId = v?.id;
                      if (v?.id == 1) {
                        _selectedOwnerFarmerId = null;
                        _selectedRelationshipToOwnerId = null;
                      }
                    }),
                    validator: (v) => v == null ? l10n.requiredField : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
                if (_selectedOwnershipTypeId != null && _selectedOwnershipTypeId != 1) ...[
                  const SizedBox(height: 16),
                  _buildOwnerFarmerSearch(),
                  const SizedBox(height: 16),
                  relationshipAsync.when(
                    data: (items) => SearchableLookupField<RelationshipToOwner>(
                      label: l10n.relationshipToOwner,
                      items: items,
                      itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                      value: items.where((i) => i.id == _selectedRelationshipToOwnerId).firstOrNull,
                      onChanged: (v) => setState(() => _selectedRelationshipToOwnerId = v?.id),
                      validator: (v) => v == null ? l10n.requiredField : null,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                  ),
                ],
              ]),

              _buildSection(l10n.notes, [
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: l10n.notes),
                  maxLines: 3,
                ),
              ]),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isLoading ? null : _save,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : Text(l10n.save, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerFarmerSearch() {
    final l10n = AppLocalizations.of(context)!;
    
    return SearchableLookupField<Farmer>(
      label: l10n.ownerFarmer,
      items: const [],
      onSearch: (text) async {
         return await ref.read(farmerRepositoryProvider).getFarmers(name: text, idNumber: text);
      },
      itemLabel: (f) => "${f.firstNameAr} ${f.familyNameAr} (${f.idNumber})",
      value: _selectedOwnerFarmer,
      onChanged: (v) => setState(() {
        _selectedOwnerFarmer = v;
        _selectedOwnerFarmerId = v?.id;
      }),
      validator: (v) => (_selectedOwnershipTypeId != 1 && _selectedOwnerFarmerId == null) ? l10n.requiredField : null,
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
