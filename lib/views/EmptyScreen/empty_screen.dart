import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.primaryLight,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 40,
                color: isDark ? AppColors.indigoAccent : AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'لا تـوجد بيانات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
