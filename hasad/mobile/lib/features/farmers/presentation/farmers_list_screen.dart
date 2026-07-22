import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_card.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_filters_section.dart';
import 'package:mobile/l10n/app_localizations.dart';

class FarmersListScreen extends ConsumerWidget {
  const FarmersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final farmersAsync = ref.watch(farmersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.farmers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(farmersListProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          const FarmerFiltersSection(),
          Expanded(
            child: farmersAsync.when(
              data: (farmers) {
                if (farmers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noFarmers,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(farmersListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: farmers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return FarmerCard(farmer: farmers[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(l10n.errorLoadingFarmers),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.refresh(farmersListProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.farmerSearch),
        icon: const Icon(Icons.add),
        label: Text(l10n.addFarmer),
      ),
    );
  }
}
