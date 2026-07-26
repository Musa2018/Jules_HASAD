import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:mobile/features/farmers/presentation/farmers_providers.dart';
import 'package:mobile/features/auth/presentation/auth_providers.dart';
import 'package:mobile/features/auth/domain/auth_session.dart';
import 'package:drift/native.dart';
import 'dart:io';

void main() {
  test('Investigate Farmer Loading Flow', () async {
    // This test is meant to be run in an environment where we can access the DB
    // Since we are in a test environment, we might need to mock things or 
    // point to the actual SQLite file if we pull it.
    
    final dbFile = File('local_db.sqlite');
    if (!dbFile.existsSync()) {
      print('Database file not found locally. Please pull it first.');
      return;
    }

    final db = AppDatabase.executor(NativeDatabase(dbFile));
    
    final farmersCount = await db.select(db.farmers).get().then((v) => v.length);
    final farmsCount = await db.select(db.farms).get().then((v) => v.length);
    final localitiesCount = await db.select(db.localities).get().then((v) => v.length);
    final directoratesCount = await db.select(db.directorates).get().then((v) => v.length);

    print('Farmers count: $farmersCount');
    print('Farms count: $farmsCount');
    print('Localities count: $localitiesCount');
    print('Directorates count: $directoratesCount');

    // Check a few farmers to see their governorate/locality
    if (farmersCount > 0) {
      final sampleFarmers = await db.select(db.farmers).limit(5).get();
      for (var f in sampleFarmers) {
        print('Farmer ID: ${f.id}, Gov: ${f.governorateId}, Loc: ${f.localityId}');
      }
    }
    
    await db.close();
  });
}
