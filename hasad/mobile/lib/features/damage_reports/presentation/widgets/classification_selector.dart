import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ClassificationSelector extends ConsumerWidget {
  final int sectorId;
  const ClassificationSelector({super.key, required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(classificationWizardProvider(sectorId));
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildHeader(context, ref, state, l10n),
        const Divider(),
        Expanded(
          child: _buildStepContent(context, ref, state, l10n),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      ClassificationWizardState state, AppLocalizations l10n) {
    String title;
    switch (state.currentStep) {
      case 1:
        title = 'Select Damage Nature';
        break;
      case 2:
        title = 'Select Damage Action';
        break;
      case 3:
        title = 'Select Category';
        break;
      case 4:
        title = 'Select Sub-Category';
        break;
      case 5:
        title = 'Select Classification';
        break;
      default:
        title = 'Item Details';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (state.currentStep > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  ref.read(classificationWizardProvider(sectorId).notifier).previousStep(),
            ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text('Step ${state.currentStep} of 5'),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, WidgetRef ref,
      ClassificationWizardState state, AppLocalizations l10n) {
    switch (state.currentStep) {
      case 1:
        return _NatureSelectionList(sectorId: sectorId);
      case 2:
        return _ActionSelectionList(sectorId: sectorId);
      case 3:
        return _CategorySelectionList(sectorId: sectorId);
      case 4:
        return _SubCategorySelectionList(categoryId: state.selectedCategory!.id, sectorId: sectorId);
      case 5:
        return _ClassificationSelectionList(
            subCategoryId: state.selectedSubCategory!.id, sectorId: sectorId);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _NatureSelectionList extends ConsumerWidget {
  final int sectorId;
  const _NatureSelectionList({required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naturesAsync = ref.watch(naturesProvider);

    return naturesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            subtitle: Text(item.nameEn),
            onTap: () =>
                ref.read(classificationWizardProvider(sectorId).notifier).setNature(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _ActionSelectionList extends ConsumerWidget {
  final int sectorId;
  const _ActionSelectionList({required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(actionsProvider);

    return actionsAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            subtitle: Text(item.nameEn),
            onTap: () =>
                ref.read(classificationWizardProvider(sectorId).notifier).setAction(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _CategorySelectionList extends ConsumerWidget {
  final int sectorId;
  const _CategorySelectionList({required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesBySectorProvider(sectorId));

    return categoriesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            onTap: () =>
                ref.read(classificationWizardProvider(sectorId).notifier).setCategory(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _SubCategorySelectionList extends ConsumerWidget {
  final int categoryId;
  final int sectorId;
  const _SubCategorySelectionList({required this.categoryId, required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subCategoriesAsync =
        ref.watch(subCategoriesByCategoryProvider(categoryId));

    return subCategoriesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            onTap: () => ref
                .read(classificationWizardProvider(sectorId).notifier)
                .setSubCategory(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _ClassificationSelectionList extends ConsumerWidget {
  final int subCategoryId;
  final int sectorId;
  const _ClassificationSelectionList({required this.subCategoryId, required this.sectorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classificationsAsync =
        ref.watch(classificationsBySubCategoryProvider(subCategoryId));

    return classificationsAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            onTap: () => ref
                .read(classificationWizardProvider(sectorId).notifier)
                .setClassification(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
