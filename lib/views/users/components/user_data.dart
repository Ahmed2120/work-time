import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/components/app_card.dart';
import 'package:work_time/views/home/components/balance/worker_balance_share_sheet.dart';

import 'text_row.dart';

class UserData extends StatelessWidget {
  const UserData({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String firstLetter = user.name.isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';

    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.primaryPurple.withValues(alpha: 0.3) : AppColors.lightPurple,
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    if (user.job.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.job,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 10),
          TextRow(title: context.l10n.workerName, txt: user.name),
          TextRow(title: context.l10n.jobTitle, txt: user.job.isNotEmpty ? user.job : context.l10n.notSpecified),
          TextRow(title: context.l10n.dailyWage, txt: '${user.salary} ${context.currency}'),
          TextRow(
            title: context.l10n.defaultWorkShift,
            txt: _shiftLabel(context, user.defaultDayRatio),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final reportsVM = Provider.of<ReportsViewModel>(context, listen: false);
              final report = await reportsVM.getWorkerReport(user: user);
              if (!context.mounted) return;
              final arabicMonths = [
                'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
                'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
              ];
              final englishMonths = [
                'January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'
              ];
              final m = reportsVM.selectedMonth.month;
              final monthName = context.isArabic ? arabicMonths[m - 1] : englishMonths[m - 1];
              final monthTitle = '$monthName ${reportsVM.selectedMonth.year}';

              WorkerBalanceShareSheet.show(
                context,
                report: report,
                monthTitle: monthTitle,
                currency: context.currencyRead,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: isDark ? AppColors.primaryPurple : AppColors.primaryPurple,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.shareStatement,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shiftLabel(BuildContext context, double ratio) {
    if (ratio == 1.0) return context.l10n.fullDayShort;
    if (ratio == 0.5) return context.l10n.halfDayShort;
    if (ratio == 0.25) return context.l10n.quarterDayShort;
    return '${ratio % 1 == 0 ? ratio.toInt() : ratio} ${context.l10n.day}';
  }
}
