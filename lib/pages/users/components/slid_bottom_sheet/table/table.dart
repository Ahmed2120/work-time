import 'package:flutter/material.dart';

import '../../../../../utility/global_methods.dart';
import 'components/table_header.dart';
import 'components/table_rows.dart';

class TableData extends StatelessWidget {
  const TableData({required this.week, Key? key}) : super(key: key);
  final week;

  @override
  Widget build(BuildContext context) {
    return Table(
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
          TableHeader("اليوم"),
          TableHeader("التاريخ"),
          TableHeader("التمام"),
          TableHeader("السهرة"),
          TableHeader("اليومية"),
          TableHeader("مكان العمل"),
          TableHeader("المبلغ المسحوب"),
        ]),
        ...List.generate(
          week.length,
              (i) =>
              buildTableRow(
                  day: GlobalMethods.getDayName(DateTime.parse(
                      week[i].todayDate)),
                  today: GlobalMethods.getDateFormat(DateTime.parse(
                      week[i].todayDate)),
                  workPlace: week[i].workPlace,
                  status: week[i].status,
                  overTime: week[i]
                      .overTimeStatus,
                  salary: week[i].salary,
                  salaryReceived: week[i]
                      .salaryReceived),
        ),
      ],
    );
  }

  TableRow buildTableRow({required String day,
    required String today,
    required String workPlace,
    required int status,
    required int overTime,
    required String salary,
    required String salaryReceived}) {
    DateTime dateTime = DateTime.parse(today);
    String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    return TableRow(children: [
      TableRows(day, 2),
      TableRows(date, 5),
      TableRows(status == 1 ? 'حاضر' : 'غائب', 0),
      TableRows(overTime == 1 ? 'سهرة' : 'لا يوجد', 0),
      TableRows(salary, 0),
      TableRows(workPlace, 0),
      TableRows(salaryReceived, 0),
    ]);
  }
}