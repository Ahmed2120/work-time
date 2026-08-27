import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';

import '../../../../components/constant.dart';
import '../../../../purchase/purchase_app.dart';

class PurchaseDrawer extends StatelessWidget {
  const PurchaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadTrialStatus(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {
          'isSubscribed': false,
          'remainingDays': AppConfig.trialDurationDays,
          'isExpired': false,
        };

        final bool isSubscribed = data['isSubscribed'] as bool;
        final int remainingDays = data['remainingDays'] as int;
        final bool isExpired = data['isExpired'] as bool;

        String title = AppConfig.isPlayStore ? 'الترقية والاشتراك' : 'تفعيل ترخيص التطبيق';
        String? badgeText;
        Color badgeBg = AppColors.lightAmber;
        Color badgeFg = AppColors.primaryAmber;

        if (AppConfig.isPlayStore) {
          if (isSubscribed) {
            title = 'النسخة غير المحدودة';
            badgeText = 'نشط ⭐';
            badgeBg = AppColors.successBgLight;
            badgeFg = AppColors.successText;
          } else if (isExpired) {
            title = 'ترقية الحساب';
            badgeText = 'انتهت التجربة 🔒';
            badgeBg = AppColors.dangerBgLight;
            badgeFg = AppColors.dangerText;
          } else {
            title = 'الترقية والاشتراك';
            badgeText = 'متبقي $remainingDays يوم';
            badgeBg = AppColors.lightAmber;
            badgeFg = AppColors.primaryAmber;
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.primaryAmber.withValues(alpha: 0.2)
                    : AppColors.lightAmber,
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                size: 20,
                color: AppColors.primaryAmber,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? badgeBg.withValues(alpha: 0.2) : badgeBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: badgeFg.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: badgeFg,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              push(screen: const PurchaseApp(), context: context);
            },
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadTrialStatus() async {
    final bool isSubscribed = await SecureStorageHelper.isUserExist();
    final int remainingDays = await SecureStorageHelper.getRemainingTrialDays();
    final bool isExpired = await SecureStorageHelper.isTrialExpired();
    return {
      'isSubscribed': isSubscribed,
      'remainingDays': remainingDays,
      'isExpired': isExpired,
    };
  }
}
