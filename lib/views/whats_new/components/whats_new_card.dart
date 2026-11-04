import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/whats_new_item.dart';

class WhatsNewCard extends StatelessWidget {
  const WhatsNewCard({
    super.key,
    required this.item,
    required this.isLatest,
  });

  final WhatsNewItem item;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLatest
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isLatest ? 1.5 : 1,
        ),
        boxShadow: isLatest
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Tag + Version + Date ─────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isLatest
                      ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primaryLight)
                      : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isLatest
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  item.tag,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLatest ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (item.version.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'v${item.version}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              const Spacer(),
              if (item.date.isNotEmpty)
                Text(
                  item.date,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ─── Title ───────────────────────────────────────────────────
          Text(
            item.title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),

          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.description,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
          ],

          // ─── Features Bullet Points ──────────────────────────────────
          if (item.features.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            const SizedBox(height: 12),
            ...item.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4, left: 8),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

