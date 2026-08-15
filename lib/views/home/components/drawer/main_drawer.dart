import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';

import 'components/backup_drawer.dart';
import 'components/purchase_drawer.dart';
import 'components/reminder_drawer.dart';
import 'components/reports_drawer.dart';
import 'components/theme_drawer.dart';
import 'components/title_drawer.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleDrawer(),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const ReportsDrawer(),
                  _divider(isDark),
                  const ReminderDrawer(),
                  _divider(isDark),
                  if (AppConfig.enableBackupFeature) const BackupDrawer(),
                  if (AppConfig.enableBackupFeature) _divider(isDark),
                  const ThemeDrawer(),
                  if (trial) _divider(isDark),
                  if (trial) const PurchaseDrawer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
    );
  }
}
