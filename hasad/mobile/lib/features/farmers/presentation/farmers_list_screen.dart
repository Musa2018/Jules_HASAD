import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
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
      ),
      body: farmersAsync.when(
        data: (farmers) {
          if (farmers.isEmpty) {
            return Center(child: Text(l10n.noFarmers));
          }
          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index];
              return ListTile(
                title: Text(farmer.name),
                subtitle: Text(farmer.nationalId),
                onTap: () => context.push('/farmers/edit', extra: farmer),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.errorLoadingFarmers),
              TextButton(
                onPressed: () => ref.refresh(farmersListProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/farmers/add'),
        tooltip: l10n.addFarmer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
