import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/views/components/app_card.dart';

import 'text_row.dart';

class UserData extends StatelessWidget {
  const UserData({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String firstLetter = user.name.isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';

    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.primaryPurple.withValues(alpha: 0.3) : AppColors.lightPurple,
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (user.job.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.job,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 10),
          TextRow(title: 'الاسم الكامل', txt: user.name),
          TextRow(title: 'الوظيفة', txt: user.job.isNotEmpty ? user.job : 'غير محدد'),
          TextRow(title: 'الفئة / اليومية', txt: '${user.salary} ريال'),
        ],
      ),
    );
  }
}
