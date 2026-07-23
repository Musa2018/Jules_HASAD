import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/damage_reports/presentation/providers/classification_wizard_provider.dart';
import 'package:mobile/features/farms/data/reference_data_repository.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockReferenceDataRepository extends Mock implements ReferenceDataRepository {}

void main() {
  late MockReferenceDataRepository mockRepo;
  late ProviderContainer container;

  final nature = const DamageNature(id: 1, nameAr: 'N1', nameEn: 'E1');
  final category = const DamageCategory(id: 10, parentId: 1, nameAr: 'C1', nameEn: 'CE1');
  final subCategory = const DamageSubCategory(id: 100, parentId: 10, nameAr: 'SC1', nameEn: 'SE1');
  final classification = const DamageClassification(id: 1000, parentId: 100, nameAr: 'Cl1', nameEn: 'CLE1');
  final costing = CostingSheetVersion(
    id: 'cs1',
    classificationId: 1000,
    unitPrice: 50.0,
    effectiveFrom: DateTime.now(),
    versionNumber: 1,
  );

  setUp(() {
    mockRepo = MockReferenceDataRepository();
    container = ProviderContainer(
      overrides: [
        referenceDataRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ClassificationWizardNotifier', () {
    test('initial state is correct', () {
      final state = container.read(classificationWizardProvider);
      expect(state.currentStep, 1);
      expect(state.selectedNature, isNull);
    });

    test('setting nature moves to step 2 and clears children', () {
      final notifier = container.read(classificationWizardProvider.notifier);
      notifier.setNature(nature);
      
      final state = container.read(classificationWizardProvider);
      expect(state.currentStep, 2);
      expect(state.selectedNature, nature);
    });

    test('setting classification resolves costing automatically', () async {
      when(() => mockRepo.getActiveCostingSheet(1000))
          .thenAnswer((_) async => costing);

      final notifier = container.read(classificationWizardProvider.notifier);
      notifier.setNature(nature);
      notifier.setCategory(category);
      notifier.setSubCategory(subCategory);
      
      await notifier.setClassification(classification);

      final state = container.read(classificationWizardProvider);
      expect(state.selectedClassification, classification);
      expect(state.resolvedCosting, costing);
      expect(state.error, isNull);
    });

    test('cascading reset: changing nature clears all dependent levels', () async {
      when(() => mockRepo.getActiveCostingSheet(1000))
          .thenAnswer((_) async => costing);

      final notifier = container.read(classificationWizardProvider.notifier);
      notifier.setNature(nature);
      notifier.setCategory(category);
      notifier.setSubCategory(subCategory);
      await notifier.setClassification(classification);

      // Sanity check
      expect(container.read(classificationWizardProvider).selectedClassification, isNotNull);

      // Change Nature
      final newNature = const DamageNature(id: 2, nameAr: 'N2', nameEn: 'E2');
      notifier.setNature(newNature);

      final state = container.read(classificationWizardProvider);
      expect(state.currentStep, 2);
      expect(state.selectedNature, newNature);
      expect(state.selectedCategory, isNull);
      expect(state.selectedSubCategory, isNull);
      expect(state.selectedClassification, isNull);
      expect(state.resolvedCosting, isNull);
    });

    test('handles missing costing sheet with error message', () async {
      when(() => mockRepo.getActiveCostingSheet(1000))
          .thenAnswer((_) async => null);

      final notifier = container.read(classificationWizardProvider.notifier);
      await notifier.setClassification(classification);

      final state = container.read(classificationWizardProvider);
      expect(state.resolvedCosting, isNull);
      expect(state.error, contains('No active pricing found'));
    });
  });
}
