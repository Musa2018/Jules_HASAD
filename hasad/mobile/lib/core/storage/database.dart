import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('FarmerLocal')
class Farmers extends Table {
  TextColumn get id => text()(); // local UUID (ClientId)
  TextColumn get serverId => text().nullable()(); // Authority ID from server
  TextColumn get name => text().withLength(max: 200)();
  TextColumn get nationalId => text().withLength(max: 20)();
  TextColumn get phoneNumber => text().withLength(max: 20)();
  TextColumn get address => text().withLength(max: 500)();
  
  // Optimistic concurrency token
  TextColumn get rowVersion => text().withDefault(const Constant(''))();

  // Sync Status: pending, syncing, completed, failed, conflict
  TextColumn get syncStatus => text().withDefault(const Constant('completed'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmLocal')
class Farms extends Table {
  TextColumn get id => text()(); // ClientId
  TextColumn get serverId => text().nullable()(); // Server Id
  TextColumn get farmerId => text()(); // Farmer ClientId
  TextColumn get name => text().withLength(max: 200)();
  TextColumn get governorateId => text().withLength(max: 50)();
  TextColumn get localityId => text().withLength(max: 50)();
  RealColumn get landArea => real()();
  TextColumn get landAreaUnit => text().withLength(max: 20)();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get ownershipTypeId => text().withLength(max: 50)();

  TextColumn get rowVersion => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('completed'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get localId => text()();
  TextColumn get entityType => text()(); // 'farmer', 'farm'
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get data => text()(); // JSON payload
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Farmers, Farms, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withExecutor(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(farmers, farmers.rowVersion);
      }
      if (from < 3) {
        await m.addColumn(syncQueue, syncQueue.lastAttemptAt);
      }
      if (from < 4) {
        await m.createTable(farms);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
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
