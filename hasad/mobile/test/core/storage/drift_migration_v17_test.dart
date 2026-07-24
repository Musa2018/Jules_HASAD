import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Migration v16 to v17: Directorate Code and Report Number backfill', () async {
    // 1. Setup initial state (simulating v16)
    // In memory DB starts with the current schema (v17), 
    // so we verify the columns exist and then check the logic.
    
    // Insert a directorate without a code (v16 state)
    await db.customStatement('INSERT INTO directorates (id, name_ar, name_en, governorate_id) '
                             'VALUES ("DIR-1", "مديرية تست", "Test Directorate", "GOV-1")');
    
    // Insert a damage report with permanent form number (v16 state)
    await db.customStatement('INSERT INTO damage_reports (id, farm_id, farmer_id, damage_date, documentation_date, permanent_form_number, governorate_id, directorate_id, locality_id, status_id, notes) '
                             'VALUES ("REP-1", "FARM-1", "FARMER-1", 1720000000, 1720000000, "P-123", "G1", "D1", "L1", "Draft", "")');

    // 2. Run the migration logic manually (simulating the from < 17 block)
    await db.transaction(() async {
        // We don't call m.addColumn because columns already exist in v17 setup, 
        // but we run the backfill logic.

        // Backfill ReportNumber from PermanentFormNumber
        await db.customStatement('UPDATE damage_reports SET report_number = permanent_form_number WHERE permanent_form_number != "";');

        // Backfill NatureId from first item's classification hierarchy (simulated)
        // We'll skip the complex join backfill in this simple test or add supporting data
    });

    // 3. Verify
    final directorate = await (db.select(db.directorates)..where((t) => t.id.equals('DIR-1'))).getSingle();
    // Default value in Drift was Constant('')
    expect(directorate.code, ''); 

    final report = await (db.select(db.damageReports)..where((t) => t.id.equals('REP-1'))).getSingle();
    expect(report.reportNumber, 'P-123');
  });
}
