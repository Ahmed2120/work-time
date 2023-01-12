import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/user.dart';
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
                      weekId: attendanceProvider.attendanceModel.last.weekId,
                      weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                      status: 1,
                      salaryReceived: '0',
                    );
                    attendanceProvider.updateAttendance(attendance: attendance);
                    attendanceProvider.getAttendanceUserToDay(userId: user.id!);
                  }
                  else{

                    final attendance = Attendance(
                        id: attendanceProvider.attendanceModel.last.id,
                        userId: user.id!,
                        todayDate: attendanceProvider.attendanceModel.last.todayDate,
                        weekId: attendanceProvider.attendanceModel.last.weekId,
                        weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                        status: 1,
                        salaryReceived: _salaryController.text);
                    attendanceProvider.updateAttendance(attendance: attendance);
                    attendanceProvider.getAttendanceUserToDay(userId: user.id!);
                  showToast(context,' تم سحب${_salaryController.text}');
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
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007C6D),
          minimumSize: const Size(double.infinity, 10),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: const Text('اضافة',
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }
}
