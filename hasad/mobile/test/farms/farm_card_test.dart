import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/farms/presentation/widgets/farm_card.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final tFarmer = Farmer(
    id: 'f1',
    idTypeId: 1,
    idNumber: '123',
    firstNameAr: 'أحمد',
    fatherNameAr: 'محمد',
    grandfatherNameAr: 'علي',
    familyNameAr: 'محمود',
    firstNameEn: 'Ahmed',
    fatherNameEn: 'Mohamed',
    grandfatherNameEn: 'Ali',
    familyNameEn: 'Mahmoud',
    birthDate: DateTime(1990),
    gender: Gender.male,
    phoneNumber: '059',
    familySize: 1,
    governorateId: 'g1',
    localityId: 'l1',
    address: 'addr',
  );

  final tFarm = Farm(
    id: 'farm1',
    farmerId: 'f1',
    localFarmName: 'Green Farm',
    ownershipTypeId: 1,
    governorateId: 'g1',
    directorateId: 'd1',
    localityId: 'l1',
    basin: 'B1',
    parcel: 'P1',
    area: 10.5,
    areaUnitId: 1,
    agriculturalSectorId: 1,
    politicalClassificationId: 1,
    syncStatus: 'completed',
  );

  testWidgets('FarmCard displays farm information correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmerProvider('f1').overrideWith((ref) => Future.value(tFarmer)),
          governoratesProvider.overrideWith((ref) => []),
          directoratesProvider('g1').overrideWith((ref) => []),
          localitiesProvider(('g1', 'd1')).overrideWith((ref) => []),
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
          home: Scaffold(body: FarmCard(farm: tFarm)),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Green Farm'), findsOneWidget);
    expect(find.textContaining('أحمد'), findsOneWidget);
    expect(find.textContaining('B1'), findsOneWidget);
    expect(find.textContaining('P1'), findsOneWidget);
    expect(find.text('Synced'), findsOneWidget);
  });
}
