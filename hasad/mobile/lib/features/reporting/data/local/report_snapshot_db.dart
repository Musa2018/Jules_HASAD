import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalReportSnapshotDb {
  static final LocalReportSnapshotDb instance = LocalReportSnapshotDb._init();
  static Database? _database;

  LocalReportSnapshotDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('report_snapshots.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE LocalReportSnapshots (
            SnapshotId INTEGER PRIMARY KEY AUTOINCREMENT,
            ReportId TEXT NOT NULL,
            Title TEXT NOT NULL,
            FilterSummary TEXT,
            ColumnsJson TEXT NOT NULL,
            DataJson TEXT NOT NULL,
            SummaryJson TEXT,
            SavedAt TEXT NOT NULL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE LocalReportTemplates (
            ReportId TEXT PRIMARY KEY,
            Title TEXT NOT NULL,
            Category TEXT NOT NULL,
            ConfigJson TEXT NOT NULL,
            LastSyncedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> saveSnapshot({
    required String reportId,
    required String title,
    String? filterSummary,
    required List<String> columns,
    required List<Map<String, dynamic>> data,
    Map<String, dynamic>? summary,
  }) async {
    final db = await instance.database;
    return await db.insert('LocalReportSnapshots', {
      'ReportId': reportId,
      'Title': title,
      'FilterSummary': filterSummary,
      'ColumnsJson': jsonEncode(columns),
      'DataJson': jsonEncode(data),
      'SummaryJson': summary != null ? jsonEncode(summary) : null,
      'SavedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getSnapshots() async {
    final db = await instance.database;
    return await db.query('LocalReportSnapshots', orderBy: 'SavedAt DESC');
  }

  Future<int> deleteSnapshot(int snapshotId) async {
    final db = await instance.database;
    return await db.delete(
      'LocalReportSnapshots',
      where: 'SnapshotId = ?',
      whereArgs: [snapshotId],
    );
  }

  Future<int> saveTemplate({
    required String reportId,
    required String title,
    required String category,
    required String configJson,
  }) async {
    final db = await instance.database;
    return await db.insert(
      'LocalReportTemplates',
      {
        'ReportId': reportId,
        'Title': title,
        'Category': category,
        'ConfigJson': configJson,
        'LastSyncedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTemplates() async {
    final db = await instance.database;
    return await db.query('LocalReportTemplates');
  }
}
