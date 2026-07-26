import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/auth/authorization_service.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';

void main() {
  group('AuthorizationService', () {
    test('canManageFarmers returns true for SuperAdmin', () {
      final session = AuthSession(
        userId: '1',
        email: 'admin@test.com',
        fullName: 'Admin User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['SuperAdmin'],
        governorateId: null,
        directorateId: null,
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarmers(), isTrue);
    });

    test('canManageFarmers returns true for AgriculturalEngineer', () {
      final session = AuthSession(
        userId: '1',
        email: 'engineer@test.com',
        fullName: 'Engineer User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['AgriculturalEngineer'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarmers(), isTrue);
    });

    test('canManageFarmers returns false for FieldSurveyor', () {
      final session = AuthSession(
        userId: '1',
        email: 'surveyor@test.com',
        fullName: 'Surveyor User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['FieldSurveyor'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarmers(), isFalse);
    });

    test('canManageFarmers returns false for TechnicalReviewer', () {
      final session = AuthSession(
        userId: '1',
        email: 'reviewer@test.com',
        fullName: 'Reviewer User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['TechnicalReviewer'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarmers(), isFalse);
    });

    test('canManageFarms returns true for AgriculturalEngineer', () {
      final session = AuthSession(
        userId: '1',
        email: 'engineer@test.com',
        fullName: 'Engineer User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['AgriculturalEngineer'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarms(), isTrue);
    });

    test('canManageFarms returns false for FieldSurveyor', () {
      final session = AuthSession(
        userId: '1',
        email: 'surveyor@test.com',
        fullName: 'Surveyor User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['FieldSurveyor'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarms(), isFalse);
    });

    test('canManageFarms returns false for TechnicalReviewer', () {
      final session = AuthSession(
        userId: '1',
        email: 'reviewer@test.com',
        fullName: 'Reviewer User',
        token: 'token',
        refreshToken: 'refresh',
        roles: ['TechnicalReviewer'],
        governorateId: '1',
        directorateId: '1',
      );
      final service = AuthorizationService(session);
      expect(service.canManageFarms(), isFalse);
    });
  });
}
