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
    final String firstLetter = user.name.isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';

    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      color: Colors.white,
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (user.job.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.job,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          TextRow(title: 'الاسم', txt: user.name),
          TextRow(title: 'الوظيفة', txt: user.job),
          TextRow(title: 'الفئة', txt: user.salary.toString()),
        ],
      ),
    );
  }
}
