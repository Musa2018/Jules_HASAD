import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farms/presentation/farms_list_screen.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/farmers/domain/gender.dart';

void main() {
  final farmer = Farmer(
    id: 'farmer-1',
    idTypeId: 1,
    idNumber: '123',
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
    phoneNumber: '555',
    familySize: 5,
    governorateId: 'G1',
    localityId: 'L1',
    address: 'Gaza',
  );

  testWidgets('FarmsListScreen shows farms for farmer', (tester) async {
    final farms = [
      const Farm(
        id: 'farm-1',
        farmerId: 'farmer-1',
        localFarmName: 'Fruit Garden',
        governorateId: 'Gaza',
        directorateId: 'D1',
        localityId: 'City',
        basin: 'B1',
        parcel: 'P1',
        area: 5,
        areaUnitId: 1,
        ownershipTypeId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmsListByFarmerProvider('farmer-1').overrideWith((ref) => farms),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FarmsListScreen(farmer: farmer),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Fruit Garden'), findsOneWidget);
    expect(find.text('5.0 1'), findsOneWidget); // 1 is areaUnitId for now in UI
  });
}
