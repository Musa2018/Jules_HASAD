import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farmer_form_screen.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/l10n/app_localizations.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}

void main() {
  late MockFarmerRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(
      Farmer(
        id: '', idTypeId: 1, idNumber: '', firstNameAr: '', fatherNameAr: '',
        grandfatherNameAr: '', familyNameAr: '', firstNameEn: '', fatherNameEn: '',
        grandfatherNameEn: '', familyNameEn: '', birthDate: DateTime(1900),
        gender: Gender.male, phoneNumber: '', familySize: 1, governorateId: '',
        localityId: '', address: '',
      ),
    );
  });

  setUp(() {
    mockRepo = MockFarmerRepository();
  });

  testWidgets('FarmerFormScreen returns created farmer on success', (tester) async {
    // Set larger surface size to avoid off-screen issues in date picker/scroll
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final createdFarmer = Farmer(
      id: 'new-f1',
      idTypeId: 3,
      idNumber: 'AB123456',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1980, 1, 1),
      gender: Gender.male,
      phoneNumber: '0599000000',
      familySize: 4,
      governorateId: 'gov-1',
      localityId: 'loc-1',
      address: 'Test',
    );

    when(() => mockRepo.createFarmer(any())).thenAnswer((_) async => createdFarmer);

    Farmer? returnedFarmer;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmerRepositoryProvider.overrideWithValue(mockRepo),
          governoratesProvider.overrideWith((ref) => [
            const Governorate(id: 'gov-1', nameAr: 'جنين', nameEn: 'Jenin', code: 'JN'),
          ]),
          localitiesProvider.overrideWith((ref, _) => [
            const Locality(id: 'loc-1', nameAr: 'جنين', nameEn: 'Jenin', governorateId: 'gov-1', directorateId: 'dir-1'),
          ]),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                returnedFarmer = await Navigator.of(context).push<Farmer>(
                  MaterialPageRoute(builder: (context) => const FarmerFormScreen()),
                );
              },
              child: const Text('Open Form'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Form'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passport').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'AB123456'); // Passport Number
    
    // Arabic Name section
    await tester.enterText(find.byType(TextFormField).at(1), 'أحمد');
    await tester.enterText(find.byType(TextFormField).at(2), 'محمد');
    await tester.enterText(find.byType(TextFormField).at(3), 'علي');
    await tester.enterText(find.byType(TextFormField).at(4), 'محمود');
    
    // English Name section
    await tester.enterText(find.byType(TextFormField).at(5), 'Ahmed');
    await tester.enterText(find.byType(TextFormField).at(6), 'Mohammed');
    await tester.enterText(find.byType(TextFormField).at(7), 'Ali');
    await tester.enterText(find.byType(TextFormField).at(8), 'Mahmoud');

    // Date picker
    await tester.ensureVisible(find.byIcon(Icons.calendar_today));
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    
    // Use a more specific finder for the OK button in the dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Gender
    await tester.ensureVisible(find.byType(DropdownButtonFormField<Gender>));
    await tester.tap(find.byType(DropdownButtonFormField<Gender>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(9), '0599000000'); // Mobile

    // Location (Select Gov first to enable Locality)
    await tester.ensureVisible(find.byType(SearchableLookupField<Governorate>));
    await tester.tap(find.byType(SearchableLookupField<Governorate>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jenin').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(SearchableLookupField<Locality>));
    await tester.tap(find.byType(SearchableLookupField<Locality>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jenin').last);
    await tester.pumpAndSettle();

    // Save
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(returnedFarmer, isNotNull);
    expect(returnedFarmer?.idNumber, 'AB123456');
  });
}
