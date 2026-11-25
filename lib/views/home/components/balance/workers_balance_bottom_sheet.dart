import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/components/functions.dart';
import 'package:work_time/views/home/components/balance/worker_balance_tile.dart';

/// Modal Bottom Sheet presenting detailed workers balances ("باقي كام لكل عامل").
class WorkersBalanceBottomSheet extends StatefulWidget {
  const WorkersBalanceBottomSheet({super.key});

  /// Displays the balance bottom sheet with smooth entry animation.
  static void show(BuildContext context) {
    Provider.of<ReportsViewModel>(context, listen: false).fetchMonthlyReport();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const WorkersBalanceBottomSheet(),
    );
  }

  @override
  State<WorkersBalanceBottomSheet> createState() => _WorkersBalanceBottomSheetState();
}

class _WorkersBalanceBottomSheetState extends State<WorkersBalanceBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportsVM = Provider.of<ReportsViewModel>(context);
    final summary = reportsVM.reportSummary;
    final currency = context.currency;

    final String monthName = _getMonthName(reportsVM.selectedMonth.month, context);
    final String monthTitle = '$monthName ${reportsVM.selectedMonth.year}';

    final List<WorkerMonthlyReport> allWorkers = summary?.workerReports ?? [];
    final List<WorkerMonthlyReport> filteredWorkers = allWorkers.where((w) {
      if (_searchQuery.isEmpty) return true;
      return w.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.userJob.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort: Workers with remaining dues first, then highest remaining to lowest
    filteredWorkers.sort((a, b) => b.remaining.compareTo(a.remaining));

    final int dueCount = allWorkers.where((w) => w.remaining > 0).length;
    final int settledCount = allWorkers.where((w) => w.remaining <= 0).length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ─── Header: Title & Actions ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
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
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.balanceCardTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          monthTitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Copy/Share button
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: context.l10n.copyBalanceReport,
                    color: isDark ? AppColors.amberAccent : AppColors.primaryAmber,
                    onPressed: () => _copySummaryToClipboard(
                      context,
                      monthTitle,
                      allWorkers,
                      summary?.totalRemaining ?? 0,
                      currency,
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ─── Month Navigation ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 24),
                    onPressed: () => reportsVM.previousMonth(),
                    tooltip: context.isArabic ? 'الشهر السابق' : 'Previous Month',
                  ),
                  Text(
                    monthTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.amberAccent : AppColors.primaryAmber,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 24),
                    onPressed: () => reportsVM.nextMonth(),
                    tooltip: context.isArabic ? 'الشهر التالي' : 'Next Month',
                  ),
                ],
              ),
            ),

            // ─── Quick Summary Header Card ─────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(
                    label: context.l10n.remainingForYou,
                    value: '${_formatNum(summary?.totalRemaining ?? 0)} $currency',
                    isDark: isDark,
                    color: isDark ? AppColors.amberAccent : AppColors.primaryAmberDark,
                    isBold: true,
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  _statItem(
                    label: context.l10n.dueWorkersCount,
                    value: '$dueCount',
                    isDark: isDark,
                    color: AppColors.warningText,
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  _statItem(
                    label: context.l10n.settledWorkersCount,
                    value: '$settledCount',
                    isDark: isDark,
                    color: AppColors.successText,
                  ),
                ],
              ),
            ),

            // ─── Search Bar ────────────────────────────────────────────────
            if (allWorkers.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.l10n.searchWorkerByName,
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontFamily: 'Cairo',
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),

            const SizedBox(height: 4),

            // ─── Workers List ──────────────────────────────────────────────
            Expanded(
              child: filteredWorkers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 48,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              context.l10n.noDataForMonth,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      itemCount: filteredWorkers.length,
                      itemBuilder: (ctx, idx) {
                        return WorkerBalanceTile(
                          report: filteredWorkers[idx],
                          currency: currency,
                          monthTitle: monthTitle,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem({
    required String label,
    required String value,
    required bool isDark,
    required Color color,
    bool isBold = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  void _copySummaryToClipboard(
    BuildContext context,
    String monthTitle,
    List<WorkerMonthlyReport> workers,
    double totalRemaining,
    String currency,
  ) {
    if (workers.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln('📋 كشف أرصدة العمال - $monthTitle:');
    buffer.writeln('────────────────────────────');

    for (final w in workers) {
      final remText = w.remaining > 0
          ? 'باقي له ${_formatNum(w.remaining)} $currency'
          : w.remaining == 0
              ? 'خالص ✅'
              : 'مستلم زيادة ${_formatNum(w.remaining.abs())} $currency';

      final penText = w.totalPenalties > 0 ? ' | جزاءات ${_formatNum(w.totalPenalties)}' : '';
      buffer.writeln('• ${w.userName}: المستحق ${_formatNum(w.totalEarned)} | المدفوع ${_formatNum(w.totalReceived)}$penText | $remText');
    }

    buffer.writeln('────────────────────────────');
    buffer.writeln('💰 إجمالي المطلوب سداده: ${_formatNum(totalRemaining)} $currency');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    showToast(context, context.l10n.reportCopied);
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
