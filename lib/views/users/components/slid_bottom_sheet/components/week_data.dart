import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/core/utils/global_methods.dart';

import '../table/table.dart';
import 'week_status.dart';

class WeekData extends StatelessWidget {
  const WeekData({
    required this.weekGroup,
    required this.weekNumber,
    super.key,
  });

  final List<Attendance> weekGroup;
  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (weekGroup.isEmpty) return const SizedBox();

    // Derive the week's display date from the first record's weekEnd
    final DateTime weekEndDate =
        DateTime.tryParse(weekGroup.first.weekEnd) ?? DateTime.now();
    // Week start = weekEnd - 6 days (Friday - 6 = Saturday)
    final DateTime weekStartDate = weekEndDate.subtract(const Duration(days: 6));

    final String weekRangeLabel =
        '${GlobalMethods.getDateFormat(weekStartDate)} — ${GlobalMethods.getDateFormat(weekEndDate)}';

    final totalSalary = _totalSalary(weekGroup);
    final sumReceived = _sumReceived(weekGroup);
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
          initiallyExpanded: weekNumber == 1,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: AppColors.primaryPurple,
          collapsedIconColor:
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          title: Row(
            children: [
              // ─── Week Number Badge ────────────────────────────────────
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryPurple.withValues(alpha: 0.3)
                      : AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$weekNumber',
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
              // ─── Week Title & Date Range ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الأسبوع $weekNumber',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      weekRangeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            // ─── Attendance Table ─────────────────────────────────────
            TableData(week: weekGroup),

            const SizedBox(height: 16),

            // ─── Financial Summary ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  _FinancialRow(
                    label: 'المبلغ الكلي',
                    value: '$totalSalary ريال',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _FinancialRow(
                    label: 'المبلغ المدفوع',
                    value: '$sumReceived ريال',
                    isDark: isDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                        height: 1,
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ المتبقي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        '$remaining ريال',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: remaining > 0
                              ? AppColors.primaryPurple
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ─── تصفية الحساب ─────────────────────────────────────────
            WeekStatus(weekGroup: weekGroup),
          ],
        ),
      ),
    );
  }

  double _totalSalary(List<Attendance> group) =>
      group.fold(0, (sum, a) => sum + (double.tryParse(a.salary) ?? 0));

  double _sumReceived(List<Attendance> group) =>
      group.fold(0, (sum, a) => sum + (double.tryParse(a.salaryReceived) ?? 0));
}

// ─── Financial Row ────────────────────────────────────────────────────────────
class _FinancialRow extends StatelessWidget {
  const _FinancialRow({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
