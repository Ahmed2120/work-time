import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/reports_view_model.dart';

/// Clean, modular tile displaying individual worker balance and remaining wage.
class WorkerBalanceTile extends StatelessWidget {
  final WorkerMonthlyReport report;
  final String currency;

  const WorkerBalanceTile({
    required this.report,
    required this.currency,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = report.remaining;

    final Color badgeBg;
    final Color badgeText;
    final String badgeLabel;

    if (remaining > 0) {
      badgeBg = isDark
          ? AppColors.primaryAmber.withValues(alpha: 0.18)
          : AppColors.lightAmber;
      badgeText = isDark ? AppColors.amberAccent : AppColors.primaryAmberDark;
      badgeLabel = '${context.l10n.remainingBadge} ${_formatNum(remaining)} $currency';
    } else if (remaining < 0) {
      badgeBg = isDark
          ? Colors.blue.withValues(alpha: 0.18)
          : Colors.blue.shade50;
      badgeText = isDark ? Colors.lightBlueAccent : Colors.blue.shade800;
      badgeLabel = '${context.l10n.overpaidBadge} ${_formatNum(remaining.abs())} $currency';
    } else {
      badgeBg = isDark ? AppColors.successBgDark : AppColors.successBgLight;
      badgeText = AppColors.successText;
      badgeLabel = '${context.l10n.settledFull} ✅';
    }

    final daysText = report.daysPresent % 1 == 0
        ? report.daysPresent.toInt().toString()
        : report.daysPresent.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: remaining > 0
              ? (isDark
                  ? AppColors.primaryAmber.withValues(alpha: 0.35)
                  : AppColors.primaryAmber.withValues(alpha: 0.3))
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: remaining > 0 ? 1.2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark
                    ? AppColors.primaryAmber.withValues(alpha: 0.22)
                    : AppColors.lightAmber,
                child: Text(
                  report.userName.isNotEmpty ? report.userName[0] : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? AppColors.amberAccent : AppColors.primaryAmber,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.userName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      report.userJob.isNotEmpty
                          ? '${report.userJob} • $daysText ${context.l10n.day}'
                          : '$daysText ${context.l10n.day}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              // Prominent Remaining Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badgeText,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricText(
                label: context.l10n.totalEarned,
                value: '${_formatNum(report.totalEarned)} $currency',
                isDark: isDark,
              ),
              _metricText(
                label: context.l10n.withdrawnPaid,
                value: '${_formatNum(report.totalReceived)} $currency',
                isDark: isDark,
                valueColor: AppColors.dangerText,
              ),
              _metricText(
                label: context.l10n.wageCol,
                value: '${_formatNum(report.dailyRate)} $currency',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricText({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ??
                (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  static String _formatNum(num val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }
}
