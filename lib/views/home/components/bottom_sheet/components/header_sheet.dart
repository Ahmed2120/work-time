import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

class HeaderSheet extends StatelessWidget {
  const HeaderSheet({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'إغلاق',
          ),
        ],
      ),
    );
  }
}
