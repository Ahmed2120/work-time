import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/home/components/balance/workers_balance_bottom_sheet.dart';

/// Compact, interactive financial summary card displayed on HomeView ("باقي كام").
/// Tapping opens [WorkersBalanceBottomSheet] with full worker-by-worker breakdown.
class FinancialBalanceCard extends StatelessWidget {
  const FinancialBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportsVM = Provider.of<ReportsViewModel>(context);
    final summary = reportsVM.reportSummary;
    final currency = context.l10n.currency;

    final double totalEarned = summary?.totalSalaryEarned ?? 0;
    final double totalReceived = summary?.totalSalaryReceived ?? 0;
    final double totalRemaining = summary?.totalRemaining ?? 0;

    final String monthName = _getMonthName(reportsVM.selectedMonth.month, context);
    final String monthTitle = '$monthName ${reportsVM.selectedMonth.year}';

    final Color remainingBg;
    final Color remainingText;
    final String remainingLabel;

    if (totalRemaining > 0) {
      remainingBg = isDark
          ? AppColors.primaryAmber.withValues(alpha: 0.18)
          : AppColors.lightAmber;
      remainingText = isDark ? AppColors.amberAccent : AppColors.primaryAmberDark;
      remainingLabel = '${_formatNum(totalRemaining)} $currency';
    } else if (totalRemaining < 0) {
      remainingBg = isDark
          ? Colors.blue.withValues(alpha: 0.18)
          : Colors.blue.shade50;
      remainingText = isDark ? Colors.lightBlueAccent : Colors.blue.shade800;
      remainingLabel = '${_formatNum(totalRemaining.abs())} $currency';
    } else {
      remainingBg = isDark ? AppColors.successBgDark : AppColors.successBgLight;
      remainingText = AppColors.successText;
      remainingLabel = '${context.l10n.settledFull} ✅';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => WorkersBalanceBottomSheet.show(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: totalRemaining > 0
                    ? (isDark
                        ? AppColors.primaryAmber.withValues(alpha: 0.4)
                        : AppColors.primaryAmber.withValues(alpha: 0.28))
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: totalRemaining > 0 ? 1.3 : 1,
              ),
            ),
            child: Column(
              children: [
                // ─── Header: Icon, Title & "View Details" Pill ──────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryAmber.withValues(alpha: 0.2)
                            : AppColors.lightAmber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: isDark ? AppColors.amberAccent : AppColors.primaryAmber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.balanceCardTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            monthTitle,
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
                    // Action chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryAmber.withValues(alpha: 0.15)
                            : AppColors.lightAmber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.viewDetails,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.amberAccent
                                  : AppColors.primaryAmberDark,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            context.isArabic
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.amberAccent
                                : AppColors.primaryAmberDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(height: 10),

                // ─── 3 Metrics Row ──────────────────────────────────────────
                Row(
                  children: [
                    // Total Earned (المستحق)
                    Expanded(
                      child: _metricBox(
                        title: context.l10n.totalEarned,
                        value: '${_formatNum(totalEarned)} $currency',
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Total Received / Advanced (المدفوع / المسحوب)
                    Expanded(
                      child: _metricBox(
                        title: context.l10n.withdrawnPaid,
                        value: '${_formatNum(totalReceived)} $currency',
                        isDark: isDark,
                        valueColor: AppColors.dangerText,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Net Remaining Due (باقي عليك)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: remainingBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.remainingForYou,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: remainingText,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              remainingLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: remainingText,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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

  Widget _metricBox({
    required String title,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ??
                (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getMonthName(int month, BuildContext context) {
    final arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final englishMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month < 1 || month > 12) return '';
    return context.isArabic ? arabicMonths[month - 1] : englishMonths[month - 1];
  }

  static String _formatNum(num val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }
}
