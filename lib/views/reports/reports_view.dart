import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/services/pdf_report_service.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/components/app_button.dart';
import 'package:work_time/views/components/app_card.dart';
import 'package:work_time/views/components/functions.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsViewModel>(context, listen: false).fetchMonthlyReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportsVM = Provider.of<ReportsViewModel>(context);
    final summary = reportsVM.reportSummary;

    final String monthName = _getMonthName(reportsVM.selectedMonth.month, context);
    final String monthYearTitle = '$monthName ${reportsVM.selectedMonth.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.monthlyReports),
        actions: [
          if (summary != null && summary.workerReports.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primaryPurple),
              tooltip: context.l10n.exportPdf,
              onPressed: () async {
                final isExpired = await SecureStorageHelper.isTrialExpired();
                if (isExpired) {
                  if (context.mounted) {
                    showFlushBar(
                      context,
                      customMessage: context.isArabic
                          ? 'تصدير ملفات PDF ميزة حصرية للمشتركين. يرجى الاشتراك للمتابعة.'
                          : 'Exporting PDF reports is exclusive to subscribers. Please subscribe to continue.',
                    );
                  }
                  return;
                }
                PdfReportService.generateAndPreviewReport(summary);
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Month / Year Selector ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 28),
                    onPressed: () => reportsVM.previousMonth(),
                    tooltip: context.isArabic ? 'الشهر السابق' : 'Previous Month',
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: reportsVM.selectedMonth,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        reportsVM.setMonth(picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.primaryPurple.withValues(alpha: 0.2) : AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.primaryPurple),
                          const SizedBox(width: 8),
                          Text(
                            monthYearTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                    onPressed: () => reportsVM.nextMonth(),
                    tooltip: context.isArabic ? 'الشهر التالي' : 'Next Month',
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

            // ─── Content Area ─────────────────────────────────────────────
            Expanded(
              child: reportsVM.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                  : summary == null || summary.workerReports.isEmpty
                      ? _buildEmptyState(isDark)
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ─── Financial & Attendance KPI Cards ─────────────────
                              _buildKpiGrid(summary, isDark),

                              const SizedBox(height: 20),

                              // ─── Section Header ──────────────────────────────────
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${context.l10n.workersStatement} (${summary.workerReports.length})',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Text(
                                    '${context.l10n.monthPrefix} $monthName',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // ─── Workers Breakdown List ─────────────────────────
                              ...summary.workerReports.map((w) => _buildWorkerCard(w, isDark)),

                              const SizedBox(height: 20),

                              // ─── Export PDF Button ──────────────────────────────
                              AppButton(
                                label: context.l10n.exportAndSharePdf,
                                icon: Icons.picture_as_pdf_rounded,
                                style: AppButtonStyle.primary,
                                onPressed: () => PdfReportService.generateAndPreviewReport(summary),
                              ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiGrid(MonthlyReportSummary summary, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _kpiTile(
                title: context.l10n.totalEarned,
                value: '${summary.totalSalaryEarned.toStringAsFixed(1)} ${context.l10n.currency}',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.primaryPurple,
                bgColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _kpiTile(
                title: context.l10n.withdrawnPaid,
                value: '${summary.totalSalaryReceived.toStringAsFixed(1)} ${context.l10n.currency}',
                icon: Icons.payments_outlined,
                iconColor: AppColors.error,
                bgColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _kpiTile(
                title: context.l10n.netRemaining,
                value: '${summary.totalRemaining.toStringAsFixed(1)} ${context.l10n.currency}',
                icon: Icons.savings_outlined,
                iconColor: AppColors.success,
                bgColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark: isDark,
                isHighlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _kpiTile(
                title: context.l10n.totalDaysPresent,
                value: '${summary.totalDaysPresent} ${context.l10n.day}',
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppColors.primaryPurple,
                bgColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpiTile({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isDark,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight
              ? iconColor.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlight ? iconColor : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(WorkerMonthlyReport w, bool isDark) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isDark ? AppColors.primaryPurple.withValues(alpha: 0.3) : AppColors.lightPurple,
                child: Text(
                  w.userName.isNotEmpty ? w.userName[0] : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      w.userJob.isNotEmpty
                          ? '${w.userJob} • ${context.l10n.wageCol}: ${w.dailyRate} ${context.l10n.currency}'
                          : '${context.l10n.wageCol}: ${w.dailyRate} ${context.l10n.currency}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              // Remaining amount pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: w.remaining > 0
                      ? (isDark ? AppColors.primaryPurple.withValues(alpha: 0.2) : AppColors.lightPurple)
                      : (isDark ? AppColors.successBgDark : AppColors.successBgLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(context.l10n.remainingAmount, style: const TextStyle(fontSize: 10, color: AppColors.primaryPurple)),
                    Text(
                      '${w.remaining.toStringAsFixed(1)} ${context.l10n.currency}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statChip(context.l10n.present, '${w.daysPresent} ${context.l10n.day}', AppColors.success),
              _statChip(context.l10n.absent, '${w.daysAbsent} ${context.l10n.day}', AppColors.error),
              _statChip(context.l10n.overtimeCol, '${w.overtimeDays}', AppColors.warning),
              _statChip(context.l10n.drawnCol, '${w.totalReceived} ${context.l10n.currency}', AppColors.textSecondaryLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF718096), fontFamily: 'Cairo')),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.primaryPurple.withValues(alpha: 0.2) : AppColors.lightPurple,
            ),
            child: const Icon(Icons.assessment_outlined, size: 36, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noDataForMonth,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.selectAnotherMonthHint,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month, BuildContext context) {
    try {
      final date = DateTime(2024, month, 1);
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat.MMMM(locale).format(date);
    } catch (_) {
      return '';
    }
  }
}
