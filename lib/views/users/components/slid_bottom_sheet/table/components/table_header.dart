import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

class TableHeader extends StatelessWidget {
  const TableHeader(this.txt, {super.key});
  final String txt;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.lightPurple,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            txt,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
