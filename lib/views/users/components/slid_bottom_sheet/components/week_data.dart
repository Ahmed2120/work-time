import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/attendance_view_model.dart';

import '../table/table.dart';
import 'week_status.dart';

class WeekData extends StatelessWidget {
  const WeekData({required this.index, Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
    final weeksList = attendanceViewModel.weeksList;
    final weekGroup = attendanceViewModel.weekAttendanceMap[weeksList[index]]!;
    final weekDate = DateTime.parse(weekGroup[0].weekEnd);
    final totalSalary = attendanceViewModel.totalSalary(weekGroup);
    final sumReceived = attendanceViewModel.sumSalaryReceived(weekGroup);
    final remaining = totalSalary - sumReceived;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: AppColors.primaryPurple,
          collapsedIconColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          title: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryPurple.withValues(alpha: 0.3) : AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأسبوع ${index + 1}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    '${weekDate.year} / ${weekDate.month}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            // ─── Attendance Table ─────────────────────────────────────────
            InteractiveViewer(
              child: TableData(week: weekGroup),
            ),

            const SizedBox(height: 16),

            // ─── Financial Summary ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _FinancialRow(
                    label: 'المبلغ الكلي',
                    value: '$totalSalary ريال',
                    isDark: isDark,
                    bold: false,
                  ),
                  const SizedBox(height: 8),
                  _FinancialRow(
                    label: 'المبلغ المدفوع',
                    value: '$sumReceived ريال',
                    isDark: isDark,
                    bold: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  // Most prominent: المبلغ المتبقي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ المتبقي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        '$remaining ريال',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: remaining > 0
                              ? AppColors.primaryPurple
                              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ─── تصفية الحساب CTA ─────────────────────────────────────────
            WeekStatus(index: index, weeks: weeksList[index]),
          ],
        ),
      ),
    );
  }
}

// Helper widget for financial summary rows
class _FinancialRow extends StatelessWidget {
  const _FinancialRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
