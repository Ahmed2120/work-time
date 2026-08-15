import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../../core/utils/global_methods.dart';
import 'components/table_header.dart';
import 'components/table_rows.dart';

class TableData extends StatelessWidget {
  const TableData({required this.week, Key? key}) : super(key: key);
  final week;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
          color: borderColor,
          width: 1,
          borderRadius: BorderRadius.circular(10),
        ),
        columnWidths: const {
          0: IntrinsicColumnWidth(flex: 3),
          1: IntrinsicColumnWidth(flex: 4),
          2: IntrinsicColumnWidth(flex: 3),
          3: IntrinsicColumnWidth(flex: 3),
          4: IntrinsicColumnWidth(flex: 3),
          5: IntrinsicColumnWidth(flex: 4),
          6: IntrinsicColumnWidth(flex: 3),
        },
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.lightPurple,
            ),
            children: [
              TableHeader("اليوم"),
              TableHeader("التاريخ"),
              TableHeader("التمام"),
              TableHeader("السهرة"),
              TableHeader("اليومية"),
              TableHeader("مكان العمل"),
              TableHeader("المسحوب"),
            ],
          ),
          ...List.generate(
            week.length,
            (i) => buildTableRow(
              day: GlobalMethods.getDayName(DateTime.parse(week[i].todayDate)),
              today: GlobalMethods.getDateFormat(DateTime.parse(week[i].todayDate)),
              workPlace: week[i].workPlace,
              status: week[i].status,
              overTime: week[i].overTimeStatus,
              salary: week[i].salary,
              salaryReceived: week[i].salaryReceived,
            ),
          ),
        ],
      ),
    );
  }

  TableRow buildTableRow({
    required String day,
    required String today,
    required String workPlace,
    required int status,
    required int overTime,
    required String salary,
    required String salaryReceived,
  }) {
    DateTime dateTime = DateTime.parse(today);
    String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

    return TableRow(children: [
      TableRows(day, 4),
      TableRows(date, 3),
      TableRows(status == 1 ? 'حاضر' : 'غائب', 2, statusType: status == 1 ? 1 : 2),
      TableRows(overTime == 1 ? 'سهرة' : '—', 2, statusType: overTime == 1 ? 3 : null),
      TableRows(salary, 3),
      TableRows(workPlace, 3),
      TableRows(salaryReceived, 3),
    ]);
  }
}
