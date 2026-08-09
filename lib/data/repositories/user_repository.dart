import 'package:work_time/data/models/user.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final String _tableName = 'users';
  final DatabaseHandler databaseHandler;

  UserRepository({DatabaseHandler? handler}) 
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<int> insert(User user) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(_tableName, user.toMap());
    } catch (e) {
      print("Error inserting user: $e");
      return 0;
    }
  }

  @override
  Future<List<User>> retrieve({int trash = 0}) async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.query(_tableName, where: 'isDeleted = ?', whereArgs: [trash]);
      return queryResults.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving users: $e");
      return [];
    }
  }

  @override
  Future<List<String>> retrieveSalaries() async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.rawQuery("SELECT DISTINCT salary FROM $_tableName WHERE isDeleted = ? ", [0]);
      return queryResults.map((e) => e['salary'] as String).toList();
    } catch (e) {
      print("Error retrieving salaries: $e");
      return [];
    }
  }

  @override
  Future<int> update({required User user}) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.update(_tableName, user.toMap(), where: 'id = ?', whereArgs: [user.id!]);
    } catch (e) {
      print("Error updating user: $e");
      return 0;
    }
  }

  @override
  Future<void> delete(User user) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.delete(_tableName, where: 'id = ?', whereArgs: [user.id]);
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}

