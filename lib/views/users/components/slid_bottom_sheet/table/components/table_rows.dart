import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

/// A table cell widget that optionally renders a semantic status badge.
class TableRows extends StatelessWidget {
  const TableRows(this.txt, this.padding, {super.key, this.statusType});

  final String txt;
  final double padding;
  // 1 = present, 2 = absent, 3 = overtime, null = plain text
  final int? statusType;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (statusType != null) {
      return _StatusBadge(txt: txt, statusType: statusType!, isDark: isDark);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 7),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            txt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.txt, required this.statusType, required this.isDark});

  final String txt;
  final int statusType;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (statusType) {
      case 1: // Present
        bg = isDark ? AppColors.successBgDark : AppColors.successBgLight;
        textColor = AppColors.successText;
        break;
      case 2: // Absent
        bg = isDark ? AppColors.dangerBgDark : AppColors.dangerBgLight;
        textColor = AppColors.dangerText;
        break;
      case 3: // Overtime
        bg = isDark ? AppColors.warningBgDark : AppColors.warningBgLight;
        textColor = AppColors.warningText;
        break;
      default:
        bg = Colors.transparent;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              txt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
