import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmerFiltersSection extends ConsumerWidget {
  const FarmerFiltersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(farmerFiltersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.searchFarmer,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
            onChanged: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(searchText: v)),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _FilterChip(
                label: l10n.all,
                isSelected: filter.gender == null && filter.syncStatus == null,
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).state = const FarmerFilter(),
              ),
              const VerticalDivider(),
              // Gender Filter
              _FilterChip(
                label: l10n.male,
                isSelected: filter.gender == Gender.male,
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(gender: v ? Gender.male : null)),
              ),
              _FilterChip(
                label: l10n.female,
                isSelected: filter.gender == Gender.female,
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(gender: v ? Gender.female : null)),
              ),
              const VerticalDivider(),
              // Sync Status Filter
              _FilterChip(
                label: l10n.synced,
                isSelected: filter.syncStatus == 'completed',
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(syncStatus: v ? 'completed' : null)),
              ),
              _FilterChip(
                label: l10n.pendingSync,
                isSelected: filter.syncStatus == 'pending',
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(syncStatus: v ? 'pending' : null)),
              ),
              _FilterChip(
                label: l10n.syncError,
                isSelected: filter.syncStatus == 'failed',
                onSelected: (v) => ref.read(farmerFiltersProvider.notifier).update((state) => state.copyWith(syncStatus: v ? 'failed' : null)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
        ),
        selectedColor: Theme.of(context).colorScheme.primary,
        checkmarkColor: Colors.white,
      ),
    );
  }
}
