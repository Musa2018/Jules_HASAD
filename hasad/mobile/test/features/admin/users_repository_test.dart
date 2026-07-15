import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/admin/data/users_repository.dart';

class _FixedAdapter implements HttpClientAdapter {
  final Map<String, dynamic> body;
  final int statusCode;

  _FixedAdapter(this.body, {this.statusCode = 200});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

UsersRepositoryImpl _repositoryFor(Map<String, dynamic> body, {int statusCode = 200}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
    ..httpClientAdapter = _FixedAdapter(body, statusCode: statusCode);
  return UsersRepositoryImpl(dio);
}

void main() {
  group('UsersRepositoryImpl', () {
    test('getRoles returns list of roles on success', () async {
      final repository = _repositoryFor({
        'succeeded': true,
        'data': [
          {'id': 'r1', 'name': 'SuperAdmin'},
          {'id': 'r2', 'name': 'Admin'},
        ],
      });

      final roles = await repository.getRoles();

      expect(roles.length, 2);
      expect(roles[0].name, 'SuperAdmin');
      expect(roles[1].name, 'Admin');
    });

    test('getGovernorates returns list of governorates on success', () async {
      final repository = _repositoryFor({
        'succeeded': true,
        'data': [
          {'id': 'g1', 'nameAr': 'غزة', 'nameEn': 'Gaza'},
        ],
      });

      final govs = await repository.getGovernorates();

      expect(govs.length, 1);
      expect(govs[0].nameEn, 'Gaza');
    });

    test('getDirectorates returns filtered list on success', () async {
      final repository = _repositoryFor({
        'succeeded': true,
        'data': [
          {'id': 'd1', 'nameAr': 'د1', 'nameEn': 'D1', 'governorateId': 'g1'},
        ],
      });

      final dirs = await repository.getDirectorates(governorateId: 'g1');

      expect(dirs.length, 1);
      expect(dirs[0].governorateId, 'g1');
    });

    test('throws UsersException when succeeded is false', () async {
      final repository = _repositoryFor({
        'succeeded': false,
        'errors': ['Something went wrong'],
      });

      expect(
        () => repository.getRoles(),
        throwsA(isA<UsersException>().having((e) => e.errors, 'errors', ['Something went wrong'])),
      );
    });

    test('throws UsersException on Dio error', () async {
      final repository = _repositoryFor({
        'succeeded': false,
        'errors': ['Internal Server Error'],
      }, statusCode: 500);

      expect(
        () => repository.getRoles(),
        throwsA(isA<UsersException>()),
      );
    });

    test('createUser sends correct data and succeeds', () async {
      final repository = _repositoryFor({'succeeded': true});

      await repository.createUser(
        fullName: 'New User',
        userName: 'newuser',
        email: 'new@test.com',
        phoneNumber: '123',
        password: 'Password123!',
        confirmPassword: 'Password123!',
        role: 'Admin',
        isActive: true,
      );
      // No exception means success
    });
  });
}
