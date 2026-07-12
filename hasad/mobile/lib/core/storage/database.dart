import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('FarmerLocal')
class Farmers extends Table {
  TextColumn get id => text()(); // local UUID
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text().withLength(max: 200)();
  TextColumn get nationalId => text().withLength(max: 20)();
  TextColumn get phoneNumber => text().withLength(max: 20)();
  TextColumn get address => text().withLength(max: 500)();
  
  // Optimistic concurrency token
  TextColumn get rowVersion => text().withDefault(const Constant(''))();

  // Sync Status: pending, syncing, completed, failed
  TextColumn get syncStatus => text().withDefault(const Constant('completed'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get localId => text()();
  TextColumn get entityType => text()(); // 'farmer'
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get data => text()(); // JSON payload
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Farmers, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withExecutor(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Add rowVersion column to Farmers table
        await m.addColumn(farmers, farmers.rowVersion);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
