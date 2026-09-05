import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/project.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'package:work_time/view_models/project_view_model.dart';
import 'package:work_time/views/projects/components/budget_progress_bar.dart';

/// بطاقة عرض المشروع في القائمة الرئيسية
class ProjectCard extends StatelessWidget {
  final Project project;
  final ProjectViewModel viewModel;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.viewModel,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = project.status == 'active';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Row ─────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBackground : AppColors.lightAmber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.construction_rounded,
                        color: AppColors.primaryAmber,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _StatusBadge(isActive: isActive),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') onEdit();
                        if (value == 'delete') onDelete();
                        if (value == 'toggle') {
                          final updated = project.copyWith(
                            status: isActive ? 'completed' : 'active',
                          );
                          viewModel.updateProject(updated);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Text('تعديل', style: TextStyle(fontFamily: 'Cairo'))),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            isActive ? 'إنهاء المشروع' : 'إعادة تفعيل',
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('حذف', style: TextStyle(fontFamily: 'Cairo', color: AppColors.danger)),
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Stats Row ───────────────────────────────────────
                const SizedBox(height: 14),
                FutureBuilder<ProjectStats>(
                  future: viewModel.getStats(project.name),
                  builder: (context, snapshot) {
                    final stats = snapshot.data;
                    return Column(
                      children: [
                        Row(
                          children: [
                            _StatItem(
                              label: 'اليوميات',
                              value: stats != null
                                  ? '${stats.totalWages.toStringAsFixed(0)} ج'
                                  : '...',
                              icon: Icons.payments_outlined,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 8),
                            _StatItem(
                              label: 'السلف',
                              value: stats != null
                                  ? '${stats.totalAdvances.toStringAsFixed(0)} ج'
                                  : '...',
                              icon: Icons.account_balance_wallet_outlined,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            _StatItem(
                              label: 'أيام العمل',
                              value: stats != null ? '${stats.totalDays}' : '...',
                              icon: Icons.calendar_today_outlined,
                              color: AppColors.primaryAmber,
                            ),
                          ],
                        ),
                        // ── Budget Progress ────────────────────────────
                        if (project.budgetAmount != null && project.budgetAmount! > 0 && stats != null) ...[
                          const SizedBox(height: 12),
                          BudgetProgressBar(
                            spent: stats.totalSpent,
                            budget: project.budgetAmount!,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub Widgets ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successBgLight : AppColors.lightBorder,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'نشط' : 'مكتمل',
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.successText : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Cairo',
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
