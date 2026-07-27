import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/damage_reports/presentation/providers/damage_item_selection_provider.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CostingItemSelector extends ConsumerStatefulWidget {
  const CostingItemSelector({super.key});

  @override
  ConsumerState<CostingItemSelector> createState() => _CostingItemSelectorState();
}

class _CostingItemSelectorState extends ConsumerState<CostingItemSelector> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(searchCostingItemsProvider(_query));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            l10n.searchByCodeOrName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchByCodeOrName,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(child: Text(l10n.noItemsFound));
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CostingItemTile(item: item);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _CostingItemTile extends ConsumerWidget {
  final CostingSheetItem item;
  const _CostingItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classificationAsync = ref.watch(damageClassificationByIdProvider(item.classificationId));
    final unitAsync = item.measurementUnitId != null 
        ? ref.watch(measurementUnitByIdProvider(item.measurementUnitId!))
        : const AsyncValue<MeasurementUnit?>.data(null);

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return classificationAsync.when(
      data: (cl) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            item.code.isNotEmpty ? item.code.substring(0, min(3, item.code.length)) : '?',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(cl != null ? (isAr ? cl.nameAr : cl.nameEn) : 'Unknown'),
        subtitle: Row(
          children: [
            Text(item.code, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text('${item.unitPrice} EUR / ${unitAsync.when(
              data: (u) => u != null ? (isAr ? u.nameAr : u.nameEn) : 'Unit',
              loading: () => '...',
              error: (_, __) => 'Unit',
            )}'),
          ],
        ),
        onTap: () => ref.read(damageItemSelectionProvider.notifier).selectItem(item),
      ),
      loading: () => const ListTile(title: LinearProgressIndicator()),
      error: (_, __) => const ListTile(title: Text('Error loading classification')),
    );
  }

  int min(int a, int b) => a < b ? a : b;
}
