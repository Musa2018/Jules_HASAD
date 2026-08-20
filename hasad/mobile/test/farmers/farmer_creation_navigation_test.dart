import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/presentation/widgets/form_save_footer.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/domain/farmer_filter.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/location/domain/directorate.dart';
import 'package:mobile/features/location/domain/governorate.dart';
import 'package:mobile/features/location/domain/locality.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/network/token_refresher.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../auth/fakes.dart';

import '../helpers/mocks.dart';

void main() {
  late MockFarmerRepository mockFarmerRepo;
  late MockLocationRepository mockLocationRepo;
  late MockAuthorizationService mockAuthService;

  setUpAll(() {
    registerFallbackValue(const FarmerFilter());
    registerFallbackValue(
      Farmer(
        id: '',
        idTypeId: 1,
        idNumber: '',
        firstNameAr: '',
        fatherNameAr: '',
        grandfatherNameAr: '',
        familyNameAr: '',
        firstNameEn: '',
        fatherNameEn: '',
        grandfatherNameEn: '',
        familyNameEn: '',
        birthDate: DateTime.now(),
        gender: Gender.unspecified,
        phoneNumber: '',
        familySize: 1,
        governorateId: '',
        localityId: '',
        address: '',
      ),
    );
  });

  setUp(() {
    mockFarmerRepo = MockFarmerRepository();
    mockLocationRepo = MockLocationRepository();
    mockAuthService = MockAuthorizationService();
    
    when(() => mockAuthService.canManageFarmers()).thenReturn(true);
    
    final govs = [const Governorate(id: 'g1', nameAr: 'محافظة 1', nameEn: 'Gov 1', code: 'G1')];
    final dirs = [const Directorate(id: 'd1', nameAr: 'مديرية 1', nameEn: 'Dir 1', governorateId: 'g1')];
    final locs = [const Locality(id: 'l1', nameAr: 'تجمع 1', nameEn: 'Loc 1', governorateId: 'g1', directorateId: 'd1')];
    
    when(() => mockLocationRepo.getGovernorates()).thenAnswer((_) async => govs);
    when(() => mockLocationRepo.getDirectorates(governorateId: any(named: 'governorateId')))
        .thenAnswer((_) async => dirs);
    when(() => mockLocationRepo.getLocalities(
          governorateId: any(named: 'governorateId'),
          directorateId: any(named: 'directorateId'),
        )).thenAnswer((_) async => locs);
    
    when(() => mockFarmerRepo.watchFarmers(filter: any(named: 'filter')))
        .thenAnswer((_) => Stream.value([]));
  });

  Future<Widget> buildApp() async {
    final authRepo = FakeAuthRepository();
    authRepo.session = sampleSession();
    final storage = FakeSecureStorage();
    await storage.saveRefreshToken('r');

    return ProviderScope(
      overrides: [
        farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
        locationRepositoryProvider.overrideWithValue(mockLocationRepo),
        authorizationServiceProvider.overrideWithValue(mockAuthService),
        authProvider.overrideWith(
          (ref) => AuthNotifier(authRepo, storage, TokenRefresher(authRepo, storage)),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
        ),
      ),
    );
  }

  testWidgets('Successful farmer creation navigates to list screen', (tester) async {
    // Set a very large surface size to accommodate the long form
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    const idNumber = '123456789';
    final farmer = Farmer(
      id: 'new-id',
      idTypeId: 1,
      idNumber: idNumber,
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'صالح',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohamed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Saleh',
      birthDate: DateTime(1985, 5, 5),
      gender: Gender.male,
      phoneNumber: '0599123456',
      familySize: 5,
      governorateId: 'g1',
      localityId: 'l1',
      address: 'Street 1',
    );

    when(() => mockFarmerRepo.findByIdNumber(idNumber)).thenAnswer((_) async => null);
    when(() => mockFarmerRepo.createFarmer(any())).thenAnswer((_) async => farmer);

    await tester.pumpWidget(await buildApp());
    await tester.pump(); // Pump to apply size

    final router = ProviderScope.containerOf(tester.element(find.byType(MaterialApp))).read(appRouterProvider);
    router.go(AppRoutes.farmers);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Farmer').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, idNumber);
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Fill form
    await tester.tap(find.text('National ID').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jerusalem ID').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'First Name').first, 'أحمد');
    await tester.enterText(find.widgetWithText(TextFormField, 'Second Name').first, 'محمد');
    await tester.enterText(find.widgetWithText(TextFormField, 'Third Name').first, 'علي');
    await tester.enterText(find.widgetWithText(TextFormField, 'Fourth Name').first, 'صالح');
    
    await tester.enterText(find.widgetWithText(TextFormField, 'First Name').last, 'Ahmed');
    await tester.enterText(find.widgetWithText(TextFormField, 'Second Name').last, 'Mohamed');
    await tester.enterText(find.widgetWithText(TextFormField, 'Third Name').last, 'Ali');
    await tester.enterText(find.widgetWithText(TextFormField, 'Fourth Name').last, 'Saleh');

    // Date of Birth
    await tester.tap(find.text('Select Date').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK').first);
    await tester.pumpAndSettle();

    // Gender
    await tester.tap(find.text('Unspecified').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Mobile Number').first, '0599123456');
    await tester.enterText(find.widgetWithText(TextFormField, 'Family Size').first, '5');

    // Location
    final govField = find.byType(SearchableLookupField<Governorate>).first;
    await tester.ensureVisible(govField);
    await tester.tap(govField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gov 1').last);
    await tester.pumpAndSettle();

    final locField = find.byType(SearchableLookupField<Locality>).first;
    await tester.ensureVisible(locField);
    await tester.tap(locField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loc 1').last);
    await tester.pumpAndSettle();

    // Save
    final saveButton = find.descendant(of: find.byType(FormSaveFooter), matching: find.byType(ElevatedButton));
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify
    verify(() => mockFarmerRepo.createFarmer(any())).called(1);
    expect(find.text('Farmers'), findsOneWidget);
  });
}
