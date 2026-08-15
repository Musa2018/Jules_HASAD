import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farms/presentation/farms_list_screen.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthorizationService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthorizationService();
  });

  final testFarmer = Farmer(
    id: 'f1',
    idTypeId: 1,
    idNumber: '123',
    firstNameAr: 'a', fatherNameAr: 'b', grandfatherNameAr: 'c', familyNameAr: 'd',
    firstNameEn: 'a', fatherNameEn: 'b', grandfatherNameEn: 'c', familyNameEn: 'd',
    birthDate: DateTime(1990),
    gender: Gender.male,
    phoneNumber: '059',
    familySize: 1,
    governorateId: 'g1',
    localityId: 'l1',
    address: 'addr',
  );

  Widget createWidget({required Farmer? farmer}) {
    return ProviderScope(
      overrides: [
        authorizationServiceProvider.overrideWithValue(mockAuthService),
        farmsListStreamProvider.overrideWith((ref) => Stream.value([])),
        governoratesProvider.overrideWith((ref) => []),
        ownershipTypesProvider.overrideWith((ref) => []),
        agriculturalSectorsProvider.overrideWith((ref) => []),
        areaUnitsProvider.overrideWith((ref) => []),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        home: FarmsListScreen(farmer: farmer),
      ),
    );
  }

  testWidgets('FAB (+) is hidden for TechnicalReviewer on FarmsListScreen (UAT-002)', (tester) async {
    when(() => mockAuthService.canManageFarms()).thenReturn(false);

    await tester.pumpWidget(createWidget(farmer: testFarmer));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('FAB (+) is visible for AgriculturalEngineer on FarmsListScreen', (tester) async {
    when(() => mockAuthService.canManageFarms()).thenReturn(true);

    await tester.pumpWidget(createWidget(farmer: testFarmer));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
