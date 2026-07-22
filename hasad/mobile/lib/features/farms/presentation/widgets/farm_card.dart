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

class FarmCard extends ConsumerWidget {
  final Farm farm;

  const FarmCard({super.key, required this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Location lookups
    final govAsync = ref.watch(governoratesProvider);
    final dirAsync = ref.watch(directoratesProvider(farm.governorateId));
    final locAsync = ref.watch(localitiesProvider((farm.governorateId, farm.directorateId)));

    // Entity lookups
    final sectorsAsync = ref.watch(agriculturalSectorsProvider);
    final areaUnitsAsync = ref.watch(areaUnitsProvider);

    // Names lookups
    final operatorAsync = ref.watch(farmerProvider(farm.farmerId));
    final ownerAsync = farm.ownerFarmerId != null ? ref.watch(farmerProvider(farm.ownerFarmerId!)) : const AsyncValue.data(null);

    String locationText = farm.localityId;
    govAsync.whenData((govs) {
      final gov = govs.where((g) => g.id == farm.governorateId).firstOrNull;
      if (gov != null) {
        dirAsync.whenData((dirs) {
          final dir = dirs.where((d) => d.id == farm.directorateId).firstOrNull;
          if (dir != null) {
            locAsync.whenData((locs) {
              final loc = locs.where((l) => l.id == farm.localityId).firstOrNull;
              if (loc != null) {
                locationText = "${isAr ? gov.nameAr : gov.nameEn} / ${isAr ? dir.nameAr : dir.nameEn} / ${isAr ? loc.nameAr : loc.nameEn}";
              }
            });
          }
        });
      }
    });

    String sectorText = farm.agriculturalSectorId.toString();
    sectorsAsync.whenData((items) {
      final item = items.where((i) => i.id == farm.agriculturalSectorId).firstOrNull;
      if (item != null) sectorText = isAr ? item.nameAr : item.nameEn;
    });

    String areaUnitText = farm.areaUnitId.toString();
    areaUnitsAsync.whenData((items) {
      final item = items.where((i) => i.id == farm.areaUnitId).firstOrNull;
      if (item != null) areaUnitText = isAr ? item.nameAr : item.nameEn;
    });

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push(AppRoutes.farmDetails, extra: farm),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      farm.localFarmName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: farm.isPendingDelete ? TextDecoration.lineThrough : null,
                          ),
                    ),
                  ),
                  FarmerSyncStatusBadge(
                    status: farm.isPendingDelete ? 'pending_delete' : farm.syncStatus,
                  ),
                ],
              ),
              const Divider(height: 24),
              _InfoRow(
                icon: Icons.person_outline,
                label: l10n.farmerName,
                value: operatorAsync.when(
                  data: (f) => f.fullName,
                  loading: () => "...",
                  error: (_, _) => farm.farmerId,
                ),
              ),
              if (farm.ownerFarmerId != null) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.person_search_outlined,
                  label: l10n.ownerFarmer,
                  value: ownerAsync.when(
                    data: (f) => f?.fullName ?? farm.ownerFarmerId!,
                    loading: () => "...",
                    error: (_, _) => farm.ownerFarmerId!,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      icon: Icons.square_foot_outlined,
                      label: l10n.landArea,
                      value: "${farm.area} $areaUnitText",
                    ),
                  ),
                  Expanded(
                    child: _InfoRow(
                      icon: Icons.agriculture_outlined,
                      label: l10n.agriculturalSector,
                      value: sectorText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: l10n.locationSection,
                value: locationText,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.grid_3x3_outlined,
                label: "${l10n.basin} / ${l10n.parcel}",
                value: "${farm.basin} / ${farm.parcel}",
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => context.push(AppRoutes.farmDetails, extra: farm),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: Text(l10n.search), // Using search as "view"
                  ),
                  TextButton.icon(
                    onPressed: () => context.push(AppRoutes.editFarm, extra: farm),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editFarm),
                  ),
                  TextButton.icon(
                    onPressed: () => _confirmDelete(context, ref),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text(l10n.delete),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(farmFormProvider.notifier).deleteFarm(farm.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
