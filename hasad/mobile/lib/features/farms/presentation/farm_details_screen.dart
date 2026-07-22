import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_sync_status_badge.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmDetailsScreen extends ConsumerWidget {
  final Farm farm;

  const FarmDetailsScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Watch reactive data to avoid stale RowVersion
    final farmAsync = ref.watch(farmStreamProvider(farm.id));
    
    return farmAsync.when(
      data: (f) {
        final currentFarm = f ?? farm;
        return Scaffold(
          appBar: AppBar(
            title: Text(currentFarm.localFarmName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _navigateToEdit(context, ref, currentFarm),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSyncHeader(context, currentFarm),
                const SizedBox(height: 24),
                _buildSection(context, l10n.farmInfoSection, [
                  _DetailRow(label: l10n.farmName, value: currentFarm.localFarmName),
                  _buildFarmerRow(ref, l10n.farmerName, currentFarm.farmerId),
                  if (currentFarm.ownerFarmerId != null)
                    _buildFarmerRow(ref, l10n.ownerFarmer, currentFarm.ownerFarmerId!),
                  _buildOwnershipRow(ref, l10n.ownershipType, currentFarm.ownershipTypeId),
                ]),
                _buildSection(context, l10n.areaAndSectorSection, [
                  _buildSectorRow(ref, l10n.agriculturalSector, currentFarm.agriculturalSectorId),
                  _buildAreaRow(ref, l10n.landArea, currentFarm.area, currentFarm.areaUnitId),
                  _buildPoliticalRow(ref, l10n.politicalClassification, currentFarm.politicalClassificationId),
                ]),
                _buildSection(context, l10n.locationSection, [
                  _buildLocationDetails(ref, currentFarm),
                  _DetailRow(label: l10n.basin, value: currentFarm.basin),
                  _DetailRow(label: l10n.parcel, value: currentFarm.parcel),
                ]),
                if (currentFarm.notes != null && currentFarm.notes!.isNotEmpty)
                  _buildSection(context, l10n.notes, [
                    Text(currentFarm.notes!),
                  ]),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.damageReports, extra: currentFarm),
                  icon: const Icon(Icons.report_problem_outlined),
                  label: Text(l10n.damageReports),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  void _navigateToEdit(BuildContext context, WidgetRef ref, Farm currentFarm) async {
    final operator = await ref.read(farmerRepositoryProvider).getFarmer(currentFarm.farmerId);
    if (context.mounted) {
      context.push(AppRoutes.editFarm, extra: {'farmer': operator, 'farm': currentFarm});
    }
  }

  Widget _buildSyncHeader(BuildContext context, Farm farm) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.syncStatus, style: Theme.of(context).textTheme.titleMedium),
                FarmerSyncStatusBadge(status: farm.syncStatus),
              ],
            ),
            if (farm.lastSyncError != null) ...[
              const Divider(height: 24),
              Text(
                farm.lastSyncError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFarmerRow(WidgetRef ref, String label, String id) {
    final farmerAsync = ref.watch(farmerProvider(id));
    return _DetailRow(
      label: label,
      value: farmerAsync.when(
        data: (f) => f.fullName,
        loading: () => "...",
        error: (_, _) => id,
      ),
    );
  }

  Widget _buildOwnershipRow(WidgetRef ref, String label, int id) {
    final typesAsync = ref.watch(ownershipTypesProvider);
    final isAr = Localizations.localeOf(ref.context).languageCode == 'ar';
    return _DetailRow(
      label: label,
      value: typesAsync.when(
        data: (items) {
          final item = items.where((i) => i.id == id).firstOrNull;
          return item != null ? (isAr ? item.nameAr : item.nameEn) : id.toString();
        },
        loading: () => "...",
        error: (_, _) => id.toString(),
      ),
    );
  }

  Widget _buildSectorRow(WidgetRef ref, String label, int id) {
    final sectorsAsync = ref.watch(agriculturalSectorsProvider);
    final isAr = Localizations.localeOf(ref.context).languageCode == 'ar';
    return _DetailRow(
      label: label,
      value: sectorsAsync.when(
        data: (items) {
          final item = items.where((i) => i.id == id).firstOrNull;
          return item != null ? (isAr ? item.nameAr : item.nameEn) : id.toString();
        },
        loading: () => "...",
        error: (_, _) => id.toString(),
      ),
    );
  }

  Widget _buildAreaRow(WidgetRef ref, String label, double area, int unitId) {
    final unitsAsync = ref.watch(areaUnitsProvider);
    final isAr = Localizations.localeOf(ref.context).languageCode == 'ar';
    final unitText = unitsAsync.when(
      data: (items) {
        final item = items.where((i) => i.id == unitId).firstOrNull;
        return item != null ? (isAr ? item.nameAr : item.nameEn) : unitId.toString();
      },
      loading: () => "...",
      error: (_, _) => unitId.toString(),
    );
    return _DetailRow(label: label, value: "$area $unitText");
  }

  Widget _buildPoliticalRow(WidgetRef ref, String label, int id) {
    final itemsAsync = ref.watch(politicalClassificationsProvider);
    final isAr = Localizations.localeOf(ref.context).languageCode == 'ar';
    return _DetailRow(
      label: label,
      value: itemsAsync.when(
        data: (items) {
          final item = items.where((i) => i.id == id).firstOrNull;
          return item != null ? (isAr ? item.nameAr : item.nameEn) : id.toString();
        },
        loading: () => "...",
        error: (_, _) => id.toString(),
      ),
    );
  }

  Widget _buildLocationDetails(WidgetRef ref, Farm farm) {
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(farm.governorateId));
    final locAsync = ref.watch(localitiesProvider((farm.governorateId, farm.directorateId)));
    final isAr = Localizations.localeOf(ref.context).languageCode == 'ar';

    return Column(
      children: [
        _DetailRow(
          label: AppLocalizations.of(ref.context)!.governorate,
          value: govAsync.when(
            data: (items) {
              final item = items.where((i) => i.id == farm.governorateId).firstOrNull;
              return item != null ? (isAr ? item.nameAr : item.nameEn) : farm.governorateId;
            },
            loading: () => "...",
            error: (_, _) => farm.governorateId,
          ),
        ),
        _DetailRow(
          label: AppLocalizations.of(ref.context)!.directorate,
          value: dirAsync.when(
            data: (items) {
              final item = items.where((i) => i.id == farm.directorateId).firstOrNull;
              return item != null ? (isAr ? item.nameAr : item.nameEn) : farm.directorateId;
            },
            loading: () => "...",
            error: (_, _) => farm.directorateId,
          ),
        ),
        _DetailRow(
          label: AppLocalizations.of(ref.context)!.locality,
          value: locAsync.when(
            data: (items) {
              final item = items.where((i) => i.id == farm.localityId).firstOrNull;
              return item != null ? (isAr ? item.nameAr : item.nameEn) : farm.localityId;
            },
            loading: () => "...",
            error: (_, _) => farm.localityId,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
