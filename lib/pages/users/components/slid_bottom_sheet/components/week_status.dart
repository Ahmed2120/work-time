import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/attendance_provider.dart';

import '../../../../../../model/attendance.dart';

class WeekStatus extends StatelessWidget {
  const WeekStatus({required this.index,required this.weeks,Key? key}) : super(key: key);
  final int index;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final attendanceProvider=Provider.of<AttendanceProvider>(context);

    return attendanceProvider.weekAttendanceMap[weeks]![0].weekStatus == 0
        ? ElevatedButton(
        onPressed: () {
          final model = attendanceProvider
              .weekAttendanceMap[weeks]![0];
          final attendance = Attendance(
              id: model.id,
              userId: model.userId,
              weekEnd: model.weekEnd,
              todayDate: model.todayDate,
              weekId: model.weekId,
              weekStatus: 1,
              workPlace: model.workPlace,
              salary: model.salary,
              status: model.status,
              overTimeStatus: model.overTimeStatus,
              salaryReceived: model.salaryReceived);
          attendanceProvider.updateAttendance(
              attendance: attendance);
          attendanceProvider
              .getWeeklyAttendance(model.userId);
          attendanceProvider.getAttendanceUser(model.userId);
        },
        child: const Text('تصفية الحساب'))
        : const Text(
      'تم تصفية الحساب',
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF560404)),
    );
  }
}
