import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/views/components/functions.dart';

/// Clean, modular bottom sheet for sharing or copying an individual worker's account statement.
class WorkerBalanceShareSheet extends StatelessWidget {
  final WorkerMonthlyReport report;
  final String monthTitle;
  final String currency;

  const WorkerBalanceShareSheet({
    required this.report,
    required this.monthTitle,
    required this.currency,
    super.key,
  });

  /// Displays the share bottom sheet modally.
  static void show(
    BuildContext context, {
    required WorkerMonthlyReport report,
    required String monthTitle,
    required String currency,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WorkerBalanceShareSheet(
        report: report,
        monthTitle: monthTitle,
        currency: currency,
      ),
    );
  }

  /// Builds a formatted string statement suitable for sharing via WhatsApp or clipboard.
  static String buildStatementText({
    required BuildContext context,
    required WorkerMonthlyReport report,
    required String monthTitle,
    required String currency,
  }) {
    final buffer = StringBuffer();
    final isAr = context.isArabic;

    final daysText = report.daysPresent % 1 == 0
        ? report.daysPresent.toInt().toString()
        : report.daysPresent.toString();

    final remainingFormatted = _formatNum(report.remaining.abs());

    final String statusText;
    if (report.remaining > 0) {
      statusText = isAr
          ? '💰 المتبقي: $remainingFormatted $currency'
          : '💰 Remaining: $remainingFormatted $currency';
    } else if (report.remaining < 0) {
      statusText = isAr
          ? '💰 مستلم زيادة: $remainingFormatted $currency'
          : '💰 Overpaid: $remainingFormatted $currency';
    } else {
      statusText = isAr ? '💰 الحساب: خالص بالكامل ✅' : '💰 Account: Fully Settled ✅';
    }

    if (isAr) {
      buffer.writeln('📋 *كشف حساب: ${report.userName}*');
      buffer.writeln('📅 *الفترة:* $monthTitle');
      if (report.userJob.isNotEmpty) {
        buffer.writeln('🔨 *المهنة:* ${report.userJob}');
      }
      buffer.writeln('💵 *اليومية:* ${_formatNum(report.dailyRate)} $currency');
      buffer.writeln('🗓️ *أيام الحضور:* $daysText يوم');
      if (report.overtimeDays > 0) {
        buffer.writeln('⏱️ *إضافي:* ${report.overtimeDays} يوم');
      }
      buffer.writeln('📈 *إجمالي المستحق:* ${_formatNum(report.totalEarned)} $currency');
      buffer.writeln('📉 *إجمالي المدفوع:* ${_formatNum(report.totalReceived)} $currency');
      if (report.totalPenalties > 0) {
        buffer.writeln('⚠️ *الجزاءات والخصومات:* -${_formatNum(report.totalPenalties)} $currency');
      }
      buffer.writeln('────────────────────');
      buffer.writeln(statusText);
    } else {
      buffer.writeln('📋 *Account Statement: ${report.userName}*');
      buffer.writeln('📅 *Period:* $monthTitle');
      if (report.userJob.isNotEmpty) {
        buffer.writeln('🔨 *Job:* ${report.userJob}');
      }
      buffer.writeln('💵 *Daily Rate:* ${_formatNum(report.dailyRate)} $currency');
      buffer.writeln('🗓️ *Days Present:* $daysText days');
      if (report.overtimeDays > 0) {
        buffer.writeln('⏱️ *Overtime:* ${report.overtimeDays} days');
      }
      buffer.writeln('📈 *Total Earned:* ${_formatNum(report.totalEarned)} $currency');
      buffer.writeln('📉 *Total Paid:* ${_formatNum(report.totalReceived)} $currency');
      if (report.totalPenalties > 0) {
        buffer.writeln('⚠️ *Penalties & Deductions:* -${_formatNum(report.totalPenalties)} $currency');
      }
      buffer.writeln('────────────────────');
      buffer.writeln(statusText);
    }

    return buffer.toString();
  }

  /// Launches WhatsApp with the formatted text pre-filled.
  static Future<void> shareToWhatsApp(BuildContext context, String text) async {
    final encoded = Uri.encodeComponent(text);
    final whatsappSchemeUri = Uri.parse('whatsapp://send?text=$encoded');
    final whatsappWebUri = Uri.parse('https://api.whatsapp.com/send?text=$encoded');

    try {
      if (await canLaunchUrl(whatsappSchemeUri)) {
        await launchUrl(whatsappSchemeUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    // Fallback: Copy to clipboard if WhatsApp cannot be opened
    await copyToClipboard(context, text);
  }

  /// Copies statement text to clipboard and shows toast.
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showToast(context, context.l10n.statementCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = buildStatementText(
      context: context,
      report: report,
      monthTitle: monthTitle,
      currency: currency,
    );

    final daysText = report.daysPresent % 1 == 0
        ? report.daysPresent.toInt().toString()
        : report.daysPresent.toString();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryAmber.withValues(alpha: 0.2)
                      : AppColors.lightAmber,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
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
                      context.l10n.shareStatement,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      '${report.userName} • $monthTitle',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Preview Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.statementPreview,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.amberAccent : AppColors.primaryAmber,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        monthTitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _previewRow(context, context.l10n.workerName, report.userName, isDark),
                if (report.userJob.isNotEmpty)
                  _previewRow(context, context.l10n.jobTitle, report.userJob, isDark),
                _previewRow(
                  context,
                  context.l10n.wageCol,
                  '${_formatNum(report.dailyRate)} $currency',
                  isDark,
                ),
                _previewRow(
                  context,
                  context.l10n.daysPresent,
                  '$daysText ${context.l10n.day}',
                  isDark,
                ),
                _previewRow(
                  context,
                  context.l10n.totalEarned,
                  '${_formatNum(report.totalEarned)} $currency',
                  isDark,
                ),
                _previewRow(
                  context,
                  context.l10n.withdrawnPaid,
                  '${_formatNum(report.totalReceived)} $currency',
                  isDark,
                  valueColor: AppColors.dangerText,
                ),
                if (report.totalPenalties > 0)
                  _previewRow(
                    context,
                    context.l10n.penalties,
                    '- ${_formatNum(report.totalPenalties)} $currency',
                    isDark,
                    valueColor: AppColors.error,
                  ),
                Divider(
                  height: 16,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _previewRow(
                  context,
                  context.l10n.remainingBadge,
                  report.remaining > 0
                      ? '${_formatNum(report.remaining)} $currency'
                      : report.remaining == 0
                          ? '${context.l10n.settledFull} ✅'
                          : '${context.l10n.overpaidBadge} ${_formatNum(report.remaining.abs())} $currency',
                  isDark,
                  isBold: true,
                  valueColor: report.remaining > 0
                      ? (isDark ? AppColors.amberAccent : AppColors.primaryAmberDark)
                      : (report.remaining == 0 ? AppColors.successText : Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Action Buttons
          Row(
            children: [
              // WhatsApp Share Button (Prominent Green)
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                  label: Text(
                    context.l10n.shareViaWhatsApp,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    shareToWhatsApp(context, text);
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Copy Button
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  label: Text(
                    context.l10n.copyStatement,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    copyToClipboard(context, text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ??
                  (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  static String _formatNum(num val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(1);
  }
}
