import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:work_time/utility/global_methods.dart';

import '../../../model/attendance.dart';
import '../../../provider/attendance_provider.dart';

Future showSheet(BuildContext context) => showSlidingBottomSheet(context,
    builder: (context) => const SlidingSheetDialog(
        cornerRadius: 20,
        duration: Duration(milliseconds: 200),
        avoidStatusBar: true,
        snapSpec: SnapSpec(
          snappings: [.4, .7],
        ),
        builder: buildSheet,
        headerBuilder: buildHeader));

Widget buildHeader(context, state) => Material(
      child: SizedBox(
        height: 10,
        child: Container(
          width: 60,
          decoration: BoxDecoration(
              color: const Color(0xFF533483),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );

Widget buildSheet(context, state) {
  final attendanceProvider = Provider.of<AttendanceProvider>(context);
  final weeksList = attendanceProvider.weeksList;
  return Material(
    child: ListView.builder(
        itemCount: weeksList.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ExpansionTile(
                title: Row(children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF533483),
                    child: Text('${index+1}',style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  Text('الاسبوع '),
                  SizedBox(width: 10),
                  Text('${DateTime.parse(attendanceProvider
                      .weekAttendanceMap[weeksList[index]]![0].weekEnd).year}- ${DateTime.parse(attendanceProvider
                      .weekAttendanceMap[weeksList[index]]![0].weekEnd).month}'),
                ],),
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                children: [
                  InteractiveViewer(
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      border: TableBorder.all(
                        color: Colors.black45,
                        width: 2,
                      ),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(flex: 4),
                        1: IntrinsicColumnWidth(flex: 4),
                        2: IntrinsicColumnWidth(flex: 4),
                        3: IntrinsicColumnWidth(flex: 4),
                        4: IntrinsicColumnWidth(flex: 4),
                        5: IntrinsicColumnWidth(flex: 4),
                        6: IntrinsicColumnWidth(flex: 4),
                      },
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          headerTable("اليوم"),
                          headerTable("التاريخ"),
                          headerTable("التمام"),
                          headerTable("السهرة"),
                          headerTable("اليومية"),
                          headerTable("مكان العمل"),
                          headerTable("المبلغ المسحوب"),
                        ]),
                        ...List.generate(
                          attendanceProvider
                              .weekAttendanceMap[weeksList[index]]!.length,
                          (i) => buildTableRow(
                              day: GlobalMethods.getDayName(DateTime.parse(
                                  attendanceProvider
                                      .weekAttendanceMap[weeksList[index]]![i]
                                      .todayDate)),
                              today: GlobalMethods.getDateFormat(DateTime.parse(
                                  attendanceProvider
                                      .weekAttendanceMap[weeksList[index]]![i]
                                      .todayDate)),
                              workPlace: attendanceProvider
                                  .weekAttendanceMap[weeksList[index]]![i]
                                  .workPlace,
                              status: attendanceProvider
                                  .weekAttendanceMap[weeksList[index]]![i].status,
                              overTime: attendanceProvider
                                  .weekAttendanceMap[weeksList[index]]![i]
                                  .overTimeStatus,
                              salary: attendanceProvider
                                  .weekAttendanceMap[weeksList[index]]![i].salary,
                              salaryReceived: attendanceProvider
                                  .weekAttendanceMap[weeksList[index]]![i]
                                  .salaryReceived),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      'المبلغ الكلي : ${attendanceProvider.totalSalary(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}'),
                  Text(
                      'المبلغ المدفوع : ${attendanceProvider.sumSalaryReceived(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}'),
                  Text(
                      "المبلغ المتبقي : ${attendanceProvider.totalSalary(attendanceProvider.weekAttendanceMap[weeksList[index]]!)-attendanceProvider.sumSalaryReceived(attendanceProvider.weekAttendanceMap[weeksList[index]]!)}"),
                  const SizedBox(height: 10),
                  attendanceProvider.weekAttendanceMap[weeksList[index]]![0]
                              .weekStatus ==
                          0
                      ? ElevatedButton(
                          onPressed: () {
                            final model = attendanceProvider
                                .weekAttendanceMap[weeksList[index]]![0];
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
                        )
                ],
              ),
            )),
  );
}

Padding headerTable(String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      txt,
      style: const TextStyle(
          fontSize: 11, color: Color(0xFF084081), fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

TableRow buildTableRow(
    {required String day,
    required String today,
    required String workPlace,
    required int status,
    required int overTime,
    required String salary,
    required String salaryReceived}) {
  DateTime dateTime = DateTime.parse(today);
  String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  return TableRow(children: [
    buildText(day, 2),
    buildText(date, 5),
    buildText(status == 1 ? 'حاضر' : 'غائب', 0),
    buildText(overTime == 1 ? 'سهرة' : 'لا يوجد', 0),
    buildText(salary,0),
    buildText(workPlace, 0),
    buildText(salaryReceived, 0),
  ]);
}

Padding buildText(String txt, double padding) => Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(txt, textAlign: TextAlign.center,style: TextStyle(fontSize: 9),),
    );
