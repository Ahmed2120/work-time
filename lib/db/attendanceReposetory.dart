
import '../model/attendance.dart';
import 'DatabaseHandler.dart';
import "package:collection/collection.dart";


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

  Future retrieveByUserIdDateTime(int userId,DateTime dateTime) async{
    final db = await databaseHandler.initializeDB();
    final String date='${dateTime.year}-${dateTime.month<10?'0${dateTime.month}':'${dateTime.month}'}-${dateTime.day<10?'0${dateTime.day}':'${dateTime.day}'}';
    final List<Map<String, Object?>> queryResults = await db.query(table_name, where: 'userId = ? and todayDate LIKE ?', whereArgs: [userId,'%$date%']);
    return queryResults.map((e) => Attendance.fromMap(e)).toList();
  }

  Future<List<int>> retrieveWeeks(int userId) async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("SELECT DISTINCT weekId FROM $table_name WHERE userId = ? ",[userId]);
    return queryResults.map((e) => e['weekId'] as int).toList();
  }

  Future<List<Attendance>> retrieveAttendByWeekId({required int weekId, required int userId}) async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name, where: "weekId = ? and userId = ?", whereArgs: [weekId, userId]);
    return queryResults.map((e) => Attendance.fromMap(e)).toList();
  }

  Future update({required Attendance attendance}) async {
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.update(table_name,attendance.toMap() ,where: 'id = ?', whereArgs: [attendance.id!]);
    return result;
  }

  Future deleteByUserId(int userId) async{
    final db = await databaseHandler.initializeDB();
    db.delete(table_name, where: 'userId = ?', whereArgs: [userId]);
  }
}