import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

/// شريط تقدم الميزانية — يُظهر نسبة ما تم صرفه من الميزانية التقديرية
class BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0;
    final bool isOverBudget = budget > 0 && spent > budget;
    final Color barColor = isOverBudget
        ? AppColors.danger
        : (progress > 0.8 ? AppColors.warning : AppColors.success);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الميزانية',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Cairo',
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${spent.toStringAsFixed(0)} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: barColor,
                    ),
                  ),
                  TextSpan(
                    text: '/ ${budget.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        if (isOverBudget) ...[
          const SizedBox(height: 4),
          Text(
            '⚠️ تجاوزت الميزانية بمقدار ${(spent - budget).toStringAsFixed(0)} ج',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Cairo',
              color: AppColors.danger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
