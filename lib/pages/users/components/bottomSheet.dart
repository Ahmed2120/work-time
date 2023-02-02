import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/user.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/users/components/functions.dart';

import '../../../model/attendance.dart';
import '../../../provider/attendance_provider.dart';
import '../../components/custom_textField.dart';
import '../../components/header_sheet.dart';

class DrawFinance extends StatelessWidget {
  DrawFinance({Key? key}) : super(key: key);

  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SheetHeader(title: 'سحب مبلغ'),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
                CustomTextField(
                  controller: _salaryController,
                  label: 'المبلغ',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                buildButton(context,() {
                  if (_salaryController.text.isEmpty) {
                    final attendance = Attendance(
                      userId: user.id!,
                      todayDate: attendanceProvider.attendanceModel.last.todayDate,
                      weekEnd: attendanceProvider.attendanceModel.last.weekEnd,
                      weekId: attendanceProvider.attendanceModel.last.weekId,
                      weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                      overTimeStatus:  attendanceProvider.attendanceModel.last.overTimeStatus,
                      status: 1,
                      salaryReceived: '0',
                      salary: attendanceProvider.attendanceModel.last.salary,
                      workPlace: attendanceProvider.attendanceModel.last.workPlace
                    );
                    attendanceProvider.updateAttendance(attendance: attendance);
                    attendanceProvider.getAttendanceUserToDay(userId: user.id!);
                    showToast(context,'  تم سحب  ${_salaryController.text}');
                    pop(context);
                  }
                  else{

                    final attendance = Attendance(
                        id: attendanceProvider.attendanceModel.last.id,
                        weekEnd: attendanceProvider.attendanceModel.last.weekEnd,
                        userId: user.id!,
                        todayDate: attendanceProvider.attendanceModel.last.todayDate,
                        weekId: attendanceProvider.attendanceModel.last.weekId,
                        weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                        overTimeStatus:  attendanceProvider.attendanceModel.last.overTimeStatus,
                        status: 1,
                        salary: attendanceProvider.attendanceModel.last.salary,
                        salaryReceived: _salaryController.text,
                        workPlace: attendanceProvider.attendanceModel.last.workPlace
                    );
                    attendanceProvider.updateAttendance(attendance: attendance);
                    attendanceProvider.getAttendanceUserToDay(userId: user.id!);
                    showToast(context,'  تم سحب  ${_salaryController.text}');
                  pop(context);
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(context,VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('اضافة',style:bootElevatedStyle),
    );
  }
}
