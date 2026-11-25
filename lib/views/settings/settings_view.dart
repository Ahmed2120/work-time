import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/views/backup/backup_view.dart';
import 'package:work_time/views/components/app_card.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/home/components/drawer/components/language_drawer.dart';
import 'package:work_time/views/home/components/drawer/components/reminder_drawer.dart';
import 'package:work_time/views/home/components/drawer/components/theme_drawer.dart';
import 'package:work_time/views/settings/components/currency_drawer.dart';

/// الشاشة المخصصة لإعدادات التطبيق (المظهر، اللغة، التذكير، النسخ الاحتياطي)
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = '${info.version}+${info.buildNumber}';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: borderColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── 1. المظهر واللغة والعملة ────────────────────────────────
              _buildSectionTitle(
                context.isArabic
                    ? 'المظهر واللغة والعملة'
                    : 'Appearance, Language & Currency',
                isDark,
              ),
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    const ThemeDrawer(),
                    _divider(isDark),
                    const LanguageDrawer(),
                    _divider(isDark),
                    const CurrencyDrawer(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ─── 2. التنبيهات والمواعيد ────────────────────────────────────
              _buildSectionTitle(
                context.isArabic ? 'التنبيهات والمواعيد' : 'Reminders & Schedule',
                isDark,
              ),
              const AppCard(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: ReminderDrawer(),
              ),
              const SizedBox(height: 16),

              // ─── 3. النسخ الاحتياطي ─────────────────────────────────────────
              if (AppConfig.enableBackupFeature) ...[
                _buildSectionTitle(
                  context.isArabic ? 'البيانات والأمان' : 'Data & Security',
                  isDark,
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.cloud_sync_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      context.l10n.backup,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    subtitle: Text(
                      context.isArabic ? 'حفظ واسترجاع البيانات عبر Google Drive' : 'Cloud backup via Google Drive',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    onTap: () => push(screen: const BackupView(), context: context),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ─── 4. عن التطبيق ─────────────────────────────────────────────
              _buildSectionTitle(
                context.isArabic ? 'عن التطبيق' : 'About App',
                isDark,
              ),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.isArabic ? 'عُمَّالي - كشف حضور ورواتب' : 'WorkTime - Attendance & Wages',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _appVersion.isNotEmpty
                                ? '${context.isArabic ? 'الإصدار الحالي:' : 'Version:'} $_appVersion'
                                : (context.isArabic ? 'جاري التحميل...' : 'Loading...'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_appVersion.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryPurple.withValues(alpha: 0.2)
                              : AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'v$_appVersion',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.indigoAccent : AppColors.primary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }
}
