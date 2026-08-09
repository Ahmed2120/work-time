import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../data/models/attendance.dart';
import '../../../data/models/user.dart';
import '../../../view_models/attendance_view_model.dart';

class OverTime extends StatelessWidget {
  const OverTime({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: true);
    final model = attendanceViewModel.attendanceModel.last;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: model.overTimeStatus != 0,
            activeColor: AppColors.accent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (val) {
              if (val == null) return;
              attendanceViewModel.changeCheckBox(val);
              final attendance = Attendance(
                id: model.id,
                workPlace: model.workPlace,
                userId: model.userId,
                weekEnd: model.weekEnd,
                todayDate: model.todayDate,
                weekId: model.weekId,
                weekStatus: model.weekStatus,
                status: model.status,
                salary: val ? '${double.parse(user.salary) * 1.5}' : user.salary,
                overTimeStatus: val ? 1 : 0,
                salaryReceived: model.salaryReceived,
              );
              attendanceViewModel.updateAttendance(attendance: attendance);
              attendanceViewModel.getAttendanceUserToDay(userId: model.userId);
            },
          ),
          Text(
            'إضافة سهرة (ساعات إضافية ×1.5)',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
