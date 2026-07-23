import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/farms/domain/farm.dart';
import 'package:mobile/features/farms/presentation/farm_form_screen.dart';
import 'package:mobile/features/farms/presentation/lookup_providers.dart';
import 'package:mobile/features/location/presentation/location_providers.dart';
import 'package:mobile/features/farms/domain/reference_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/core/network/token_refresher.dart';

import 'package:mobile/core/config/app_config.dart';

class MockFarmerRepository extends Mock implements FarmerRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockTokenRefresher extends Mock implements TokenRefresher {}

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(AuthState initialState) 
      : super(MockAuthRepository(), MockSecureStorageService(), MockTokenRefresher()) {
    state = initialState;
  }
  
  @override
  Future<void> restoreSession() async {}
}

void main() {
  late MockFarmerRepository mockFarmerRepo;

  final sampleFarmer = Farmer(
    id: 'f1', idTypeId: 1, idNumber: '1', firstNameAr: 'أحمد',
    fatherNameAr: '', grandfatherNameAr: '', familyNameAr: '',
    firstNameEn: '', fatherNameEn: '', grandfatherNameEn: '', familyNameEn: '',
    birthDate: DateTime(1990), gender: Gender.male, phoneNumber: '',
    familySize: 1, governorateId: 'gov-1', localityId: 'loc-1', address: '',
  );

  final sampleFarm = Farm(
    id: 'farm-1',
    farmerId: 'f1',
    localFarmName: 'Test Farm',
    ownershipTypeId: 1,
    governorateId: 'gov-1',
    directorateId: 'dir-1',
    localityId: 'loc-1',
    basin: 'B1',
    parcel: 'P1',
    area: 10,
    areaUnitId: 1,
    agriculturalSectorId: 1,
    politicalClassificationId: 1,
  );

  setUpAll(() {
    EnvironmentConfig.setEnvironment(AppEnvironment.dev);
    registerFallbackValue(sampleFarmer);
  });

  setUp(() {
    mockFarmerRepo = MockFarmerRepository();
    when(() => mockFarmerRepo.getFarmer(any())).thenAnswer((_) async => sampleFarmer);
    when(() => mockFarmerRepo.getFarmers(name: any(named: 'name'), idNumber: any(named: 'idNumber')))
        .thenAnswer((_) async => []);
  });

  testWidgets('FarmFormScreen loads operator farmer when only farm is provided', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          farmerRepositoryProvider.overrideWithValue(mockFarmerRepo),
          authProvider.overrideWith((ref) => MockAuthNotifier(AuthState(
            status: AuthStatus.authenticated,
            session: AuthSession(
              token: 't', refreshToken: 'r', userId: 'u1', email: 'e', fullName: 'n',
              roles: ['SuperAdmin'],
            ),
          ))),
          governoratesProvider.overrideWith((ref) => []),
          referenceDataProvider.overrideWith((ref) => const ReferenceData(
            ownershipTypes: [],
            agriculturalSectors: [],
            politicalClassifications: [],
            areaUnits: [],
            relationshipToOwners: [],
            damageNatures: [],
            damageCategories: [],
            damageSubCategories: [],
            damageClassifications: [],
            damageCauseCategories: [],
            damageCauses: [],
            costingSheets: [],
          )),
          // We need to override the lookups as well since they depend on referenceDataProvider
          ownershipTypesProvider.overrideWith((ref) => []),
          agriculturalSectorsProvider.overrideWith((ref) => []),
          politicalClassificationsProvider.overrideWith((ref) => []),
          areaUnitsProvider.overrideWith((ref) => []),
          relationshipToOwnersProvider.overrideWith((ref) => []),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: FarmFormScreen(farm: sampleFarm),
        ),
      ),
    );

    // Should show loading initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the async load to finish
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // After loading, should show the form
    expect(find.text('Test Farm'), findsOneWidget);
    verify(() => mockFarmerRepo.getFarmer('f1')).called(1);
  });
}
