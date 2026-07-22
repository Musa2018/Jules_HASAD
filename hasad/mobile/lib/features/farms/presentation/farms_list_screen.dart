import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/farms/presentation/widgets/farm_card.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmsListScreen extends ConsumerStatefulWidget {
  final Farmer? farmer;

  const FarmsListScreen({super.key, this.farmer});

  @override
  ConsumerState<FarmsListScreen> createState() => _FarmsListScreenState();
}

class _FarmsListScreenState extends ConsumerState<FarmsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If a farmer is passed, we should initialize the filter with that farmer context if possible.
    // However, our FarmFilter doesn't have farmerId yet. 
    // Usually, we'd add it or handle it in the provider.
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final farmsAsync = ref.watch(farmsListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmer != null 
            ? "${l10n.farms}: ${widget.farmer!.fullName}"
            : l10n.farms),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: farmsAsync.when(
              data: (farms) {
                // Filter by farmer locally if needed, or update FarmFilter to support farmerId
                final displayFarms = widget.farmer != null 
                    ? farms.where((f) => f.farmerId == widget.farmer!.id).toList()
                    : farms;

                if (displayFarms.isEmpty) {
                  return Center(child: Text(l10n.noFarms));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: displayFarms.length,
                  itemBuilder: (context, index) => FarmCard(farm: displayFarms[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.errorLoadingFarms)),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.farmer != null ? FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addFarm, extra: widget.farmer),
        tooltip: l10n.addFarm,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(farmFilterProvider.notifier).update(
                            (s) => s.copyWith(searchText: ''));
                      },
                    )
                  : null,
            ),
            onChanged: (v) {
              ref.read(farmFilterProvider.notifier).update(
                  (s) => s.copyWith(searchText: v));
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.ownershipType,
                  isActive: ref.watch(farmFilterProvider).ownershipTypeId != null,
                  onTap: () => _showFilterSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.agriculturalSector,
                  isActive: ref.watch(farmFilterProvider).agriculturalSectorId != null,
                  onTap: () => _showFilterSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.syncStatus,
                  isActive: ref.watch(farmFilterProvider).syncStatus != null,
                  onTap: () => _showFilterSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _FarmFilterSheet(),
    );
  }
}

class _FarmFilterSheet extends ConsumerStatefulWidget {
  const _FarmFilterSheet();

  @override
  ConsumerState<_FarmFilterSheet> createState() => _FarmFilterSheetState();
}

class _FarmFilterSheetState extends ConsumerState<_FarmFilterSheet> {
  late FarmFilter _localFilter;

  @override
  void initState() {
    super.initState();
    _localFilter = ref.read(farmFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Lookups
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = _localFilter.governorateId != null
        ? ref.watch(directoratesProvider(_localFilter.governorateId))
        : const AsyncValue<List<Directorate>>.data([]);
    final locAsync = _localFilter.directorateId != null
        ? ref.watch(localitiesProvider((_localFilter.governorateId, _localFilter.directorateId)))
        : const AsyncValue<List<Locality>>.data([]);

    final ownershipAsync = ref.watch(ownershipTypesProvider);
    final sectorAsync = ref.watch(agriculturalSectorsProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.search, style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  setState(() => _localFilter = const FarmFilter());
                },
                child: Text(l10n.all),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  govAsync.when(
                    data: (items) => SearchableLookupField<Governorate>(
                      label: l10n.governorate,
                      items: items,
                      itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                      value: items.where((i) => i.id == _localFilter.governorateId).firstOrNull,
                      onChanged: (v) => setState(() {
                        _localFilter = _localFilter.copyWith(
                          governorateId: v?.id,
                          directorateId: null,
                          localityId: null,
                        );
                      }),
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
                      value: items.where((i) => i.id == _localFilter.directorateId).firstOrNull,
                      enabled: _localFilter.governorateId != null,
                      onChanged: (v) => setState(() {
                        _localFilter = _localFilter.copyWith(
                          directorateId: v?.id,
                          localityId: null,
                        );
                      }),
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
                      value: items.where((i) => i.id == _localFilter.localityId).firstOrNull,
                      enabled: _localFilter.directorateId != null,
                      onChanged: (v) => setState(() {
                        _localFilter = _localFilter.copyWith(localityId: v?.id);
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                  ),
                  const SizedBox(height: 16),
                  ownershipAsync.when(
                    data: (items) => SearchableLookupField<OwnershipType>(
                      label: l10n.ownershipType,
                      items: items,
                      itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                      value: items.where((i) => i.id == _localFilter.ownershipTypeId).firstOrNull,
                      onChanged: (v) => setState(() {
                        _localFilter = _localFilter.copyWith(ownershipTypeId: v?.id);
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                  ),
                  const SizedBox(height: 16),
                  sectorAsync.when(
                    data: (items) => SearchableLookupField<AgriculturalSector>(
                      label: l10n.agriculturalSector,
                      items: items,
                      itemLabel: (i) => isAr ? i.nameAr : i.nameEn,
                      value: items.where((i) => i.id == _localFilter.agriculturalSectorId).firstOrNull,
                      onChanged: (v) => setState(() {
                        _localFilter = _localFilter.copyWith(agriculturalSectorId: v?.id);
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _localFilter.syncStatus,
                    decoration: InputDecoration(labelText: l10n.syncStatus),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      DropdownMenuItem(value: 'completed', child: Text(l10n.synced)),
                      DropdownMenuItem(value: 'pending', child: Text(l10n.pendingSync)),
                      DropdownMenuItem(value: 'failed', child: Text(l10n.syncError)),
                    ],
                    onChanged: (v) => setState(() {
                      _localFilter = _localFilter.copyWith(syncStatus: v);
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(farmFilterProvider.notifier).state = _localFilter;
              Navigator.pop(context);
            },
            child: Text(l10n.search),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
