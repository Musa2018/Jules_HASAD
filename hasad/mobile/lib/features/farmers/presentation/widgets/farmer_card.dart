import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_sync_status_badge.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmerCard extends ConsumerWidget {
  final Farmer farmer;

  const FarmerCard({super.key, required this.farmer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dateFormat = DateFormat.yMd(locale);

    // Location lookups
    final govAsync = ref.watch(governoratesProvider);
    final locAsync = ref.watch(localitiesProvider((farmer.governorateId, null)));

    String locationText = farmer.governorateId;
    govAsync.whenData((govs) {
      final gov = govs.where((g) => g.id == farmer.governorateId).firstOrNull;
      if (gov != null) {
        String locName = farmer.localityId;
        locAsync.whenData((locs) {
          final loc = locs.where((l) => l.id == farmer.localityId).firstOrNull;
          if (loc != null) {
            locName = isArabic ? loc.nameAr : loc.nameEn;
          }
        });
        locationText = '${isArabic ? gov.nameAr : gov.nameEn} - $locName';
      }
    });

    return Opacity(
      opacity: farmer.isPendingDelete ? 0.6 : 1.0,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => context.push(AppRoutes.farmerDetails, extra: farmer),
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
                        farmer.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              decoration: farmer.isPendingDelete ? TextDecoration.lineThrough : null,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FarmerSyncStatusBadge(
                      status: farmer.isPendingDelete ? 'pending_delete' : farmer.syncStatus,
                    ),
                  ],
                ),
                if (farmer.lastSyncError != null && farmer.isPendingDelete)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${l10n.syncError}: ${farmer.lastSyncError}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Divider(height: 24),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: l10n.idNumber,
                  value: farmer.idNumber,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.phone_android_outlined,
                  label: l10n.phoneNumber,
                  value: farmer.phoneNumber,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: l10n.locationSection,
                  value: locationText,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoRow(
                        icon: farmer.gender == Gender.male ? Icons.male : (farmer.gender == Gender.female ? Icons.female : Icons.person_outline),
                        label: l10n.gender,
                        value: _getGenderLabel(context, farmer.gender),
                      ),
                    ),
                    Expanded(
                      child: _InfoRow(
                        icon: Icons.cake_outlined,
                        label: l10n.dateOfBirth,
                        value: dateFormat.format(farmer.birthDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!farmer.isPendingDelete) ...[
                      TextButton.icon(
                        onPressed: () => context.push(AppRoutes.addFarm, extra: farmer),
                        icon: const Icon(Icons.agriculture, size: 18),
                        label: Text(l10n.farm),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push(AppRoutes.editFarmer, extra: farmer),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(l10n.editFarmer),
                      ),
                      TextButton.icon(
                        onPressed: () => _confirmDelete(context, ref),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(l10n.delete),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: () => ref.read(farmerRepositoryProvider).cancelDeleteFarmer(farmer.id),
                        icon: const Icon(Icons.undo),
                        label: Text(l10n.cancelDelete),
                      ),
                      if (farmer.syncStatus == 'failed')
                        TextButton.icon(
                          onPressed: () => ref.read(farmerFormProvider.notifier).deleteFarmer(farmer.id),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retry),
                        ),
                    ],
                  ],
                ),
              ],
            ),
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
              ref.read(farmerFormProvider.notifier).deleteFarmer(farmer.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _getGenderLabel(BuildContext context, Gender gender) {
    final l10n = AppLocalizations.of(context)!;
    switch (gender) {
      case Gender.male:
        return l10n.male;
      case Gender.female:
        return l10n.female;
      case Gender.unspecified:
        return l10n.unspecified;
    }
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
