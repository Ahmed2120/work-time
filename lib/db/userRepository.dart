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

  Future retrieve() async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name);
    print(queryResults);
    return queryResults.map((e) => User.fromMap(e)).toList();
  }

  Future delete(User user) async{
    final db = await databaseHandler.initializeDB();
    db.delete(table_name, where: 'id = ?', whereArgs: [user.id]);
  }
}