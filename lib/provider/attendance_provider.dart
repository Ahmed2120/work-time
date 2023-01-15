import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time/utility/global_methods.dart';

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

  Future<Attendance> getAttendByUserAndDate({required int userId}) async {
    final attendanceRepository = AttendanceRepository();
    final List<Attendance> attend = await attendanceRepository.retrieveByUserIdDateTime(userId);
    return attend.last;

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


  setWeekId() async{
    final prefs = await SharedPreferences.getInstance();

    final String? endWeek = prefs.getString('endWeek');
    print(endWeek);
    int weekId=0;
    if(_attendanceUser.isEmpty){
      return weekId=1;
    }
    else if(endWeek == null){
      final getEndWeek = GlobalMethods.getWeekDay(DateTime.parse(_attendanceUser.last.todayDate));
      prefs.setString('endWeek', '$getEndWeek');
      return weekId=1;
    }
    else if(DateTime.parse(endWeek).isBefore(DateTime.now())){
      final getEndWeek = GlobalMethods.getWeekDay(DateTime.now());
        weekId=_attendanceUser.last.weekId+1;
        prefs.clear();
        prefs.setString('endWeek', '$getEndWeek');
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

  void getWeeks(int userId) async{
    _weeksList=[];
    final attendanceRepository = AttendanceRepository();
    _weeksList = await attendanceRepository.retrieveWeeks(userId);
    notifyListeners();
  }
  
  Future<void> getWeeklyAttendance(int userId) async{
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
