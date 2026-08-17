import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/core/utils/global_methods.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';

class AttendanceViewModel with ChangeNotifier {
  final IAttendanceRepository attendanceRepository;

  AttendanceViewModel({IAttendanceRepository? repository})
      : attendanceRepository = repository ?? sl<IAttendanceRepository>();

  List<Attendance> _attendanceList = [];

  List<Attendance> get attendanceList {
    return _attendanceList;
  }

  Future<void> addAttendance(Attendance attendance) async {
    await attendanceRepository.insert(attendance);
    _attendanceList.add(attendance);
    notifyListeners();
  }

  List<Attendance> _attendanceModel = [];

  List<Attendance> get attendanceModel {
    return _attendanceModel;
  }

  String date = '';
  String time = '';
  String attendanceText = 'غائب';

  Future getAttendanceUserToDay({required int userId}) async {
    _attendanceModel = await attendanceRepository.retrieveByUserIdDateTime(userId, dateTimeAttendance);
    if (attendanceModel.isNotEmpty) {
      DateTime dateTime = DateTime.parse(attendanceModel.last.todayDate);
      date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      time = GlobalMethods.getTimeFormat(DateTime.parse(attendanceModel.last.todayDate));
      if (attendanceModel.last.status == 1) {
        attendanceText = 'حاضر';
      } else {
        attendanceText = 'غائب';
      }
    } else {
      attendanceText = 'لم يسجل';
    }
    notifyListeners();
  }

  DateTime dateTimeAttendance = DateTime.now();
  void changeDate(DateTime? dateTime) {
    if (dateTime == null) return;
    dateTimeAttendance = dateTime;
    notifyListeners();
  }

  Future<Attendance?> getAttendByUserAndDate({required int userId}) async {
    final List<Attendance> attend =
        await attendanceRepository.retrieveByUserIdDateTime(userId, dateTimeAttendance);
    if (attend.isEmpty) return null;
    return attend.last;
  }

  Future<void> updateAttendance({required Attendance attendance}) async {
    await attendanceRepository.update(attendance: attendance);
    notifyListeners();
  }

  // AttendanceList for each user
  List<Attendance> _attendanceUser = [];
  List<Attendance> get attendanceUser {
    return _attendanceUser;
  }

  Future getAttendanceUser(int userId) async {
    _attendanceUser = await attendanceRepository.retrieveByUserId(userId);
    notifyListeners();
  }

  Future<int> setWeekId({required int userId, DateTime? date}) async {
    final list = await attendanceRepository.retrieveByUserId(userId);
    _attendanceUser = list;

    final DateTime targetDate = date ?? dateTimeAttendance;
    // Compute the Friday that ends the week containing targetDate
    final DateTime targetWeekEnd = GlobalMethods.getWeekEnd(targetDate);

    // 1. Reuse the active (unsettled) week whose weekEnd falls in the same calendar week
    for (var element in _attendanceUser) {
      if (element.weekStatus == 0) {
        final DateTime? stored = DateTime.tryParse(element.weekEnd);
        if (stored != null &&
            stored.year == targetWeekEnd.year &&
            stored.month == targetWeekEnd.month &&
            stored.day == targetWeekEnd.day) {
          return element.weekId;
        }
      }
    }

    // 2. New week period — assign new weekId
    int maxWeekId = 0;
    for (var element in _attendanceUser) {
      if (element.weekId > maxWeekId) maxWeekId = element.weekId;
    }
    return maxWeekId + 1;
  }

  // ─── Weeks list (weekId integers, ordered by DB) ─────────────────────────
  List<int> _weeksList = [];
  List<int> get weeksList => _weeksList;

  Future getWeeks(int userId) async {
    _weeksList = await attendanceRepository.retrieveWeeks(userId);
    await getWeeklyAttendance(userId);
    notifyListeners();
  }

  List<Attendance> _weeklyAttendance = [];
  List<Attendance> get weeklyAttendance => _weeklyAttendance;

  Future getWeeklyAttendance(int userId) async {
    _weeklyAttendance = await attendanceRepository.retrieveByUserId(userId);
    notifyListeners();
  }

  // Groups weeklyAttendance by weekId, with days sorted by date ascending
  Map<int, List<Attendance>> get weekAttendanceMap {
    final Map<int, List<Attendance>> map = {};
    for (var attendance in _weeklyAttendance) {
      map.putIfAbsent(attendance.weekId, () => []);
      map[attendance.weekId]!.add(attendance);
    }
    // Sort each week's days by todayDate ascending
    for (final key in map.keys) {
      map[key]!.sort((a, b) {
        final da = DateTime.tryParse(a.todayDate) ?? DateTime.now();
        final db = DateTime.tryParse(b.todayDate) ?? DateTime.now();
        return da.compareTo(db);
      });
    }
    return map;
  }

  /// Returns week groups sorted chronologically by their weekEnd date (oldest week first).
  /// Each group's days are already sorted by date ascending.
  List<List<Attendance>> get sortedWeekGroups {
    final map = weekAttendanceMap;
    final groups = map.values.toList();
    groups.sort((a, b) {
      final dateA = DateTime.tryParse(a.first.weekEnd) ?? DateTime.now();
      final dateB = DateTime.tryParse(b.first.weekEnd) ?? DateTime.now();
      return dateA.compareTo(dateB);
    });
    return groups;
  }

  // Calculates total salary for a week group
  double totalSalary(List<Attendance> weekGroup) {
    double total = 0;
    for (var attend in weekGroup) {
      total += double.tryParse(attend.salary) ?? 0;
    }
    return total;
  }

  // Calculates total salary received (drawn) for a week group
  double sumSalaryReceived(List<Attendance> weekGroup) {
    double total = 0;
    for (var attend in weekGroup) {
      total += double.tryParse(attend.salaryReceived) ?? 0;
    }
    return total;
  }

  int _checkBoxVal = 0;
  int get checkBoxVal => _checkBoxVal;

  void changeCheckBox(bool val) {
    _checkBoxVal = val ? 1 : 0;
    notifyListeners();
  }
}
