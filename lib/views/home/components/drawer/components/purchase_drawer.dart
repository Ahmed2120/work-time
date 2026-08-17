import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../components/constant.dart';
import '../../../../purchase/purchase_app.dart';

class PurchaseDrawer extends StatelessWidget {
  const PurchaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                ? AppColors.primaryPurple.withValues(alpha: 0.2)
                : AppColors.lightPurple,
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            size: 20,
            color: AppColors.primaryPurple,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        title: Text(
          AppConfig.isPlayStore ? 'الترقية والاشتراك' : 'تفعيل ترخيص التطبيق',
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
  }
}
