import 'package:flutter/material.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionTier tier;
  final String displayPrice;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    required this.tier,
    required this.displayPrice,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmall = screenWidth < 360;

    // Responsive sizing
    final double titleFontSize = isSmall ? 13.0 : 15.0;
    final double priceFontSize = isSmall ? 13.0 : 15.0;
    final double durationFontSize = isSmall ? 11.0 : 12.0;
    final double badgeFontSize = isSmall ? 9.0 : 10.0;
    final double radioSize = isSmall ? 20.0 : 22.0;
    final double hPadding = isSmall ? 10.0 : 16.0;
    final double vPadding = isSmall ? 11.0 : 14.0;
    final double spacerWidth = isSmall ? 10.0 : 14.0;
    final double badgeHPad = isSmall ? 5.0 : 8.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF1E293B) : AppColors.lightAmber)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryAmber
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryAmber.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── Radio Indicator ─────────────────────────────
              Container(
                width: radioSize,
                height: radioSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryAmber
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primaryAmber : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: Icon(Icons.check, size: isSmall ? 12 : 14, color: Colors.white),
                      )
                    : null,
              ),

              SizedBox(width: spacerWidth),

              // ─── Tier Info ─────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title + Badge row — wraps if too long
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          tier.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (tier.badgeText != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: badgeHPad, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: tier.isPopular ? AppColors.primaryGradient : null,
                              color: tier.isPopular ? null : AppColors.successBgLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tier.badgeText!,
                              style: TextStyle(
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.bold,
                                color: tier.isPopular ? Colors.white : AppColors.successText,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'المدة: ${tier.durationText}',
                      style: TextStyle(
                        fontSize: durationFontSize,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ─── Price Display ──────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      displayPrice,
                      style: TextStyle(
                        fontSize: priceFontSize,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primaryAmber
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  if (tier.discountPercent != null)
                    Text(
                      'خصم ${tier.discountPercent}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successText,
                        fontFamily: 'Cairo',
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
