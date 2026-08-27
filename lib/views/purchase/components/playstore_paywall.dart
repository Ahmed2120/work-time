import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/purchase_view_model.dart';
import 'package:work_time/views/bottom_nav_view.dart';
import 'package:work_time/views/components/app_button.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/components/functions.dart';
import 'package:work_time/views/purchase/components/subscription_plan_card.dart';

class PlayStorePaywall extends StatelessWidget {
  const PlayStorePaywall({super.key});

  static const String privacyPolicyUrl = 'https://ahmed202ashraf202.github.io/work_time/privacy_policy.html';
  static const String termsUrl = 'https://policies.google.com/terms';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PurchaseViewModel>(
      builder: (context, purchaseVM, _) {
        // Handle result callbacks
        if (purchaseVM.statusMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final msg = purchaseVM.statusMessage!;
            final isSuccess = purchaseVM.isSuccess;
            purchaseVM.clearStatus();

            if (isSuccess) {
              pushReplacement(context: context, screen: const BottomNavView());
              showToast(context, msg);
            } else {
              _showErrorDialog(context, msg);
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── App Logo with Amber Glow ─────────────────────────────
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAmber.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 38,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Header Title & Slogan ───────────────────────────────
            Text(
              'ترقية حساب عُمَّالي إلى غير المحدود',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'اختر الباقة المناسبة لمؤسستك واستمتع بجميع الميزات بلا حدود',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // ─── Premium Features Checklist ──────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  _buildFeatureRow('إضافة عدد غير محدود من العمال والورش', isDark),
                  _buildFeatureRow('تسجيل الحضور والغياب والسهرات بلا قيود', isDark),
                  _buildFeatureRow('مزامنة سحابية أسبوعية تلقائية على Google Drive', isDark),
                  _buildFeatureRow('تصدير كشوف رواتب وحسابات PDF بلا حدود', isDark),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Subscription Plan Cards ─────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اختر خطة الاشتراك:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 10),

            ...AppConfig.subscriptionTiers.map((tier) {
              final displayPrice = purchaseVM.getDisplayPriceForTier(tier);
              final isSelected = purchaseVM.selectedTierId == tier.id;

              return SubscriptionPlanCard(
                tier: tier,
                displayPrice: displayPrice,
                isSelected: isSelected,
                onTap: () => purchaseVM.selectTier(tier.id),
              );
            }),

            const SizedBox(height: 16),

            // ─── Main Purchase Button ────────────────────────────────
            AppButton(
              label: 'الاشتراك الآن عبر Google Play',
              icon: Icons.lock_open_rounded,
              style: AppButtonStyle.primary,
              isLoading: purchaseVM.isPurchasing,
              onPressed: () => purchaseVM.buySelectedSubscription(),
            ),

            const SizedBox(height: 12),

            // ─── Restore Purchases Button ────────────────────────────
            TextButton.icon(
              onPressed: purchaseVM.isPurchasing ? null : () => purchaseVM.restorePurchases(),
              icon: const Icon(Icons.restore_rounded, size: 18, color: AppColors.primaryAmber),
              label: const Text(
                'استعادة المشتريات السابقة (Restore)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryAmber,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // ─── Legal Links (Privacy & Terms - Required by Google Play) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegalLink('سياسة الخصوصية', privacyPolicyUrl),
                Text(
                  ' • ',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                _buildLegalLink('شروط الاستخدام', termsUrl),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLink(String title, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primaryAmber,
          fontFamily: 'Cairo',
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 24),
            SizedBox(width: 8),
            Text(
              'تنبيه عملية الشراء',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontFamily: 'Cairo'),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً', style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}
