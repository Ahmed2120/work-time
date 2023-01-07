import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';

import '../model/attendance.dart';

class AttendanceProvider with ChangeNotifier{
  final List<Attendance> _attendanceList=[];

  List<Attendance> get attendanceList {
    return _attendanceList;
}

  Future<void> addAttendance(Attendance attendance) async {
    final userRepository = AttendanceRepository();

    final int userId = await userRepository.insert(attendance);
    attendance.id = userId;
    _attendanceList.add(attendance);

    notifyListeners();
  }
}