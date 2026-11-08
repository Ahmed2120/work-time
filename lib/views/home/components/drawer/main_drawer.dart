import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/view_models/whats_new_view_model.dart';

import '../../../../core/services/rate_service.dart';
import '../../../../core/utils/extensions/context_extension.dart';
import '../../../backup/backup_view.dart';
import '../../../components/constant.dart';
import '../../../feedback/feedback_view.dart';
import '../../../projects/projects_view.dart';
import '../../../reports/reports_view.dart';
import '../../../settings/manage_work_places_view.dart';
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
                  DrawerItemWidget(
                    title: context.l10n.monthlyReports,
                    icon: Icons.assessment_outlined,
                    onPress: ()=> push(screen: const ReportsView(), context: context),
                  ),
                  _divider(isDark),
                  DrawerItemWidget(
                      title: context.l10n.projectsAndSites,
                      icon: Icons.construction_rounded,
                    onPress: () => push(screen: const ProjectsView(), context: context),
                  ),
                  _divider(isDark),
                  DrawerItemWidget(
                    title: context.l10n.manageWorkplaces,
                    icon: Icons.location_on_outlined,
                      onPress: () {
                        Navigator.of(context).pop(); // close drawer
                        push(screen: const ManageWorkPlacesView(), context: context);
                      }
                  ),
                  _divider(isDark),
                  const ReminderDrawer(),
                  _divider(isDark),
                  if (AppConfig.enableBackupFeature) DrawerItemWidget(
                    title: context.l10n.backup,
                    icon: Icons.construction_rounded,
                    onPress: ()=> push(screen: const BackupView(), context: context),
                  ),
                  if (AppConfig.enableBackupFeature) _divider(isDark),
                  const ThemeDrawer(),
                  _divider(isDark),
                  const LanguageDrawer(),
                  _divider(isDark),
                  DrawerItemWidget(
                    title: context.l10n.rateApp,
                    icon: Icons.star_rounded,
                    onPress: () {
                      Navigator.pop(context); // إغلاق الـ Drawer
                      RateService.openStoreListing();
                    },
                  ),
                  _divider(isDark),
                  DrawerItemWidget(
                    title: context.l10n.feedback,
                    icon: IconlyLight.chat,
                    onPress: () {
                      Navigator.pop(context); // إغلاق القائمة الجانبية أولاً
                      push(screen: const FeedbackView(), context: context);
                    },
                  ),
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

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({super.key, required this.title, required this.icon, required this.onPress});

  final String title;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

