import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'dgi.db'),
      onCreate: (database, version) async {
        Batch batch = database.batch();
        batch.execute("CREATE TABLE users(Id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, job TEXT, salary TEXT)",);
        batch.execute("CREATE TABLE attendance(Id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, todayDate TEXT, status TEXT, salaryReceived TEXT)",);

        await batch.commit();
      },
      version: 1,
    );
  }

  Future<List<Object?>> clearData() async {
    final Database db = await initializeDB();
    Batch batch = db.batch();
    batch.execute("delete from users");
    return await batch.commit();
  }

}