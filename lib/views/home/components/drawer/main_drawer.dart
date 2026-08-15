import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';

import 'components/backup_drawer.dart';
import 'components/purchase_drawer.dart';
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
          const SizedBox(height: 16),
          if (AppConfig.enableBackupFeature) const BackupDrawer(),
          if (AppConfig.enableBackupFeature)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          const ThemeDrawer(),
          if (trial)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          if (trial) const PurchaseDrawer(),
        ],
      ),
    );
  }
}
