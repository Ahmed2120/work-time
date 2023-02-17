import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/attendance.dart';
import '../../../model/user.dart';
import '../../../provider/attendance_provider.dart';

class OverTime extends StatelessWidget {
  const OverTime({required this.user,Key? key}) : super(key: key);
final User user;
  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: true);
    final model=attendanceProvider.attendanceModel.last;

    return Row(children:[ Checkbox(value: model.overTimeStatus == 0 ? false : true, onChanged: (val){attendanceProvider.changeCheckBox(val!);
      final attendance = Attendance(
          id: model.id,
          workPlace: model.workPlace,
          userId: model.userId,
          weekEnd: model.weekEnd,
          todayDate: model.todayDate,
          weekId: model.weekId,
          weekStatus: model.weekStatus,
          status: model.status,
          salary: val?'${double.parse(user.salary)*1.5}':user.salary,
          overTimeStatus: val?1:0,
          salaryReceived: model.salaryReceived);
      attendanceProvider.updateAttendance(
          attendance: attendance);
      attendanceProvider.getAttendanceUserToDay(
          userId: model.userId);
    }), Text('إضافة سهرة'),]);
  }
}
