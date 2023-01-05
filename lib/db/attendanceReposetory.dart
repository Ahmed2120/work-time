import 'package:work_time/model/user.dart';

import '../model/attendance.dart';
import 'DatabaseHandler.dart';

class AttendanceRepository{
  String table_name = 'attendance';
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future insert(Attendance attendance) async{
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.insert(table_name, attendance.toMap());
    return result;
  }

  Future retrieve() async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name);
    return queryResults.map((e) => Attendance.fromMap(e)).toList();
  }

  Future retrieveByUserId(int userId) async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name, where: 'userId = ?', whereArgs: [userId]);
    return queryResults.map((e) => Attendance.fromMap(e)).toList();
  }

  Future delete(Attendance attendance) async{
    final db = await databaseHandler.initializeDB();
    db.delete(table_name, where: 'id = ?', whereArgs: [attendance.id]);
  }
}