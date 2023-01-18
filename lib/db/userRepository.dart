import 'package:work_time/model/user.dart';

import 'DatabaseHandler.dart';

class UserRepository{
  String table_name = 'users';
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future insert(User user) async{
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.insert(table_name, user.toMap());
    return result;
  }

  Future retrieve({int trash = 0}) async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name,where: 'isDeleted = ?',whereArgs: [trash]);
    return queryResults.map((e) => User.fromMap(e)).toList();
  }
  Future<List<String>> retrieveSalaries() async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("SELECT DISTINCT salary FROM $table_name WHERE isDeleted = ? ",[0]);
    return queryResults.map((e) => e['salary'] as String).toList();
  }

  Future update({required User user}) async {
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.update(table_name,user.toMap() ,where: 'id = ?', whereArgs: [user.id!]);
    return result;
  }

  Future delete(User user) async{
    final db = await databaseHandler.initializeDB();
    db.delete(table_name, where: 'id = ?', whereArgs: [user.id]);
  }
}