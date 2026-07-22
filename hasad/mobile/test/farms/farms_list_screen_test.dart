import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/presentation/farms_list_screen.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockFarmRepository extends Mock implements FarmRepository {}

void main() {
  late MockFarmRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(const FarmFilter());
  });

  setUp(() {
    mockRepo = MockFarmRepository();
  });

  Widget createWidget({Stream<List<Farm>>? stream}) {
    return ProviderScope(
      overrides: [
        farmRepositoryProvider.overrideWithValue(mockRepo),
        if (stream != null)
          farmsListStreamProvider.overrideWith((ref) => stream),
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
        home: const FarmsListScreen(),
      ),
    );
  }

  testWidgets('FarmsListScreen shows empty state', (tester) async {
    await tester.pumpWidget(createWidget(stream: Stream.value([])));
    await tester.pump();
    await tester.pump();

    expect(find.text('No farms found.'), findsOneWidget);
  });

  testWidgets('FarmsListScreen shows farms', (tester) async {
    final farms = [
      const Farm(
        id: '1',
        farmerId: 'f1',
        localFarmName: 'Orange Farm',
        ownershipTypeId: 1,
        governorateId: 'g1',
        directorateId: 'd1',
        localityId: 'l1',
        basin: 'B1',
        parcel: 'P1',
        area: 5,
        areaUnitId: 1,
        agriculturalSectorId: 1,
        politicalClassificationId: 1,
        syncStatus: 'completed',
      ),
    ];

    await tester.pumpWidget(createWidget(stream: Stream.value(farms)));
    await tester.pump();
    await tester.pump();

    expect(find.text('Orange Farm'), findsOneWidget);
  });
}
