import 'package:flutter/material.dart';
import 'package:work_time/core/services/rate_service.dart';
import 'package:work_time/core/theme/app_colors.dart';
import '../../../../../core/utils/extensions/context_extension.dart';

/// عنصر القائمة الجانبية لتقييم التطبيق بخطوة واحدة مباشرة
class RateDrawer extends StatelessWidget {
  const RateDrawer({super.key});

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
          onTap: () {
            Navigator.pop(context); // إغلاق الـ Drawer
            RateService.openStoreListing();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 22,
                    color: Color(0xFFF59E0B), // Warm Star Amber
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'قيّم التطبيق',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Transform.flip(
                  flipX: context.isArabic,
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
