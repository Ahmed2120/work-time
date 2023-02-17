import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/attendance.dart';
import '../../../provider/attendance_provider.dart';

class OverTime extends StatelessWidget {
  const OverTime({Key? key}) : super(key: key);

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
          salary: val?'${double.parse(model.salary)*1.5}':model.salary,
          overTimeStatus: val?1:0,
          salaryReceived: model.salaryReceived);
      attendanceProvider.updateAttendance(
          attendance: attendance);
      attendanceProvider.getAttendanceUserToDay(
          userId: model.userId);
    }), Text('إضافة سهرة'),]);
  }
}
