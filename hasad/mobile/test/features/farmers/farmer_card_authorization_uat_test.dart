import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:drift/native.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_card.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthorizationService mockAuthService;
  late MockLocationRepository mockLocationRepo;
  late AppDatabase db;

  setUp(() {
    mockAuthService = MockAuthorizationService();
    mockLocationRepo = MockLocationRepository();
    db = AppDatabase.withExecutor(NativeDatabase.memory());

    // Prevent background fetches in tests
    when(() => mockLocationRepo.getGovernorates()).thenAnswer((_) async => []);
    when(() => mockLocationRepo.getLocalities(governorateId: any(named: 'governorateId'), directorateId: any(named: 'directorateId')))
        .thenAnswer((_) async => []);
  });

  tearDown(() async {
    await db.close();
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

  Widget createWidget() {
    return ProviderScope(
      overrides: [
        authorizationServiceProvider.overrideWithValue(mockAuthService),
        databaseProvider.overrideWithValue(db),
        locationRepositoryProvider.overrideWithValue(mockLocationRepo),
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
        home: Scaffold(
          body: FarmerCard(farmer: testFarmer),
        ),
      ),
    );
  }

  testWidgets('TechnicalReviewer cannot see Add Farm button (UAT-001)', (tester) async {
    // Setup restricted permissions
    when(() => mockAuthService.canManageFarms()).thenReturn(false);
    when(() => mockAuthService.canManageFarmers()).thenReturn(false);

    await tester.pumpWidget(createWidget());

    // Verify "المزارع" button does NOT exist
    expect(find.text('المزارع'), findsNothing);
    expect(find.byIcon(Icons.agriculture), findsNothing);
    
    // Verify "تعديل" button does NOT exist
    expect(find.text('تعديل'), findsNothing);
  });

  testWidgets('AgriculturalEngineer can see Add Farm button', (tester) async {
    // Setup authorized permissions
    when(() => mockAuthService.canManageFarms()).thenReturn(true);
    when(() => mockAuthService.canManageFarmers()).thenReturn(true);

    await tester.pumpWidget(createWidget());

    // Verify "المزارع" button exists
    expect(find.text('المزارع'), findsOneWidget);
    expect(find.byIcon(Icons.agriculture), findsOneWidget);
  });
}
