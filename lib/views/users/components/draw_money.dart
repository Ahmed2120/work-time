import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/views/components/app_button.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/components/functions.dart';

import '../../../data/models/attendance.dart';
import '../../../view_models/attendance_view_model.dart';
import '../../components/custom_textField.dart';
import '../../home/components/bottom_sheet/components/header_sheet.dart';

class DrawFinance extends StatelessWidget {
  DrawFinance({super.key});

  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderSheet(title: 'سحب مبلغ'),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Column(
              children: [
                CustomTextField(
                  controller: _salaryController,
                  label: 'المبلغ',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'تأكيد السحب',
                  icon: Icons.payments_rounded,
                  onPressed: () async {
                    final isExpired = await SecureStorageHelper.isTrialExpired();
                    if (isExpired) {
                      if (context.mounted) {
                        showFlushBar(
                          context,
                          customMessage: 'انتهت صلاحية الاستخدام. يرجى تجديد الاشتراك لتسجيل المسحوبات.',
                        );
                      }
                      return;
                    }

                    final attendance = Attendance(
                      id: attendanceViewModel.attendanceModel.last.id,
                      userId: user.id!,
                      todayDate: attendanceViewModel.attendanceModel.last.todayDate,
                      weekEnd: attendanceViewModel.attendanceModel.last.weekEnd,
                      weekId: attendanceViewModel.attendanceModel.last.weekId,
                      weekStatus: attendanceViewModel.attendanceModel.last.weekStatus,
                      overTimeStatus: attendanceViewModel.attendanceModel.last.overTimeStatus,
                      status: 1,
                      salaryReceived:
                          _salaryController.text.isEmpty ? '0' : _salaryController.text,
                      salary: attendanceViewModel.attendanceModel.last.salary,
                      workPlace: attendanceViewModel.attendanceModel.last.workPlace,
                    );
                    attendanceViewModel.updateAttendance(attendance: attendance);
                    attendanceViewModel.getAttendanceUserToDay(userId: user.id!);
                    showToast(context, 'تم سحب ${_salaryController.text} جنيه');
                    pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
