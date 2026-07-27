import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ClassificationSelector extends ConsumerWidget {
  final int sectorId;
  final int? lockedNatureId;
  const ClassificationSelector({super.key, required this.sectorId, this.lockedNatureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = {'sectorId': sectorId, 'lockedNatureId': lockedNatureId};
    final state = ref.watch(classificationWizardProvider(params));
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildHeader(context, ref, state, l10n, params),
        const Divider(),
        Expanded(
          child: _buildStepContent(context, ref, state, l10n, params),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      ClassificationWizardState state, AppLocalizations l10n, Map<String, int?> params) {
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
          if (state.currentStep > (lockedNatureId != null ? 2 : 1))
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  ref.read(classificationWizardProvider(params).notifier).previousStep(),
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
      ClassificationWizardState state, AppLocalizations l10n, Map<String, int?> params) {
    switch (state.currentStep) {
      case 1:
        return _NatureSelectionList(params: params);
      case 2:
        return _ActionSelectionList(params: params);
      case 3:
        return _CategorySelectionList(params: params);
      case 4:
        return _SubCategorySelectionList(categoryId: state.selectedCategory!.id, params: params);
      case 5:
        return _ClassificationSelectionList(
            subCategoryId: state.selectedSubCategory!.id, params: params);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _NatureSelectionList extends ConsumerWidget {
  final Map<String, int?> params;
  const _NatureSelectionList({required this.params});

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
                ref.read(classificationWizardProvider(params).notifier).setNature(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _ActionSelectionList extends ConsumerWidget {
  final Map<String, int?> params;
  const _ActionSelectionList({required this.params});

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
                ref.read(classificationWizardProvider(params).notifier).setAction(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _CategorySelectionList extends ConsumerWidget {
  final Map<String, int?> params;
  const _CategorySelectionList({required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectorId = params['sectorId']!;
    final categoriesAsync = ref.watch(categoriesBySectorProvider(sectorId));

    return categoriesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            onTap: () =>
                ref.read(classificationWizardProvider(params).notifier).setCategory(item),
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
  final Map<String, int?> params;
  const _SubCategorySelectionList({required this.categoryId, required this.params});

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
                .read(classificationWizardProvider(params).notifier)
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
  final Map<String, int?> params;
  const _ClassificationSelectionList({required this.subCategoryId, required this.params});

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
                .read(classificationWizardProvider(params).notifier)
                .setClassification(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
