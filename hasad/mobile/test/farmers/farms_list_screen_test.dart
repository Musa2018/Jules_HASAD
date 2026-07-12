import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/farmers/domain/farm.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/presentation/farms_list_screen.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  const farmer = Farmer(
    id: 'farmer-1',
    name: 'John Doe',
    nationalId: '123',
    phoneNumber: '555',
    address: 'Gaza',
  );

  testWidgets('FarmsListScreen shows farms for farmer', (tester) async {
    final farms = [
      const Farm(
        id: 'farm-1',
        farmerId: 'farmer-1',
        name: 'Fruit Garden',
        governorateId: 'Gaza',
        localityId: 'City',
        landArea: 5,
        landAreaUnit: 'Dunam',
        ownershipTypeId: 'Owned',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmsListByFarmerProvider('farmer-1').overrideWith((ref) => farms),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FarmsListScreen(farmer: farmer),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Fruit Garden'), findsOneWidget);
    expect(find.text('5.0 Dunam'), findsOneWidget);
  });
}
