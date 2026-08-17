import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/view_models/attendance_view_model.dart';

class WeekStatus extends StatelessWidget {
  const WeekStatus({required this.weekGroup, super.key});

  final List<Attendance> weekGroup;

  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

    // Settled if ANY record in the week is marked settled (weekStatus == 1)
    final bool isSettled = weekGroup.any((a) => a.weekStatus == 1);

    if (!isSettled) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
          label: const Text(
            'تصفية الحساب',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          onPressed: () async {
            // Mark every record in this week as settled
            final model = weekGroup.first;
            final settled = Attendance(
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
              salaryReceived: model.salaryReceived,
            );
            await attendanceViewModel.updateAttendance(attendance: settled);
            await attendanceViewModel.getWeeklyAttendance(model.userId);
            await attendanceViewModel.getAttendanceUser(model.userId);
          },
        ),
      );
    }

    // ─── Already settled badge ───────────────────────────────────────────────
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.successBgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_rounded, size: 18, color: AppColors.successText),
          SizedBox(width: 8),
          Text(
            'تم تصفية الحساب',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.successText,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
