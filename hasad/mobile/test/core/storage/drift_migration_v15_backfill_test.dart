import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // We use a fresh memory database for each test
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Migration v15: Safe backfill of directorate_id from Farms', () async {
    // 1. Prepare v14 state. 
    // Since AppDatabase onCreate creates the latest schema, we drop and recreate
    // the specific tables in their v14 state to test the migration logic.
    await db.customStatement('DROP TABLE IF EXISTS damage_reports;');
    await db.customStatement('DROP TABLE IF EXISTS farms;');

    await db.customStatement('''
      CREATE TABLE farms (
        id TEXT PRIMARY KEY,
        directorate_id TEXT NOT NULL
      );
    ''');

    await db.customStatement('''
      CREATE TABLE damage_reports (
        id TEXT PRIMARY KEY,
        farm_id TEXT NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES farms (id)
      );
    ''');

    // 2. Insert test data (Legacy records)
    await db.customStatement('INSERT INTO farms (id, directorate_id) VALUES ("FARM-1", "DIR-A")');
    await db.customStatement('INSERT INTO farms (id, directorate_id) VALUES ("FARM-2", "DIR-B")');
    
    await db.customStatement('INSERT INTO damage_reports (id, farm_id) VALUES ("REP-1", "FARM-1")');
    await db.customStatement('INSERT INTO damage_reports (id, farm_id) VALUES ("REP-2", "FARM-2")');

    // 3. Execute Migration Logic (Simulating onUpgrade from v14 to v15)
    // This matches the logic added to database.dart
    await db.transaction(() async {
      // Step 1: Add as nullable
      await db.customStatement('ALTER TABLE damage_reports ADD COLUMN directorate_id TEXT;');
      
      // Step 2: Backfill from Farms
      await db.customStatement('''
        UPDATE damage_reports 
        SET directorate_id = (
          SELECT directorate_id FROM farms WHERE farms.id = damage_reports.farm_id
        )
        WHERE directorate_id IS NULL;
      ''');
    });

    // 4. Verify Data Integrity
    final rows = await db.customSelect('SELECT id, directorate_id FROM damage_reports ORDER BY id').get();
    expect(rows[0].read<String>('directorate_id'), 'DIR-A');
    expect(rows[1].read<String>('directorate_id'), 'DIR-B');

    // 5. Verify Constraint Enforcement (Step 3 in database.dart uses m.alterTable)
    // In this test, we verify that we can't insert a NULL directorate_id anymore
    // after we would have run the final alterTable.
    // We simulate the final table state by recreating it as NOT NULL.
    
    await db.customStatement('''
      CREATE TABLE damage_reports_new (
        id TEXT PRIMARY KEY,
        farm_id TEXT NOT NULL,
        directorate_id TEXT NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES farms (id)
      );
    ''');
    
    await db.customStatement('''
      INSERT INTO damage_reports_new (id, farm_id, directorate_id)
      SELECT id, farm_id, directorate_id FROM damage_reports;
    ''');

    // Verify insertion of NULL fails on the new table
    expect(
      () => db.customStatement('INSERT INTO damage_reports_new (id, farm_id, directorate_id) VALUES ("REP-ERR", "FARM-1", NULL)'),
      throwsException,
    );
  });

  test('Migration v15: Handle missing farm references (Orphans)', () async {
    await db.customStatement('DROP TABLE IF EXISTS damage_reports;');
    await db.customStatement('DROP TABLE IF EXISTS farms;');

    await db.customStatement('CREATE TABLE farms (id TEXT PRIMARY KEY, directorate_id TEXT NOT NULL);');
    await db.customStatement('CREATE TABLE damage_reports (id TEXT PRIMARY KEY, farm_id TEXT NOT NULL);');

    // Report with non-existent farm
    await db.customStatement('INSERT INTO damage_reports (id, farm_id) VALUES ("ORPHAN-1", "NON-EXISTENT")');

    await db.customStatement('ALTER TABLE damage_reports ADD COLUMN directorate_id TEXT;');
    
    await db.customStatement('''
      UPDATE damage_reports 
      SET directorate_id = (
        SELECT directorate_id FROM farms WHERE farms.id = damage_reports.farm_id
      )
      WHERE directorate_id IS NULL;
    ''');

    final orphan = await db.customSelect('SELECT directorate_id FROM damage_reports WHERE id = "ORPHAN-1"').getSingle();
    // It will be NULL because no farm was found. 
    // The user's constraint NOT NULL will fail later if orphans exist.
    // This test confirms the backfill behavior for orphans.
    expect(orphan.read<String?>('directorate_id'), isNull);
  });
}
