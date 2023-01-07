import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';

import '../model/attendance.dart';

class AttendanceProvider with ChangeNotifier{
  final List<Attendance> _attendanceList=[];

  List<Attendance> get attendanceList {
    return _attendanceList;
}

  Future<void> addAttendance(Attendance attendance) async {
    final attendanceRepository = AttendanceRepository();

    final int userId = await attendanceRepository.insert(attendance);
    attendance.id = userId;
    _attendanceList.add(attendance);

    notifyListeners();
  }

  late Attendance? _attendanceModel;
  Attendance? get attendanceModel{
    return _attendanceModel;
  }
  void getAttendanceUserToDay({required int userId,required String date})async{
    final attendanceRepository = AttendanceRepository();
    List<Attendance> list =await attendanceRepository.retrieveByUserIdDateTime(userId, date);
_attendanceModel=list[0];
print(_attendanceModel);
notifyListeners();

  }
}