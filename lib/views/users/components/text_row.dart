import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

class TextRow extends StatelessWidget {
  const TextRow({
    required this.title,
    required this.txt,
    super.key,
  });

  final String title;
  final String txt;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            txt,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
