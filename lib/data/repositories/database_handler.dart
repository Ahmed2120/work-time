import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  // Singleton pattern
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler._internal();

  static Database? _database;

  Future<Database> initializeDB() async {
    if (_database != null) return _database!;
    
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'dgi.db'),
      onCreate: (database, version) async {
        Batch batch = database.batch();
        batch.execute("CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, job TEXT, salary TEXT, isDeleted INTEGER)");
        batch.execute("CREATE TABLE attendance(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, todayDate TEXT, weekId INTEGER, status INTEGER, weekStatus INTEGER,overTimeStatus INTEGER, salaryReceived TEXT,salary TEXT,workPlace TEXT,weekEnd TEXT)");
        batch.execute("CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dateCreated TEXT, color INTEGER)");
        batch.execute("CREATE TABLE projects(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, budgetAmount REAL, status TEXT NOT NULL DEFAULT 'active', createdAt TEXT NOT NULL)");
        await batch.commit();
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migration v1 → v2: add projects table for existing users
          await database.execute(
            "CREATE TABLE IF NOT EXISTS projects(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, budgetAmount REAL, status TEXT NOT NULL DEFAULT 'active', createdAt TEXT NOT NULL)",
          );
        }
      },
      version: 2,
    );
    return _database!;
  }

  Future<List<Object?>> clearData() async {
    final Database db = await initializeDB();
    Batch batch = db.batch();
    batch.execute("delete from users");
    return await batch.commit();
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
