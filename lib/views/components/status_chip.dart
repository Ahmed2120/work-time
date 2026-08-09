import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

/// Modern status pill for attendance states.
/// - حاضر → soft green
/// - غائب → soft red/rose
/// - لم يسجل → soft amber
class StatusChip extends StatelessWidget {
  final String title;

  const StatusChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor;
    final Color textColor;

    if (title == 'حاضر') {
      bgColor = isDark ? AppColors.successBgDark : AppColors.successBgLight;
      textColor = isDark ? const Color(0xFF6EE7B7) : AppColors.successText;
    } else if (title == 'غائب') {
      bgColor = isDark ? AppColors.dangerBgDark : AppColors.dangerBgLight;
      textColor = isDark ? const Color(0xFFFCA5A5) : AppColors.dangerText;
    } else {
      bgColor = isDark ? AppColors.warningBgDark : AppColors.warningBgLight;
      textColor = isDark ? const Color(0xFFFDE68A) : AppColors.warningText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
