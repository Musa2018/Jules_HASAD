import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/core/utils/debug_logger.dart';
import 'package:mobile/features/farmers/data/remote_farmer_repository.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';

void main() {
  test('Capture Farmer Sync Payload (Simulated Failure)', () async {
    // We use a mock Dio but with the SyncDebugInterceptor to see exactly what is generated
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:5271/api'));
    dio.interceptors.add(SyncDebugInterceptor());
    
    final repo = RemoteFarmerRepository(dio);
    
    final farmer = Farmer(
      id: 'local-uuid-1234',
      idTypeId: 1,
      idNumber: '949585335',
      firstNameAr: 'أحمد',
      fatherNameAr: 'محمد',
      grandfatherNameAr: 'علي',
      familyNameAr: 'محمود',
      firstNameEn: 'Ahmed',
      fatherNameEn: 'Mohammed',
      grandfatherNameEn: 'Ali',
      familyNameEn: 'Mahmoud',
      birthDate: DateTime(1985, 5, 10),
      gender: Gender.unspecified, // This should trigger the backend 400
      phoneNumber: '0599123456',
      familySize: 5,
      governorateId: 'GOV-1',
      localityId: 'LOC-1',
      address: 'Test Address',
    );

    try {
      DebugLogger.logHeader('STARTING DEBUG TRACE');
      // We expect this to fail or hit our interceptor
      await repo.createFarmer(farmer);
    } catch (e) {
      // Expected failure
      DebugLogger.log('Caught expected error: $e');
    }
  });
}
