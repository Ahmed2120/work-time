import 'package:work_time/data/models/attendance.dart';

abstract class IAttendanceRepository {
  Future<int> insert(Attendance attendance);
  Future<int> insertP(int userId);
  Future<List<Attendance>> retrieve();
  Future<List<Attendance>> retrieveByUserId(int userId);
  Future<List<Attendance>> retrieveByUserIdDateTime(int userId, DateTime dateTime);
  Future<List<int>> retrieveWeeks(int userId);
  Future<List<Attendance>> retrieveAttendByWeekId({required int weekId, required int userId});
  Future<int> update({required Attendance attendance});
  Future<void> deleteByUserId(int userId);
}
