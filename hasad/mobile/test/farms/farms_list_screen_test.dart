import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:drift/native.dart';
import 'package:mobile/features/farms/domain/farm_filter.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/presentation/farms_list_screen.dart';
import 'package:mobile/features/farms/presentation/farms_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../helpers/mocks.dart';

void main() {
  late MockFarmRepository mockRepo;
  late MockAuthorizationService mockAuthService;
  late AppDatabase db;

  setUpAll(() {
    registerFallbackValue(const FarmFilter());
  });

  setUp(() {
    mockRepo = MockFarmRepository();
    mockAuthService = MockAuthorizationService();
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    when(() => mockAuthService.canManageFarms()).thenReturn(true);
  });

  tearDown(() async {
    await db.close();
  });

  Widget createWidget({Stream<List<Farm>>? stream}) {
    return ProviderScope(
      overrides: [
        authorizationServiceProvider.overrideWithValue(mockAuthService),
        farmRepositoryProvider.overrideWithValue(mockRepo),
        databaseProvider.overrideWithValue(db),
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
