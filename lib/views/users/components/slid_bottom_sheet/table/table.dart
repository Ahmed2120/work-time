import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../../core/utils/global_methods.dart';
import 'components/table_header.dart';
import 'components/table_rows.dart';

class TableData extends StatelessWidget {
  const TableData({required this.week, super.key});
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
          0: FlexColumnWidth(1.2),  // اليوم
          1: FlexColumnWidth(1.3),  // التاريخ
          2: FlexColumnWidth(0.95), // التمام
          3: FlexColumnWidth(0.85), // السهرة
          4: FlexColumnWidth(0.95), // اليومية
          5: FlexColumnWidth(1.15), // مكان العمل
          6: FlexColumnWidth(0.95), // المسحوب
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.4)
                  : AppColors.lightPurple,
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
                  TableRows(dayName, 2),
                  TableRows(dateStr, 2),
                  TableRows(
                    item.status == 1 ? 'حاضر' : 'غائب',
                    1,
                    statusType: item.status == 1 ? 1 : 2,
                  ),
                  TableRows(
                    item.overTimeStatus == 1 ? 'سهرة' : '—',
                    1,
                    statusType: item.overTimeStatus == 1 ? 3 : null,
                  ),
                  TableRows('${item.salary}', 2),
                  TableRows(item.workPlace.isNotEmpty ? item.workPlace : '—', 2),
                  TableRows('${item.salaryReceived}', 2),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
