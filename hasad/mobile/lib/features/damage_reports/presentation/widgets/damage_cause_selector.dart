import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_cause_wizard_provider.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class DamageCauseSelector extends ConsumerWidget {
  const DamageCauseSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(damageCauseWizardProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context, ref, state, l10n),
        const Divider(),
        Flexible(
          child: _buildStepContent(context, ref, state, l10n),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      DamageCauseWizardState state, AppLocalizations l10n) {
    String title;
    switch (state.currentStep) {
      case 1:
        title = 'Select Damage Category'; // Conceptually Nature/Category
        break;
      case 2:
        title = 'Select Specific Cause';
        break;
      default:
        title = 'Damage Cause';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (state.currentStep > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  ref.read(damageCauseWizardProvider.notifier).previousStep(),
            ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text('Step ${state.currentStep} of 2'),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, WidgetRef ref,
      DamageCauseWizardState state, AppLocalizations l10n) {
    switch (state.currentStep) {
      case 1:
        return _CategorySelectionList();
      case 2:
        return _CauseSelectionList(categoryId: state.selectedCategory!.id);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _CategorySelectionList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(damageCauseCategoriesProvider);

    return categoriesAsync.when(
      data: (items) => ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            subtitle: Text(item.nameEn),
            onTap: () =>
                ref.read(damageCauseWizardProvider.notifier).setCategory(item),
          );
        },
      ),
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      )),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _CauseSelectionList extends ConsumerWidget {
  final int categoryId;
  const _CauseSelectionList({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final causesAsync = ref.watch(damageCausesByCategoryProvider(categoryId));

    return causesAsync.when(
      data: (items) => ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            subtitle: Text(item.nameEn),
            onTap: () {
              ref.read(damageCauseWizardProvider.notifier).setCause(item);
              Navigator.pop(context);
            },
          );
        },
      ),
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      )),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
