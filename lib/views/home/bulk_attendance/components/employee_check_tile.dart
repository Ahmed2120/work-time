import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/user.dart';

class EmployeeCheckTile extends StatelessWidget {
  const EmployeeCheckTile({
    super.key,
    required this.user,
    required this.isChecked,
    required this.onChanged,
    this.alreadyAttended = false,
  });

  final User user;
  final bool isChecked;
  final bool alreadyAttended;
  /// Null when the tile is locked (alreadyAttended = true).
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstLetter = user.name.trim().isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: alreadyAttended ? null : () => onChanged!(!isChecked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: alreadyAttended
              ? (isDark ? AppColors.darkSurface.withValues(alpha: 0.5) : const Color(0xFFF8F8F8))
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: alreadyAttended
                ? (isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : const Color(0xFFE5E7EB))
                : isChecked
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isChecked && !alreadyAttended ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Opacity(
              opacity: alreadyAttended ? 0.45 : 1.0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : AppColors.primaryLight,
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name & job + already-attended badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: alreadyAttended
                          ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (alreadyAttended)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        context.l10n.alreadyAttended,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          color: AppColors.success.withValues(alpha: 0.8),
                        ),
                      ),
                    )
                  else if (user.job.isNotEmpty)
                    Text(
                      user.job,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Checkbox or lock icon
            if (alreadyAttended)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.success.withValues(alpha: 0.6),
                size: 24,
              )
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isChecked ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isChecked
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 2,
                  ),
                ),
                child: isChecked
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

