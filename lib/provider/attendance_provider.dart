import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:work_time/db/attendanceReposetory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time/utility/global_methods.dart';

import '../cash_helper.dart';
import '../model/attendance.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _attendanceList = [];

  List<Attendance> get attendanceList {
    return _attendanceList;
  }

  Future<void> addAttendance(Attendance attendance) async {
    final attendanceRepository = AttendanceRepository();
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
    final attendanceRepository = AttendanceRepository();
    _attendanceModel =
        await attendanceRepository.retrieveByUserIdDateTime(userId,dateTimeAttendance);
    if (attendanceModel.isNotEmpty) {
      DateTime dateTime = DateTime.parse(attendanceModel.last.todayDate);
      date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      time =
          "${GlobalMethods.getTimeFormat(DateTime.parse(attendanceModel.last.todayDate))}";
      if (attendanceModel.last.status == 1) {
        attendanceText = 'حاضر';
      } else {
        attendanceText = 'غائب';
      }
    }
    notifyListeners();
  }

  DateTime dateTimeAttendance=DateTime.now();
  changeDate(DateTime? _dateTime){
    if(_dateTime==null)return;
    dateTimeAttendance=_dateTime;
    notifyListeners();
  }

  Future<Attendance> getAttendByUserAndDate({required int userId}) async {
    final attendanceRepository = AttendanceRepository();
    final List<Attendance> attend = await attendanceRepository.retrieveByUserIdDateTime(userId,dateTimeAttendance);
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

    DateTime? _endWeekUser;
    if(attendanceUser.isNotEmpty) _endWeekUser=GlobalMethods.getWeekDay(dateTimeAttendance);
    int weekId=0;
    if(_attendanceUser.isEmpty){
      return weekId=1;
    }
    int maxWeekId=0;
    for(var element in attendanceUser){
      if(element.weekId>maxWeekId)maxWeekId=element.weekId;
      if(element.weekEnd=="$_endWeekUser"){
        weekId =element.weekId;
        print('=========== weekId $weekId');
        return weekId;
      }
    }
    if(weekId==0){
      weekId=maxWeekId+1;
      print('=========== weekId $weekId');
      return weekId;
    }
  }

  List<int> _weeksList= [];
   Map<int, List<Attendance>> _weekAttendanceMap = {};
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
_weekAttendanceMap={};
    for(var i in _weeksList){
      final x = await attendanceRepository.retrieveAttendByWeekId(weekId: i, userId: userId);
      x.sort((a, b) => a.todayDate.compareTo(b.todayDate));
      _weekAttendanceMap.addEntries([MapEntry(i, x)]);
    }
    sort();
    notifyListeners();
  }

  double sumSalaryReceived(List<Attendance> list){
    double x=0;
    for(var model in list){
      x+=double.parse(model.salaryReceived);
    }
    return x;
  }

double totalSalary(List<Attendance> list){
  double totalSalary=0;
  for(var model in list){
    totalSalary=totalSalary+double.parse(model.salary);
  }
  return totalSalary;
}

  getAttendanceList()async{
    final attendanceRepository = AttendanceRepository();
    _attendanceList = await attendanceRepository.retrieve();
    notifyListeners();
  }

  bool isOverTimeStatus=false;
  void changeCheckBox(bool newVal){
    isOverTimeStatus=newVal;
    notifyListeners();
  }

  void sort(){
    if(_weekAttendanceMap.isNotEmpty) {
      _weekAttendanceMap = Map.fromEntries(_weekAttendanceMap.entries.toList()
        ..sort((e1, e2) => e1.value[0].weekEnd.compareTo(e2.value[0].weekEnd)));
      _weeksList = _weekAttendanceMap.keys.toList();
    }
    notifyListeners();
  }

  bool trial=false;

  checkTrial(){
    trial=CashHelper.getData(key:'trial')??false;
    notifyListeners();
  }
}