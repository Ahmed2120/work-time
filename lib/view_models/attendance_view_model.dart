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
      time = "${GlobalMethods.getTimeFormat(DateTime.parse(attendanceModel.last.todayDate))}";
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

  setWeekId() async {
    int maxWeekId = 0;
    if (_attendanceUser.isNotEmpty) {
      for (var element in attendanceUser) {
        if (element.weekId > maxWeekId) {
          maxWeekId = element.weekId;
        }
      }
    } else {
      return 1;
    }
    return maxWeekId + 1;
  }

  // Weeks list
  List<int> _weeksList = [];
  List<int> get weeksList => _weeksList;

  Future getWeeks(int userId) async {
    _weeksList = await attendanceRepository.retrieveWeeks(userId);
    notifyListeners();
  }

  List<Attendance> _weeklyAttendance = [];
  List<Attendance> get weeklyAttendance => _weeklyAttendance;

  Future getWeeklyAttendance(int userId) async {
    _weeklyAttendance = await attendanceRepository.retrieveByUserId(userId);
    notifyListeners();
  }

  // Groups weeklyAttendance by weekId
  Map<int, List<Attendance>> get weekAttendanceMap {
    final Map<int, List<Attendance>> map = {};
    for (var attendance in _weeklyAttendance) {
      map.putIfAbsent(attendance.weekId, () => []);
      map[attendance.weekId]!.add(attendance);
    }
    return map;
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
