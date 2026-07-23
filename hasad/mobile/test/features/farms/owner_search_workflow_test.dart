import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farms/domain/lookup_entities.dart';
import 'package:mobile/features/farms/presentation/farm_form_screen.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}

void main() {
  setUpAll(() {
    EnvironmentConfig.setEnvironment(AppEnvironment.dev);
  });

  late MockFarmerRepository mockFarmerRepo;

  setUp(() {
    mockFarmerRepo = MockFarmerRepository();
  });

  final testFarmer = Farmer(
    id: 'f1',
    idTypeId: 1,
    idNumber: '123456789',
    firstNameAr: 'أحمد',
    fatherNameAr: 'محمد',
    grandfatherNameAr: 'علي',
    familyNameAr: 'محمود',
    firstNameEn: 'Ahmed',
    fatherNameEn: 'Mohammed',
    grandfatherNameEn: 'Ali',
    familyNameEn: 'Mahmoud',
    birthDate: DateTime(1985, 5, 10),
    gender: Gender.male,
    phoneNumber: '0599123456',
    familySize: 5,
    governorateId: 'G1',
    localityId: 'L1',
    address: 'Street 1',
  );

  testWidgets('Owner search shows Add New Farmer action when no results', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Mock search to return empty
    when(() => mockFarmerRepo.getFarmers(searchText: any(named: 'searchText')))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
          governoratesProvider.overrideWith((ref) => []),
          ownershipTypesProvider.overrideWith((ref) async => [
            const OwnershipType(id: 1, nameAr: 'ملك', nameEn: 'Owned'),
            const OwnershipType(id: 2, nameAr: 'مستأجر', nameEn: 'Rented'),
          ]),
          agriculturalSectorsProvider.overrideWith((ref) async => []),
          politicalClassificationsProvider.overrideWith((ref) async => []),
          areaUnitsProvider.overrideWith((ref) async => []),
          relationshipToOwnersProvider.overrideWith((ref) async => []),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: const Locale('ar'),
          home: FarmFormScreen(farmer: testFarmer),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Change to Rented to show owner field
    await tester.tap(find.text('ملك'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مستأجر').last);
    await tester.pumpAndSettle();

    // Tap Owner Farmer field to open search sheet
    // It's pre-filled with testFarmer initially.
    await tester.tap(find.textContaining('أحمد محمود (123456789)'));
    await tester.pumpAndSettle();

    // Enter search text that returns nothing
    await tester.enterText(find.byType(TextField).last, 'Unknown');
    await tester.pump(const Duration(milliseconds: 600)); // wait for debounce
    await tester.pumpAndSettle();

    // Verify "+ إضافة مزارع جديد" exists
    expect(find.text('+ إضافة مزارع جديد'), findsOneWidget);
  });
}
