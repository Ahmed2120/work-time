import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'project_financial_card.dart';

/// شبكة 2x2 للبطاقات المالية والإحصائية للمشروع
class ProjectSummaryGrid extends StatelessWidget {
  final ProjectStats stats;

  const ProjectSummaryGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الصف الأول: إجمالي المدفوعات + إجمالي الإنفاق
        Row(
          children: [
            ProjectFinancialCard(
              label: 'إجمالي المدفوعات',
              value: '${stats.totalWages.toStringAsFixed(0)} ج',
              icon: IconlyBold.wallet,
              iconColor: const Color(0xFF10B981), // Success green
              iconBgColor: const Color(0xFFECFDF5),
            ),
            const SizedBox(width: 12),
            ProjectFinancialCard(
              label: 'إجمالي الإنفاق',
              value: '${stats.totalSpent.toStringAsFixed(0)} ج',
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
              label: 'إجمالي السلف',
              value: '${stats.totalAdvances.toStringAsFixed(0)} ج',
              icon: IconlyBold.swap,
              iconColor: const Color(0xFFD97706), // Amber
              iconBgColor: const Color(0xFFFEF3C7),
            ),
            const SizedBox(width: 12),
            ProjectFinancialCard(
              label: 'أيام العمل',
              value: '${stats.totalDays} يوم',
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
