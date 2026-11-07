import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'project_financial_card.dart';

/// شبكة 2x2 للبطاقات المالية والإحصائية للمشروع
class ProjectSummaryGrid extends StatelessWidget {
  final ProjectStats stats;

  const ProjectSummaryGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final currency = context.l10n.currency;
    return Column(
      children: [
        // الصف الأول: إجمالي المدفوعات + إجمالي الإنفاق
        Row(
          children: [
            ProjectFinancialCard(
              label: context.l10n.totalPaid,
              value: '${stats.totalWages.toStringAsFixed(0)} $currency',
              icon: IconlyBold.wallet,
              iconColor: const Color(0xFF10B981), // Success green
              iconBgColor: const Color(0xFFECFDF5),
            ),
            const SizedBox(width: 12),
            ProjectFinancialCard(
              label: context.l10n.totalSpent,
              value: '${stats.totalSpent.toStringAsFixed(0)} $currency',
              icon: IconlyBold.chart,
              iconColor: const Color(0xFFEA580C), // Primary orange
              iconBgColor: const Color(0xFFFFF7ED),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // الصف الثاني: إجمالي السلف + أيام العمل
        Row(
          children: [
            ProjectFinancialCard(
              label: context.l10n.totalAdvances,
              value: '${stats.totalAdvances.toStringAsFixed(0)} $currency',
              icon: IconlyBold.swap,
              iconColor: const Color(0xFFD97706), // Amber
              iconBgColor: const Color(0xFFFEF3C7),
            ),
            const SizedBox(width: 12),
            ProjectFinancialCard(
              label: context.l10n.workDays,
              value: '${stats.totalDays} ${context.l10n.day}',
              icon: IconlyBold.calendar,
              iconColor: const Color(0xFF3B82F6), // Blue
              iconBgColor: const Color(0xFFEFF6FF),
            ),
          ],
        ),
      ],
    );
  }
}
