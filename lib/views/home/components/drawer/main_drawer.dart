import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/view_models/whats_new_view_model.dart';

import 'components/backup_drawer.dart';
import 'components/feedback_drawer.dart';
import 'components/projects_drawer.dart';
import 'components/purchase_drawer.dart';
import 'components/rate_drawer.dart';
import 'components/reminder_drawer.dart';
import 'components/reports_drawer.dart';
import 'components/theme_drawer.dart';
import 'components/language_drawer.dart';
import 'components/title_drawer.dart';
import 'components/whats_new_drawer.dart';
import 'components/work_places_drawer.dart';

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
                  const ProjectsDrawer(),
                  _divider(isDark),
                  const WorkPlacesDrawer(),
                  _divider(isDark),
                  const ReminderDrawer(),
                  _divider(isDark),
                  if (AppConfig.enableBackupFeature) const BackupDrawer(),
                  if (AppConfig.enableBackupFeature) _divider(isDark),
                  const ThemeDrawer(),
                  _divider(isDark),
                  const LanguageDrawer(),
                  _divider(isDark),
                  const RateDrawer(),
                  _divider(isDark),
                  const FeedbackDrawer(),
                  if (AppConfig.isPlayStore || trial) _divider(isDark),
                  if (AppConfig.isPlayStore || trial) const PurchaseDrawer(),
                  Consumer<WhatsNewViewModel>(
                    builder: (context, whatsNewVM, _) {
                      if (whatsNewVM.items.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _divider(isDark),
                          const WhatsNewDrawer(),
                        ],
                      );
                    },
                  ),
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
