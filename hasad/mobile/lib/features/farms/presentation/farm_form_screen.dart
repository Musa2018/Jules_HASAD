// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farmer_form_screen.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmFormScreen extends ConsumerStatefulWidget {
  final Farmer? farmer;
  final Farm? farm;

  const FarmFormScreen({super.key, this.farmer, this.farm})
      : assert(farmer != null || farm != null, 'Either farmer or farm must be provided');

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
  late TextEditingController _latController;
  late TextEditingController _lonController;

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

  Farmer? _resolvedFarmer;
  bool _isFormValid = true;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    final f = widget.farm;
    _nameController = TextEditingController(text: f?.localFarmName)..addListener(_updateValidationState);
    _basinController = TextEditingController(text: f?.basin)..addListener(_updateValidationState);
    _parcelController = TextEditingController(text: f?.parcel)..addListener(_updateValidationState);
    _areaController = TextEditingController(text: f?.area.toString() ?? '')..addListener(_updateValidationState);
    _notesController = TextEditingController(text: f?.notes)..addListener(_updateValidationState);
    _latController = TextEditingController(text: f?.latitude?.toString() ?? '')..addListener(_updateValidationState);
    _lonController = TextEditingController(text: f?.longitude?.toString() ?? '')..addListener(_updateValidationState);

    _selectedGovernorateId = f?.governorateId;
    _selectedDirectorateId = f?.directorateId;
    _selectedLocalityId = f?.localityId;
    _selectedOwnershipTypeId = f?.ownershipTypeId ?? 1;
    _selectedOwnerFarmerId = f?.ownerFarmerId;
    _selectedRelationshipToOwnerId = f?.relationshipToOwnerId;

    if (f == null && widget.farmer != null) {
       _selectedOwnerFarmerId = widget.farmer!.id;
       _selectedOwnerFarmer = widget.farmer;
    }

    if (_selectedOwnerFarmerId != null && _selectedOwnerFarmer == null) {
      _loadOwnerFarmer();
    }
    _selectedAreaUnitId = f?.areaUnitId ?? 1;
    _selectedAgriculturalSectorId = f?.agriculturalSectorId ?? 1;
    _selectedPoliticalClassificationId = f?.politicalClassificationId ?? 1;

    _resolvedFarmer = widget.farmer;
    if (_resolvedFarmer == null && f != null) {
      _loadOperatorFarmer(f.farmerId);
    }

    // Apply scoping logic on init if creating new farm
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyScoping();
    });
  }

  Future<void> _loadOperatorFarmer(String id) async {
    try {
      final farmer = await ref.read(farmerRepositoryProvider).getFarmer(id);
      if (mounted) {
        setState(() => _resolvedFarmer = farmer);
      }
    } catch (_) {}
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

  void _updateValidationState() {
    if (_formKey.currentState == null) return;
    final isValid = _formKey.currentState!.validate();
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basinController.dispose();
    _parcelController.dispose();
    _areaController.dispose();
    _notesController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isFormValid = false);
      return;
    }
    if (_resolvedFarmer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operator farmer not loaded.')),
      );
      return;
    }

    final farm = Farm(
      id: widget.farm?.id ?? '',
      serverId: widget.farm?.serverId,
      farmerId: _resolvedFarmer!.id,
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
      measurementUnitId: _selectedAreaUnitId,
      agriculturalSectorId: _selectedAgriculturalSectorId ?? 1,
      politicalClassificationId: _selectedPoliticalClassificationId ?? 1,
      latitude: double.tryParse(_latController.text),
      longitude: double.tryParse(_lonController.text),
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
      final result = ref.read(farmFormProvider).farm;
      ref.invalidate(farmsListByFarmerProvider(_resolvedFarmer!.id));
      
      if (widget.farm == null && result != null) {
        context.replace(AppRoutes.farmDetails, extra: result);
      } else {
        Navigator.of(context).pop();
      }

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
    
    if (_resolvedFarmer == null && widget.farm != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editFarm)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                    errorText: (items.isEmpty && _selectedDirectorateId != null) ? l10n.noData : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => SearchableLookupField<Locality>(
                    label: l10n.locality,
                    items: const [],
                    itemLabel: (_) => '',
                    onChanged: (_) {},
                    enabled: false,
                    errorText: l10n.noData,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGisSection(l10n),
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
                          label: l10n.measurementUnit,
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

  Widget _buildOwnerFarmerSearch() {
    final l10n = AppLocalizations.of(context)!;
    
    return SearchableLookupField<Farmer>(
      label: l10n.ownerFarmer,
      items: const [],
      onSearch: (text) async {
         return await ref.read(farmerRepositoryProvider).getFarmers(searchText: text);
      },
      actionLabel: l10n.addNewFarmerAction,
      onAction: () async {
        final result = await Navigator.of(context).push<Farmer>(
          MaterialPageRoute(builder: (context) => const FarmerFormScreen(isSubWorkflow: true)),
        );
        if (result != null) {
          setState(() {
            _selectedOwnerFarmer = result;
            _selectedOwnerFarmerId = result.id;
          });
        }
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

  Widget _buildGisSection(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latController,
                decoration: InputDecoration(
                  labelText: l10n.latitude,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _lonController,
                decoration: InputDecoration(
                  labelText: l10n.longitude,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isFetchingLocation ? null : _getCurrentLocation,
          icon: _isFetchingLocation 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.my_location),
          label: Text(_isFetchingLocation ? 'جاري البحث...' : l10n.getCurrentLocation),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled. Please enable GPS.')),
          );
        }
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
          );
        }
        return;
      }

      // 1. Try last known position first (fast and safe)
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        setState(() {
          _latController.text = lastKnown.latitude.toStringAsFixed(6);
          _lonController.text = lastKnown.longitude.toStringAsFixed(6);
        });
      }

      // 2. Request fresh position with strict timeout to avoid ANR
      // Use LocationAccuracy.medium for better compatibility on emulators
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, 
        timeLimit: const Duration(seconds: 25),
      );
      
      if (mounted) {
        setState(() {
          _latController.text = position.latitude.toStringAsFixed(6);
          _lonController.text = position.longitude.toStringAsFixed(6);
        });
      }
    } on TimeoutException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location request timed out. Using last known position if available.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
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
