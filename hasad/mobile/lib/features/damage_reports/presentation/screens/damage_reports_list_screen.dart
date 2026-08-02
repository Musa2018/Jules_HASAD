import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/damage_reports/domain/models/damage_report_filter.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_reports_providers.dart';
import 'package:mobile/features/damage_reports/presentation/widgets/damage_report_card.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class DamageReportsListScreen extends ConsumerStatefulWidget {
  final Farm? farm;

  const DamageReportsListScreen({super.key, this.farm});

  @override
  ConsumerState<DamageReportsListScreen> createState() => _DamageReportsListScreenState();
}

class _DamageReportsListScreenState extends ConsumerState<DamageReportsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportsAsync = ref.watch(filteredDamageReportsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text(widget.farm != null
            ? '${l10n.damageReports}: ${widget.farm!.localFarmName}'
            : l10n.damageReportsForms),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(damageReportsListProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: reportsAsync.when(
              data: (reports) {
                final displayReports = widget.farm != null
                    ? reports.where((r) => r.farmId == widget.farm!.id).toList()
                    : reports;

                if (displayReports.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (widget.farm != null) {
                        await ref.read(damageReportRepositoryProvider).getDamageReportsByFarm(widget.farm!.id);
                      }
                      ref.invalidate(damageReportsListProvider);
                    },
                    child: Stack(
                      children: [
                        ListView(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              l10n.noData,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    if (widget.farm != null) {
                      await ref.read(damageReportRepositoryProvider).getDamageReportsByFarm(widget.farm!.id);
                    }
                    ref.invalidate(damageReportsListProvider);
                  },
                  child: ListView.builder(
                    itemCount: displayReports.length,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    itemBuilder: (context, index) {
                      return DamageReportCard(report: displayReports[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${l10n.errorLoadingDamageReports}: $err'),
                    TextButton(
                      onPressed: () => ref.refresh(damageReportsListProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.farm != null
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.addDamageReport, extra: widget.farm),
              icon: const Icon(Icons.add),
              label: Text(l10n.addDamageReport),
            )
          : null,
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
                        ref.read(damageReportFilterProvider.notifier).update(
                            (s) => s.copyWith(searchText: ''));
                      },
                    )
                  : null,
            ),
            onChanged: (v) {
              ref.read(damageReportFilterProvider.notifier).update(
                  (s) => s.copyWith(searchText: v));
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.status,
                  isActive: ref.watch(damageReportFilterProvider).statusId != null,
                  onTap: () => _showFilterSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.syncStatus,
                  isActive: ref.watch(damageReportFilterProvider).syncStatus != null,
                  onTap: () => _showFilterSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.governorate,
                  isActive: ref.watch(damageReportFilterProvider).governorateId != null,
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
      builder: (context) => const _DamageReportFilterSheet(),
    );
  }
}

class _DamageReportFilterSheet extends ConsumerStatefulWidget {
  const _DamageReportFilterSheet();

  @override
  ConsumerState<_DamageReportFilterSheet> createState() => _DamageReportFilterSheetState();
}

class _DamageReportFilterSheetState extends ConsumerState<_DamageReportFilterSheet> {
  late DamageReportFilter _localFilter;

  @override
  void initState() {
    super.initState();
    _localFilter = ref.read(damageReportFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Location lookups
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = _localFilter.governorateId != null
        ? ref.watch(directoratesProvider(_localFilter.governorateId))
        : const AsyncValue<List<Directorate>>.data([]);
    final locAsync = _localFilter.directorateId != null
        ? ref.watch(localitiesProvider((_localFilter.governorateId, _localFilter.directorateId)))
        : const AsyncValue<List<Locality>>.data([]);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.search, style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  setState(() => _localFilter = const DamageReportFilter());
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
                  DropdownButtonFormField<String>(
                    initialValue: _localFilter.statusId,
                    decoration: InputDecoration(labelText: l10n.status),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      DropdownMenuItem(value: 'Draft', child: Text(l10n.status_Draft)),
                      DropdownMenuItem(value: 'TechReview', child: Text(l10n.status_TechReview)),
                      DropdownMenuItem(value: 'Completed', child: Text(l10n.status_Completed)),
                    ],
                    onChanged: (v) => setState(() {
                      _localFilter = _localFilter.copyWith(statusId: v);
                    }),
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
              ref.read(damageReportFilterProvider.notifier).state = _localFilter;
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
