import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/constant.dart';

import 'components/backup.dart';
import 'components/restore.dart';
import 'components/steps.dart';

class BackupView extends StatelessWidget {
  const BackupView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي'),
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: const Column(
            children: [
              Steps(),
              SizedBox(height: 24),
              Backup(),
              SizedBox(height: 16),
              Restore(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
