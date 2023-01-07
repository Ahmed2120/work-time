import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/attendance.dart';
import '../../../provider/attendance_provider.dart';
import '../../../provider/user_provider.dart';
import '../../components/custom_textField.dart';
import '../../components/header_sheet.dart';

class RecordAttendance extends StatelessWidget {
  RecordAttendance({Key? key}) : super(key: key);

  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SheetHeader(title: 'تسجيل الحضور'),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
                CustomTextField(
                  controller: _salaryController,
                  label: 'الراتب',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                buildButton(context,() {
                  if (_salaryController.text.isEmpty) {
                    final attendance = Attendance(
                      userId: userProvider.userModel.id!,
                      todayDate: DateTime.now().toString(),
                      status: 1,
                      salaryReceived: 0,
                    );
                    attendanceProvider.addAttendance(attendance);
                  }
                  else{
                    final attendance = Attendance(
                      userId: userProvider.userModel.id!,
                      todayDate: DateTime.now().toString(),
                      status: 1,
                      salaryReceived: 0,
                    );
                    attendanceProvider.addAttendance(attendance);
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
