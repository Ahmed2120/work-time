import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/purchase/purchase_app.dart';

class TrialExpiredBanner extends StatelessWidget {
  const TrialExpiredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<bool>(
      future: SecureStorageHelper.isTrialExpired(),
      builder: (context, snapshot) {
        final isExpired = snapshot.data ?? false;
        if (!isExpired) return const SizedBox.shrink();

        return FutureBuilder<bool>(
          future: SecureStorageHelper.wasSubscribedBefore(),
          builder: (context, subSnapshot) {
            final wasSubscribed = subSnapshot.data ?? false;
            final title = wasSubscribed ? 'انتهت فترة الاشتراك' : 'انتهت الفترة التجريبية';
            final btnText = wasSubscribed ? 'تجديد الاشتراك' : 'ترقية الحساب';

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFFFF7ED), // Amber/Orange warm tint
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: isDark ? 0.3 : 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_clock_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF9A3412),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          'بياناتك محفوظة بالكامل • وضع القراءة فقط',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFFC2410C),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      push(screen: const PurchaseApp(), context: context);
                    },
                    child: Text(
                      btnText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
