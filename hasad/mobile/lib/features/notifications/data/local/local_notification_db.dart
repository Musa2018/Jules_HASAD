import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalNotificationDb {
  static final LocalNotificationDb instance = LocalNotificationDb._init();
  static Database? _database;

  LocalNotificationDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
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
          CREATE TABLE LocalNotifications (
            Id TEXT PRIMARY KEY, 
            Title TEXT NOT NULL,
            Body TEXT NOT NULL,
            Category TEXT NOT NULL,
            PayloadJson TEXT,
            IsRead INTEGER NOT NULL DEFAULT 0,
            ReceivedAt TEXT NOT NULL,
            SyncStatus INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('CREATE INDEX IX_LocalNotifications_IsRead ON LocalNotifications(IsRead)');
      },
    );
  }

  Future<int> insertNotification(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert(
      'LocalNotifications',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await instance.database;
    return await db.query('LocalNotifications', orderBy: 'ReceivedAt DESC');
  }

  Future<void> markAsRead(String id) async {
    final db = await instance.database;
    await db.update(
      'LocalNotifications',
      {'IsRead': 1, 'SyncStatus': 0},
      where: 'Id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM LocalNotifications WHERE IsRead = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getUnsyncedReadStatus() async {
    final db = await instance.database;
    return await db.query('LocalNotifications', where: 'SyncStatus = 0 AND IsRead = 1');
  }

  Future<void> updateSyncStatus(String id, int status) async {
    final db = await instance.database;
    await db.update(
      'LocalNotifications',
      {'SyncStatus': status},
      where: 'Id = ?',
      whereArgs: [id],
    );
  }
}
