import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/constant.dart';

import 'components/purchase_data.dart';

class PurchaseApp extends StatelessWidget {
  const PurchaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        title: Text(
          AppConfig.isPlayStore ? 'ترقية الحساب والاشتراك' : 'تفعيل ترخيص التطبيق',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ─── Main Purchase / Activation Card ─────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1,
                    ),
                  ),
                  child: AppConfig.isPlayStore
                      ? _buildPlayStorePaywall(context, isDark)
                      : const PurchaseData(),
                ),

                const SizedBox(height: 20),

                // ─── Info / Security Note ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'جميع البيانات والنسخ الاحتياطي مشفرة ومحمية بالكامل',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Placeholder paywall for Play Store Subscription variant
  Widget _buildPlayStorePaywall(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.primaryPurple.withValues(alpha: 0.2)
                : AppColors.lightPurple,
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            size: 34,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'الترقية إلى النسخة غير المحدودة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'احصل على إمكانية إضافة عدد غير محدود من العمال والملاحظات وسجلات الحضور والنسخ السحابي.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: const Text(
              'الاشتراك عبر Google Play',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            onPressed: () {
              // Google Play In-App Purchase integration trigger
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم ربط بوابة دفع Google Play قريباً'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
