import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/farms/data/farm_repository.dart';
import 'package:mobile/features/farms/data/reference_data_repository.dart';
import 'package:mobile/features/farms/data/remote_reference_data_repository.dart';
import 'package:mobile/features/farms/data/offline_first_reference_data_repository.dart';
import 'package:mobile/features/farmers/data/farmer_repository.dart';
import 'package:mobile/features/admin/data/users_repository.dart';
import 'package:mobile/features/agricultural_assistance/data/agricultural_assistance_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_repository.dart';
import 'package:mobile/features/damage_reports/data/repositories/damage_report_attachment_repository.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/features/location/data/location_repository.dart';
import 'package:mobile/core/storage/pull_sync_coordinator.dart';
import 'package:mobile/core/storage/background_sync_service.dart';
import 'package:mobile/core/storage/secure_storage_service.dart';
import 'package:mobile/core/network/token_refresher.dart';
// import 'package:mobile/features/damage_reports/domain/models/damage_report.dart'; // Removed as it was unused and causing issues

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFarmRepository extends Mock implements FarmRepository {}

class MockFarmerRepository extends Mock implements FarmerRepository {}

class MockDamageReportRepository extends Mock implements DamageReportRepository {}

class MockDamageReportAttachmentRepository extends Mock
    implements DamageReportAttachmentRepository {}

class MockConnectivity extends Mock implements Connectivity {}

class MockAuthorizationService extends Mock implements AuthorizationService {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockPullSyncCoordinator extends Mock implements PullSyncCoordinator {}

class MockRef extends Mock implements Ref {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockTokenRefresher extends Mock implements TokenRefresher {}

class MockUsersRepository extends Mock implements UsersRepository {}

class MockDio extends Mock implements Dio {}

class MockAgriculturalAssistanceRepository extends Mock implements AgriculturalAssistanceRepository {}

class MockBackgroundSyncService extends Mock implements BackgroundSyncService {}

class MockReferenceDataRepository extends Mock implements ReferenceDataRepository {}

class MockRemoteReferenceDataRepository extends Mock implements RemoteReferenceDataRepository {}

class MockOfflineFirstReferenceDataRepository extends Mock implements OfflineFirstReferenceDataRepository {}

class MockGoRouter extends Mock implements GoRouter {}
