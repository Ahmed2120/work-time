import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../../core/utils/global_methods.dart';
import 'components/table_header.dart';
import 'components/table_rows.dart';

class TableData extends StatelessWidget {
  const TableData({required this.week, Key? key}) : super(key: key);
  final dynamic week;

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
            children: const [
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
            (i) {
              final item = week[i];
              DateTime parsedDate;
              try {
                parsedDate = DateTime.parse(item.todayDate);
              } catch (_) {
                parsedDate = DateTime.now();
              }
              final dayName = GlobalMethods.getDayName(parsedDate);
              final dateStr = GlobalMethods.getDateFormat(parsedDate);

              return TableRow(
                children: [
                  TableRows(dayName, 4),
                  TableRows(dateStr, 3),
                  TableRows(
                    item.status == 1 ? 'حاضر' : 'غائب',
                    2,
                    statusType: item.status == 1 ? 1 : 2,
                  ),
                  TableRows(
                    item.overTimeStatus == 1 ? 'سهرة' : '—',
                    2,
                    statusType: item.overTimeStatus == 1 ? 3 : null,
                  ),
                  TableRows('${item.salary}', 3),
                  TableRows(item.workPlace.isNotEmpty ? item.workPlace : '—', 3),
                  TableRows('${item.salaryReceived}', 3),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
