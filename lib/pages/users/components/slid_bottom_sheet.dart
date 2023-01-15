import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:work_time/pages/users/components/functions.dart';
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
      child: Container(
        width: double.infinity,
        height: 14,
        color: Colors.blue,
        child: Center(
          child: Container(
            height: 6,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ),
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
                title: Text('الاسبوع ${attendanceProvider.weeksList[index]}'),
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                children: [
                  Table(
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
                    },
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        headerTable("اليوم"),
                        headerTable("التاريخ"),
                        headerTable("التمام"),
                        headerTable("المبلغ المسحوب"),
                      ]),
                      ...List.generate(
                        attendanceProvider
                            .weekAttendanceMap[weeksList[index]]!.length,
                        (i) => buildTableRow(
                            GlobalMethods.getDayName(DateTime.parse(
                                attendanceProvider
                                    .weekAttendanceMap[weeksList[index]]![i]
                                    .todayDate)),
                            GlobalMethods.getDateFormat(DateTime.parse(
                                attendanceProvider
                                    .weekAttendanceMap[weeksList[index]]![i]
                                    .todayDate)),
                            attendanceProvider
                                .weekAttendanceMap[weeksList[index]]![i].status,
                            attendanceProvider
                                .weekAttendanceMap[weeksList[index]]![i]
                                .salaryReceived),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20
                  ),
                  Text('المبلغ الكلي : ${attendanceProvider.sumSalaryReceived(attendanceProvider
                      .weekAttendanceMap[weeksList[index]]!)+attendanceProvider.sumSalaryRemain(attendanceProvider
                      .weekAttendanceMap[weeksList[index]]!)}'),
                   Text('المبلغ المدفوع : ${attendanceProvider.sumSalaryReceived(attendanceProvider
                       .weekAttendanceMap[weeksList[index]]!)}'),
                  Text("المبلغ المتبقي : ${attendanceProvider.sumSalaryRemain(attendanceProvider
                      .weekAttendanceMap[weeksList[index]]!)}"),
                  const SizedBox(
                    height: 10
                  ),
                  attendanceProvider.weekAttendanceMap[weeksList[index]]![0].weekStatus==0?ElevatedButton(
                      onPressed: () {
                        final model=attendanceProvider
                            .attendanceModel.last;
                        final attendance = Attendance(
                            id: model.id,
                            userId: model.userId,
                            todayDate: model.todayDate,
                            weekId: model.weekId,
                            weekStatus: 1,
                            status: model.status,
                            salaryReceived: model.salaryReceived);
                        attendanceProvider.updateAttendance(
                            attendance: attendance);
                        attendanceProvider.getWeeklyAttendance(model.userId);
                        attendanceProvider
                            .getAttendanceUser(model.userId);
                      }, child: const Text('تصفية الساب')):const Text('تم تصفية الحساب',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900,color: Color(
                      0xFF560404)),)
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
          fontSize: 12, color: Color(0xad047d82), fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

TableRow buildTableRow(String day, String today, int status,
    String salaryReceived) {
  DateTime dateTime = DateTime.parse(today);
  String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        day,
        textAlign: TextAlign.center,
      ),
    ),
    Text(
      date,
      textAlign: TextAlign.center,
    ),
    Text(
      status == 1 ? 'حاضر' : 'غائب',
      textAlign: TextAlign.center,
    ),
    Text(
      salaryReceived,
      textAlign: TextAlign.center,
    ),
  ]);
}
