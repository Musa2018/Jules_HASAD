import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ClassificationSelector extends ConsumerWidget {
  const ClassificationSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(classificationWizardProvider);
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
        title = 'Select Category';
        break;
      case 3:
        title = 'Select Sub-Category';
        break;
      case 4:
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
                  ref.read(classificationWizardProvider.notifier).previousStep(),
            ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text('Step ${state.currentStep} of 4'),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, WidgetRef ref,
      ClassificationWizardState state, AppLocalizations l10n) {
    switch (state.currentStep) {
      case 1:
        return _NatureSelectionList();
      case 2:
        return _CategorySelectionList(natureId: state.selectedNature!.id);
      case 3:
        return _SubCategorySelectionList(categoryId: state.selectedCategory!.id);
      case 4:
        return _ClassificationSelectionList(
            subCategoryId: state.selectedSubCategory!.id);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _NatureSelectionList extends ConsumerWidget {
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
                ref.read(classificationWizardProvider.notifier).setNature(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _CategorySelectionList extends ConsumerWidget {
  final int natureId;
  const _CategorySelectionList({required this.natureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesByNatureProvider(natureId));

    return categoriesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.nameAr),
            onTap: () =>
                ref.read(classificationWizardProvider.notifier).setCategory(item),
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
  const _SubCategorySelectionList({required this.categoryId});

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
                .read(classificationWizardProvider.notifier)
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
  const _ClassificationSelectionList({required this.subCategoryId});

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
                .read(classificationWizardProvider.notifier)
                .setClassification(item),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
