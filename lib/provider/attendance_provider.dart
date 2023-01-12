import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';

import '../model/attendance.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _attendanceList = [];

  List<Attendance> get attendanceList {
    return _attendanceList;
  }

  Future<void> addAttendance(Attendance attendance) async {
    final attendanceRepository = AttendanceRepository();

    final int userId = await attendanceRepository.insert(attendance);
    //  attendance.id = userId;
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

  void getAttendanceUserToDay({required int userId}) async {
    final attendanceRepository = AttendanceRepository();
    _attendanceModel =
        await attendanceRepository.retrieveByUserIdDateTime(userId);

    if (attendanceModel.isNotEmpty) {
      DateTime dateTime = DateTime.parse(attendanceModel.last.todayDate);
      date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      time =
          "${dateTime.hour < 10 ? '0${dateTime.hour}' : '${dateTime.hour}'}:${dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}'}:${dateTime.second < 10 ? '0${dateTime.second}' : '${dateTime.second}'}";
      if (attendanceModel.last.status == 1) {
        attendanceText = 'حاضر';
      } else {
        attendanceText = 'غائب';
      }
    }
    notifyListeners();
  }

  Future<void> updateAttendance({required Attendance attendance}) async {
    final attendanceRepository = AttendanceRepository();
    attendanceRepository.update(attendance: attendance);
    notifyListeners();
  }

  //AttendanceList for each user
   List<Attendance> _attendanceUser= [];
  List<Attendance> get attendanceUser {
    return _attendanceUser;
  }
  Future getAttendanceUser(int userId)async{
    final attendanceRepository = AttendanceRepository();
    _attendanceUser=await attendanceRepository.retrieveByUserId(userId);
    notifyListeners();
  }


  int setWeekId(String day){
    int weekId=0;
    if(_attendanceUser.isEmpty){
      return weekId=1;
    }
    else if(day=='السبت'){
      weekId=_attendanceUser.last.weekId+1;
      return weekId;
    }
    else{
      weekId=_attendanceUser.last.weekId;
      return weekId;
    }
  }

  List<int> _weeksList= [];
  final Map<int, List<Attendance>> _weekAttendanceMap = {};
  List<int> get weeksList {
    return _weeksList;
  }
  Map<int, List<Attendance>> get weekAttendanceMap {
    return _weekAttendanceMap;
  }

  void getWeeks() async{
    _weeksList=[];
    final attendanceRepository = AttendanceRepository();
    _weeksList = await attendanceRepository.retrieveWeeks();
    notifyListeners();
  }
  
  void getWeeklyAttendance(int userId) async{
    final attendanceRepository = AttendanceRepository();
    for(var i in _weeksList){
      final x = await attendanceRepository.retrieveAttendByWeekId(weekId: i, userId: userId);
      _weekAttendanceMap.addEntries([MapEntry(i, x)]);
    }
  }

  double sumSalaryReceived(List<Attendance> list){
    double x=0;
    for(var model in list){
      x+=double.parse(model.salaryReceived);
    }
    return x;
  }

  double salary=0;
  setSalary(double value){
    salary=value;
    notifyListeners();
  }

  double sumSalaryRemain(List<Attendance> list){
    double x=0;
    double totalSalary=0;
    for(var model in list){
      if(model.status==1){
        totalSalary=totalSalary+salary;
      }
    }
    x=totalSalary-sumSalaryReceived(list);
    return x;
  }


  getAttendanceList()async{
    final attendanceRepository = AttendanceRepository();
    _attendanceList = await attendanceRepository.retrieve();
    notifyListeners();
  }
}
