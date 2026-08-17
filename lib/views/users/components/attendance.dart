import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../core/utils/cache_helper.dart';
import '../../../core/utils/global_methods.dart';
import '../../../data/models/attendance.dart';
import '../../../data/models/user.dart';
import '../../../view_models/attendance_view_model.dart';
import '../../components/constant.dart';
import '../../components/custom_textField.dart';
import '../../components/functions.dart';

class AttendanceWidget extends StatelessWidget {
  AttendanceWidget({required this.user, super.key});
  final User user;

  final _formKey = GlobalKey<FormState>();
  final _workPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: true);
    final isPresent = attendanceViewModel.attendanceModel.isNotEmpty &&
        attendanceViewModel.attendanceModel.last.status == 1;
    final isAbsent = attendanceViewModel.attendanceModel.isNotEmpty &&
        attendanceViewModel.attendanceModel.last.status == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Segmented Control [ حاضر | غائب ] ─────────────────────────────
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              // Button: حاضر (Success Green #10B981 when selected)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    if ((attendanceViewModel.attendanceUser.length) >= AppConfig.maxTrialAttendanceDays && trial) {
                      showFlushBar(context);
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      if (attendanceViewModel.attendanceModel.isEmpty) {
                        final Attendance attendance = Attendance(
                          userId: user.id!,
                          weekEnd: '${GlobalMethods.getWeekDay(attendanceViewModel.dateTimeAttendance)}',
                          todayDate: '${attendanceViewModel.dateTimeAttendance}',
                          workPlace: _workPlaceController.text,
                          weekId: await attendanceViewModel.setWeekId(userId: user.id!),
                          weekStatus: 0,
                          overTimeStatus: 0,
                          salary: user.salary,
                          status: 1,
                          salaryReceived: '0',
                        );
                        attendanceViewModel.addAttendance(attendance);
                        attendanceViewModel.getAttendanceUserToDay(userId: user.id!);
                        attendanceViewModel.getWeeks(user.id!);
                      } else {
                        if (attendanceViewModel.attendanceModel.last.status == 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => alert(
                              context: context,
                              txt: 'حاضر',
                              color: AppColors.success,
                              onPressed: () {
                                final attendance = Attendance(
                                  id: attendanceViewModel.attendanceModel.last.id,
                                  workPlace: _workPlaceController.text,
                                  userId: user.id!,
                                  todayDate: '${attendanceViewModel.dateTimeAttendance}',
                                  weekEnd: attendanceViewModel.attendanceModel.last.weekEnd,
                                  weekId: attendanceViewModel.attendanceModel.last.weekId,
                                  weekStatus: attendanceViewModel.attendanceModel.last.weekStatus,
                                  status: 1,
                                  overTimeStatus: 0,
                                  salary: user.salary,
                                  salaryReceived: '0',
                                );

                                attendanceViewModel.updateAttendance(attendance: attendance);
                                attendanceViewModel.getAttendanceUserToDay(userId: user.id!);
                                pop(context);
                              },
                            ),
                          );
                        } else {
                          showToast(context, 'تم تسجيل التمام مسبقاً');
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isPresent ? AppColors.success : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: isPresent
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'حاضر',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isPresent
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Button: غائب (Error Red #EF476F when selected)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    if ((attendanceViewModel.attendanceUser.length) >= AppConfig.maxTrialAttendanceDays && trial) {
                      showFlushBar(context);
                      return;
                    }
                    if (attendanceViewModel.attendanceModel.isEmpty) {
                      final attendance = Attendance(
                        userId: user.id!,
                        todayDate: '${attendanceViewModel.dateTimeAttendance}',
                        weekEnd: '${GlobalMethods.getWeekDay(attendanceViewModel.dateTimeAttendance)}',
                        workPlace: 'لا يوجد',
                        overTimeStatus: 0,
                        weekId: await attendanceViewModel.setWeekId(userId: user.id!),
                        weekStatus: 0,
                        salary: '0',
                        status: 0,
                        salaryReceived: '0',
                      );
                      attendanceViewModel.addAttendance(attendance);
                      attendanceViewModel.getAttendanceUserToDay(userId: user.id!);
                      attendanceViewModel.getWeeks(user.id!);
                    } else if (attendanceViewModel.attendanceModel.last.status == 1) {
                      showDialog(
                        context: context,
                        builder: (ctx) => alert(
                          context: context,
                          txt: 'غائب',
                          color: AppColors.error,
                          onPressed: () {
                            final attendance = Attendance(
                              id: attendanceViewModel.attendanceModel.last.id,
                              workPlace: 'لا يوجد',
                              weekEnd: attendanceViewModel.attendanceModel.last.weekEnd,
                              userId: user.id!,
                              todayDate: '${attendanceViewModel.dateTimeAttendance}',
                              weekId: attendanceViewModel.attendanceModel.last.weekId,
                              weekStatus: attendanceViewModel.attendanceModel.last.weekStatus,
                              status: 0,
                              salary: '0',
                              overTimeStatus: 0,
                              salaryReceived: '0',
                            );
                            attendanceViewModel.updateAttendance(attendance: attendance);
                            attendanceViewModel.getAttendanceUserToDay(userId: user.id!);
                            pop(context);
                          },
                        ),
                      );
                    } else {
                      showToast(context, 'تم تسجيل التمام مسبقاً');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isAbsent ? AppColors.error : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: isAbsent
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'غائب',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isAbsent
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ─── Work Location Field with Location Icon ─────────────────────────
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _workPlaceController,
            label: 'مكان العمل',
            hint: 'أدخل مكان أو موقع العمل...',
            prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: AppColors.primaryPurple),
          ),
        ),
      ],
    );
  }
}
