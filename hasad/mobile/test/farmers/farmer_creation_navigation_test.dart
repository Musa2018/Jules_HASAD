import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/l10n/app_localizations.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}
class MockLocationRepository extends Mock implements LocationRepository {}
class MockAuthorizationService extends Mock implements AuthorizationService {}

void main() {
  late MockFarmerRepository mockFarmerRepo;
  late MockLocationRepository mockLocationRepo;
  late MockAuthorizationService mockAuthService;

  setUpAll(() {
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
    when(() => mockLocationRepo.getGovernorates()).thenAnswer((_) async => []);
    when(() => mockFarmerRepo.watchFarmers(filter: any(named: 'filter')))
        .thenAnswer((_) => Stream.value([]));
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
        locationRepositoryProvider.overrideWithValue(mockLocationRepo),
        authorizationServiceProvider.overrideWithValue(mockAuthService),
        authProvider.overrideWith((ref) => AuthNotifierFake(
          AuthSession(
            token: 't',
            refreshToken: 'r',
            userId: 'u',
            userName: 'n',
            roles: ['Admin'],
          ),
        )),
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

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // 1. Navigate to Farmers List
    final router = ProviderScope.containerOf(tester.element(find.byType(MaterialApp))).read(appRouterProvider);
    router.go(AppRoutes.farmers);
    await tester.pumpAndSettle();

    // 2. Tap Add Farmer
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Search Farmer'), findsOneWidget);

    // 3. Search for ID
    await tester.enterText(find.byType(TextFormField), idNumber);
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // 4. Should be on Add Farmer screen
    expect(find.text('Add Farmer'), findsOneWidget);
    expect(find.text(idNumber), findsOneWidget);

    // 5. Fill required fields (skipping some for brevity as validation is mocked or bypassed by repo mock)
    // In reality, we need to fill them to pass form validation
    await tester.enterText(find.widgetWithText(TextFormField, 'First Name').first, 'أحمد');
    await tester.enterText(find.widgetWithText(TextFormField, 'Second Name').first, 'محمد');
    await tester.enterText(find.widgetWithText(TextFormField, 'Third Name').first, 'علي');
    await tester.enterText(find.widgetWithText(TextFormField, 'Fourth Name').first, 'صالح');
    
    await tester.enterText(find.widgetWithText(TextFormField, 'First Name').last, 'Ahmed');
    await tester.enterText(find.widgetWithText(TextFormField, 'Second Name').last, 'Mohamed');
    await tester.enterText(find.widgetWithText(TextFormField, 'Third Name').last, 'Ali');
    await tester.enterText(find.widgetWithText(TextFormField, 'Fourth Name').last, 'Saleh');

    // Date of Birth
    await tester.tap(find.text('Select Date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Gender
    await tester.tap(find.text('Unspecified'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Mobile Number'), '0599123456');
    await tester.enterText(find.widgetWithText(TextFormField, 'Family Size'), '5');

    // 6. Save
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // 7. Verify navigation to Farmers List
    expect(find.text('Farmers'), findsOneWidget);
    expect(find.text('Search Farmer'), findsNothing);
    expect(find.text('Add Farmer'), findsNothing);
  });
}

class AuthNotifierFake extends StateNotifier<AuthState> {
  AuthNotifierFake(AuthSession? session)
      : super(AuthState(
          status: AuthStatus.authenticated,
          session: session,
        ));

  Future<void> logout() async {}
}
