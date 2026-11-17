import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/attendance.dart';

/// A reusable, decoupled widget for selecting worker's daily shift ratio (Full-day, Half-day, Quarter-day, or Custom).
/// Complies with Single Responsibility and keeps attendance views readable.
class DayRatioSelector extends StatelessWidget {
  const DayRatioSelector({
    required this.currentRatio,
    required this.baseSalary,
    required this.onRatioChanged,
    super.key,
  });

  final double currentRatio;
  final String baseSalary;
  final ValueChanged<double> onRatioChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final earned = Attendance.calculateSalaryForRatio(baseSalary, currentRatio);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Label & Current Wage ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.timelapse_rounded,
                    size: 18,
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.workShift,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${context.l10n.earnedToday}: $earned ${context.l10n.currency}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Preset Ratio Chips ─────────────────────────────────────────
          Row(
            children: [
              _buildRatioChip(
                context: context,
                label: context.l10n.fullDayShort,
                ratio: 1.0,
                color: AppColors.success,
                isSelected: currentRatio == 1.0,
                isDark: isDark,
              ),
              const SizedBox(width: 6),
              _buildRatioChip(
                context: context,
                label: context.l10n.halfDayShort,
                ratio: 0.5,
                color: AppColors.primaryAmber,
                isSelected: currentRatio == 0.5,
                isDark: isDark,
              ),
              const SizedBox(width: 6),
              _buildRatioChip(
                context: context,
                label: context.l10n.quarterDayShort,
                ratio: 0.25,
                color: Colors.blueAccent,
                isSelected: currentRatio == 0.25,
                isDark: isDark,
              ),
              const SizedBox(width: 6),
              _buildCustomChip(
                context: context,
                isDark: isDark,
                isSelected: currentRatio != 1.0 &&
                    currentRatio != 0.5 &&
                    currentRatio != 0.25,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatioChip({
    required BuildContext context,
    required String label,
    required double ratio,
    required Color color,
    required bool isSelected,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onRatioChanged(ratio),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.25 : 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? color
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomChip({
    required BuildContext context,
    required bool isDark,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showCustomRatioDialog(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryPurple.withValues(alpha: isDark ? 0.25 : 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryPurple
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            isSelected
                ? '${currentRatio % 1 == 0 ? currentRatio.toInt() : currentRatio}'
                : context.l10n.customShift,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.primaryPurple
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomRatioDialog(BuildContext context) {
    final controller = TextEditingController(
      text: (currentRatio != 1.0 && currentRatio != 0.5 && currentRatio != 0.25)
          ? '$currentRatio'
          : '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            context.l10n.customShiftTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: context.l10n.customShiftHint,
                    prefixIcon: const Icon(Icons.calculate_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return context.l10n.ratioInvalid;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final val = double.parse(controller.text.trim());
                  Navigator.of(dialogContext).pop();
                  onRatioChanged(val);
                }
              },
              child: Text(
                context.l10n.save,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        );
      },
    );
  }
}
