import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/model/attendance.dart';
import 'package:work_time/pages/components/constant.dart';
import 'package:work_time/pages/components/custom_textField.dart';
import 'package:work_time/provider/attendance_provider.dart';
import 'package:work_time/provider/user_provider.dart';

import '../../model/user.dart';
import '../home/components/addingUser_bottomSheet.dart';
import 'components/bottomSheet.dart';
import 'components/build_card.dart';
import 'components/edit_user_bottomsheet.dart';
import 'components/functions.dart';
import 'components/slid_bottom_sheet.dart';
import 'components/text_row.dart';

class UserDetail extends StatelessWidget {
  UserDetail({Key? key, required this.user}) : super(key: key);
  final User user;

  final List<PopupMenuItem<String>> menuItems = [
    const PopupMenuItem(
      value: 'add',
      child: Text(
        "تعديل",
        style: TextStyle(fontSize: 18),
      ),
    ),
    const PopupMenuItem(
      value: 'remove',
      child: Text(
        "حذف",
        style: TextStyle(fontSize: 18),
      ),
    ),
  ];
  final _keyScaffold = GlobalKey<ScaffoldState>();
  final _formKey=GlobalKey<FormState>();
  final _workPlaceController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: true);
    return Consumer<UserProvider>(
      builder: (ctx, userProvider, _) {
        return Scaffold(
          key: _keyScaffold,
          appBar: AppBar(
            title: const Text('التفاصيل'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (x) {
                  if(x=='remove'){
                    final userModel=User(id: user.id,name: user.name, job: user.job, salary: user.salary,isDeleted: 1);
                    userProvider.updateUser(userModel);
                    pop(context);
                    showToast(context, 'تم حذف العامل ونقله الي خارج العمل',color: const Color(0xFFE94560));
                  }
                  else{
                    _keyScaffold.currentState!.showBottomSheet((context) => ChangeNotifierProvider.value(value: user,child: EditUserBottomSheet('edit',)));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return menuItems.toList();
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildElevatedButton(
                      label: 'حاضر',
                      color: Colors.green,
                      onPressed: () async{
                        if(_formKey.currentState!.validate()) {
                          if (attendanceProvider.attendanceModel.isEmpty) {
                          final attendance = Attendance(
                              userId: user.id!,
                              todayDate: '${DateTime.now()}',
                              workPlace: _workPlaceController.text,
                              weekId: await attendanceProvider.setWeekId(),
                              weekStatus: 0,
                              status: 1,
                              salaryReceived: '0');
                          attendanceProvider.addAttendance(attendance);
                          attendanceProvider.getAttendanceUserToDay(
                              userId: user.id!);
                          attendanceProvider.getWeeks(user.id!);
                        } else {
                          if (attendanceProvider
                            .attendanceModel.last.status ==
                            0) {
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
                                        todayDate: '${DateTime.now()}',
                                        weekId: attendanceProvider
                                            .attendanceModel.last.weekId,
                                        weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                                        status: 1,
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
                    buildElevatedButton(
                      label: 'غائب',
                      onPressed: () async{
                        if (attendanceProvider.attendanceModel.isEmpty) {
                          final attendance = Attendance(
                              userId: user.id!,
                              todayDate: '${DateTime.now()}',
                              workPlace: 'لا يوجد',
                              weekId: await attendanceProvider.setWeekId(),
                              weekStatus: 0,
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
                                        userId: user.id!,
                                        todayDate: '${DateTime.now()}',
                                        weekId: attendanceProvider.attendanceModel.last.weekId,
                                        weekStatus: attendanceProvider.attendanceModel.last.weekStatus,
                                        status: 0,
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
                const SizedBox(height: 20),
                Form(key: _formKey,
                    child: CustomTextField(
                  controller: _workPlaceController, label: 'مكان العمل',
                )),
                const SizedBox(height: 30),
                BuildCard(Column(
                  children: [
                    TextRow(title: 'الاسم', txt: user.name),
                    TextRow(
                        title: 'الوظيفة', txt: user.job),
                    TextRow(
                        title: 'الفئة',
                        txt: user.salary.toString()),
                  ],
                )),
                const SizedBox(height: 20),
                const Text(
                  'التمام اليومي',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                BuildCard(Column(
                  children: [
                    TextRow(
                        title: 'التمام',
                        txt: attendanceProvider.attendanceModel.isEmpty
                            ? 'لم يتم تسجيل التمام'
                            : attendanceProvider.attendanceText),
                    if (attendanceProvider.attendanceModel.isNotEmpty &&
                        attendanceProvider.attendanceModel.last.status == 1)
                      TextRow(title: 'اليوم', txt: attendanceProvider.date),
                    if (attendanceProvider.attendanceModel.isNotEmpty &&
                        attendanceProvider.attendanceModel.last.status == 1)
                      TextRow(title: 'الساعه', txt: attendanceProvider.time),
                    if (attendanceProvider.attendanceModel.isNotEmpty &&
                        attendanceProvider.attendanceModel.last.status == 1)
                      TextRow(title: 'مكان العمل ', txt: attendanceProvider.attendanceModel.last.workPlace),
                    if (attendanceProvider.attendanceModel.isNotEmpty &&
                        attendanceProvider.attendanceModel.last.status == 1)
                      TextRow(
                          title: 'المبلغ المسحوب',
                          txt: attendanceProvider
                              .attendanceModel.last.salaryReceived),
                  ],
                )),
                const SizedBox(height: 30),
                if (attendanceProvider.attendanceModel.isNotEmpty &&
                    attendanceProvider.attendanceModel.last.status == 1)
                  buildElevatedButton(
                      label: 'سحب مبلغ',
                      color: const Color(0xffE94560),
                      onPressed: () {
                        _keyScaffold.currentState!
                            .showBottomSheet((context) => ChangeNotifierProvider.value(
                            value: user,
                            child: DrawFinance()));
                      }),
                const SizedBox(height: 20),
                buildElevatedButton(
                    label: 'عرض ايام الحضور',
                    color: const Color(0xFF533483),
                    onPressed: () {
                      attendanceProvider.getWeeklyAttendance(user.id!).then((value) {
                        attendanceProvider
                            .getAttendanceUser(user.id!);
                        showSheet(context);
                      });
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  TextButton buildElevatedButton(
      {required String label,
        required Color color,

        required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label,style: const TextStyle(color: Colors.white,fontSize: 17),),
    );
  }
}