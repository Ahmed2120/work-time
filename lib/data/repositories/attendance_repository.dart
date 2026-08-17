import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';

class AttendanceRepository implements IAttendanceRepository {
  final String _tableName = 'attendance';
  final DatabaseHandler databaseHandler;

  AttendanceRepository({DatabaseHandler? handler}) 
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<int> insert(Attendance attendance) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(_tableName, attendance.toMap());
    } catch (e) {
      print("Error inserting attendance: $e");
      return 0;
    }
  }

  @override
  Future<int> insertP(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.rawInsert(
          """INSERT INTO $_tableName($userId) 
          SELECT 5, 'text to insert'
          WHERE NOT EXISTS(SELECT 1 FROM memos WHERE id = 5 AND text = 'text to insert')""");
    } catch (e) {
      print("Error in insertP attendance: $e");
      return 0;
    }
  }

  @override
  Future<List<Attendance>> retrieve() async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.query(_tableName);
      return queryResults.map((e) => Attendance.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving attendance: $e");
      return [];
    }
  }

  @override
  Future<List<Attendance>> retrieveByUserId(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.query(_tableName, where: 'userId = ?', whereArgs: [userId]);
      return queryResults.map((e) => Attendance.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving attendance by user id: $e");
      return [];
    }
  }

  @override
  Future<List<Attendance>> retrieveByUserIdDateTime(int userId, DateTime dateTime) async {
    try {
      final db = await databaseHandler.initializeDB();
      final String date = '${dateTime.year}-${dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}'}-${dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}'}';
      final List<Map<String, Object?>> queryResults = await db.query(_tableName, where: 'userId = ? and todayDate LIKE ?', whereArgs: [userId, '%$date%']);
      return queryResults.map((e) => Attendance.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving attendance by user id and date: $e");
      return [];
    }
  }

  @override
  Future<List<int>> retrieveWeeks(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      // Order by the earliest date recorded in each week so older weeks come first
      final List<Map<String, Object?>> queryResults = await db.rawQuery(
        "SELECT DISTINCT weekId FROM $_tableName WHERE userId = ? ORDER BY weekEnd ASC, weekId ASC",
        [userId],
      );
      return queryResults.map((e) => e['weekId'] as int).toList();
    } catch (e) {
      print("Error retrieving weeks: $e");
      return [];
    }
  }

  @override
  Future<List<Attendance>> retrieveAttendByWeekId({required int weekId, required int userId}) async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.query(_tableName, where: "weekId = ? and userId = ?", whereArgs: [weekId, userId]);
      return queryResults.map((e) => Attendance.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving attendance by week id: $e");
      return [];
    }
  }

  @override
  Future<int> update({required Attendance attendance}) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.update(_tableName, attendance.toMap(), where: 'id = ?', whereArgs: [attendance.id!]);
    } catch (e) {
      print("Error updating attendance: $e");
      return 0;
    }
  }

  @override
  Future<void> deleteByUserId(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.delete(_tableName, where: 'userId = ?', whereArgs: [userId]);
    } catch (e) {
      print("Error deleting attendance by user id: $e");
    }
  }
}

