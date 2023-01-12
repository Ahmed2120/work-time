import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:work_time/pages/users/components/functions.dart';

import '../../../provider/attendance_provider.dart';

Future showSheet(BuildContext context) => showSlidingBottomSheet(context,
    builder: (context) => const SlidingSheetDialog(
        cornerRadius: 20,
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
  return Material(
    child: ListView.builder(
      itemCount: 3,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) => ExpansionTile(
          onExpansionChanged: (val){
            showToast(context, '$val');
          },
              title:
                  Text('Week ${index}'),
              childrenPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              children: [
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                    color: Colors.black45,
                    width: 2,
                  ),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(flex: 1),
                    1: IntrinsicColumnWidth(flex: 4),
                    2: IntrinsicColumnWidth(flex: 4),
                    3: IntrinsicColumnWidth(flex: 4),
                    4: IntrinsicColumnWidth(flex: 4),
                  },
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      headerTable("العدد"),
                      headerTable("التاريخ"),
                      headerTable("الوقت"),
                      headerTable("التمام"),
                      headerTable("المبلغ المسحوب"),
                    ]),
                    ...List.generate(
                      7,
                      (index) => buildTableRow(
                        index + 1,
                        '${DateTime.now()}',
                        '01:00',
                        1,'120'
                      ),
                    ),
                  ],
                ),
SizedBox(height: 20,),
                Text('المبلغ المدفوع : 120'),
                Text("المبلغ المتبقي : 700"),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){}, child: const Text('تصفية الساب'))
             ],
            )),
  );
}

// buildtale(){
//   return  Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 15),
//   child: Table(
//   defaultVerticalAlignment:
//   TableCellVerticalAlignment.middle,
//   border: TableBorder.all(
//   color: Colors.black45,
//   width: 2,
//   ),
//   columnWidths: const {
//   0: IntrinsicColumnWidth(flex: 1),
//   1: IntrinsicColumnWidth(flex: 4),
//   2: IntrinsicColumnWidth(flex: 4),
//   3: IntrinsicColumnWidth(flex: 4),
//   4: IntrinsicColumnWidth(flex: 4),
//   },
//   defaultColumnWidth: const IntrinsicColumnWidth(),
//   children: [
//   TableRow(children: [
//   headerTable("العدد"),
//   headerTable("التاريخ"),
//   headerTable("الوقت"),
//   headerTable("التمام"),
//   headerTable("المبلغ المسحوب"),
//   ]),
//   ...List.generate(attendanceProvider.attendanceUser.length,
//   (index) => buildTableRow(
//   index + 1,
//   attendanceProvider.attendanceUser[index].todayDate,
//   attendanceProvider.attendanceUser[index].todayDate,
//   attendanceProvider.attendanceUser[index].status,
//   attendanceProvider.attendanceUser[index].salaryReceived,
//
//   ),
//   ),
//   ],
//   ),
//   );
// }
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

TableRow buildTableRow(
    int index, String today, String today1, int status, String salaryReceived) {
  DateTime dateTime = DateTime.parse(today);
  String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  String time =
      "${dateTime.hour < 10 ? '0${dateTime.hour}' : '${dateTime.hour}'}:${dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}'}:${dateTime.second < 10 ? '0${dateTime.second}' : '${dateTime.second}'}";
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        index.toString(),
        textAlign: TextAlign.center,
      ),
    ),
    Text(
      date,
      textAlign: TextAlign.center,
    ),
    Text(
      time,
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
