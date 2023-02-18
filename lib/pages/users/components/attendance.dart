import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../cash_helper.dart';

import '../../../model/attendance.dart';
import '../../../model/user.dart';
import '../../../provider/attendance_provider.dart';
import '../../../utility/global_methods.dart';
import '../../components/constant.dart';
import '../../components/custom_textField.dart';
import '../../components/functions.dart';
import 'button_attendance.dart';

class AttendanceWidget extends StatelessWidget {
   AttendanceWidget({required this.user,Key? key}) : super(key: key);
final User user;

   final _formKey=GlobalKey<FormState>();
   final _workPlaceController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: true);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonAttendance(
              label: 'حاضر',
              color: Colors.green,
              onPressed: () async{
                if((attendanceProvider.attendanceUser.length)>=7&&trial) {
                  showFlushBar(context);
                  return;
                }
                if(_formKey.currentState!.validate()) {
                  if (attendanceProvider.attendanceModel.isEmpty) {
                    final Attendance attendance = Attendance(
                        userId: user.id!,
                        weekEnd: '${GlobalMethods.getWeekDay(attendanceProvider.dateTimeAttendance)}',
                        todayDate: '${attendanceProvider.dateTimeAttendance}',
                        workPlace:_workPlaceController.text,
                        weekId: await attendanceProvider.setWeekId(),
                        weekStatus: 0,
                        overTimeStatus: 0,
                        salary: user.salary,
                        status: 1,
                        salaryReceived: '0'
                    );
                    attendanceProvider.addAttendance(attendance);
                    attendanceProvider.getAttendanceUserToDay(userId: user.id!);
                    attendanceProvider.getWeeks(user.id!);
                  } else {
                    if (attendanceProvider.attendanceModel.last.status == 0) {
                      showDialog(
                          context: context,
                          builder: (ctx) => alert(
                              context: context,
                              txt: 'حاضر',
                              color: Colors.green,
                              onPressed: () {
                                final attendance = Attendance(
                                    id: attendanceProvider
                                        .attendanceModel.last.id,
                                    workPlace: _workPlaceController.text,
                                    userId: user.id!,
                                    todayDate: '${attendanceProvider.dateTimeAttendance}',
                                    weekEnd: attendanceProvider.attendanceModel.last.weekEnd,
                                    weekId: attendanceProvider
                                        .attendanceModel.last.weekId,
                                    weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                                    status: 1,
                                    overTimeStatus: 0,
                                    salary: user.salary,
                                    salaryReceived: '0');

                                attendanceProvider.updateAttendance(
                                    attendance: attendance);
                                attendanceProvider.getAttendanceUserToDay(
                                    userId: user.id!);
                                pop(context);
                              }));
                    } else {
                      showToast(context, 'تم تسجيل التمام مسبقاً');
                    }
                  }
                }

              },
            ),
            const SizedBox(width: 20),
            ButtonAttendance(
              label: 'غائب',
              onPressed: () async{
                if((attendanceProvider.attendanceUser.length)>=7&&trial) {
                  showFlushBar(context);
                  return;
                }
                if (attendanceProvider.attendanceModel.isEmpty) {
                  final attendance = Attendance(
                      userId: user.id!,
                      todayDate: '${attendanceProvider.dateTimeAttendance}',
                      weekEnd: '${GlobalMethods.getWeekDay(attendanceProvider.dateTimeAttendance)}',
                      workPlace: 'لا يوجد',
                      overTimeStatus: 0,
                      weekId: await attendanceProvider.setWeekId(),
                      weekStatus: 0,
                      salary: '0',
                      status: 0,
                      salaryReceived: '0');
                  attendanceProvider.addAttendance(attendance);
                  attendanceProvider.getAttendanceUserToDay(
                      userId: user.id!);
                  attendanceProvider.getWeeks(user.id!);
                } else if (attendanceProvider
                    .attendanceModel.last.status ==
                    1) {
                  showDialog(
                      context: context,
                      builder: (ctx) => alert(
                          context: context,
                          txt: 'غائب',
                          color: Colors.red,
                          onPressed: () {
                            final attendance = Attendance(
                                id: attendanceProvider
                                    .attendanceModel.last.id,
                                workPlace: 'لا يوجد',
                                weekEnd: attendanceProvider.attendanceModel.last.weekEnd,
                                userId: user.id!,
                                todayDate: '${attendanceProvider.dateTimeAttendance}',
                                weekId: attendanceProvider.attendanceModel.last.weekId,
                                weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                                status: 0,
                                salary: '0',
                                overTimeStatus: 0,
                                salaryReceived: '0');
                            attendanceProvider.updateAttendance(
                                attendance: attendance);
                            attendanceProvider.getAttendanceUserToDay(
                                userId: user.id!);
                            pop(context);
                          }));
                } else {
                  showToast(context, 'تم تسجيل التمام مسبقاً');
                }
              },
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Form(key: _formKey,
            child: CustomTextField(
              controller: _workPlaceController, label: 'مكان العمل',
            )),
      ],
    );
  }
}
