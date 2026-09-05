import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:provider/provider.dart';
import 'package:work_time/data/models/project.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'package:work_time/view_models/project_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/projects/components/add_project_sheet.dart';
import 'package:work_time/views/projects/components/budget_progress_bar.dart';
import 'package:work_time/views/projects/components/project_empty_workers_hint.dart';
import 'package:work_time/views/projects/components/project_summary_grid.dart';
import 'package:work_time/views/projects/components/project_worker_tile.dart';

/// صفحة تفاصيل المشروع وموقع العمل — بتصميم أبيض ناصع، احترافي ومخصص لتطبيق "عمالي"
class ProjectDetailView extends StatefulWidget {
  final Project project;
  final ProjectViewModel viewModel;

  const ProjectDetailView({
    super.key,
    required this.project,
    required this.viewModel,
  });

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  late Project currentProject;

  @override
  void initState() {
    super.initState();
    currentProject = widget.project;
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddProjectSheet(
        viewModel: widget.viewModel,
        existingProject: currentProject,
      ),
    ).then((_) {
      final updatedIndex = widget.viewModel.projects
          .indexWhere((p) => p.id == currentProject.id);
      if (updatedIndex != -1 && mounted) {
        setState(() {
          currentProject = widget.viewModel.projects[updatedIndex];
        });
      }
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'حذف المشروع',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف مشروع "${currentProject.name}"؟',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Color(0xFF475569),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Cairo', color: Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.viewModel.deleteProject(currentProject.id!);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Light brand background
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    // اليمين (في RTL): زر الرجوع
                    IconButton(
                      icon: const Icon(
                        IconlyLight.arrowRight2,
                        color: Color(0xFF0F172A),
                        size: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    // الوسط: اسم المشروع / الشاشة الحالية
                    Expanded(
                      child: Text(
                        currentProject.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    // اليسار (في RTL): قائمة الخيارات الثلاث نقاط
                    PopupMenuButton<String>(
                      icon: const Icon(
                        IconlyLight.moreCircle,
                        color: Color(0xFF0F172A),
                        size: 22,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _showEditSheet(context);
                        } else if (value == 'toggle') {
                          final updated = currentProject.copyWith(
                            status: currentProject.status == 'active'
                                ? 'completed'
                                : 'active',
                          );
                          await widget.viewModel.updateProject(updated);
                          if (mounted) {
                            setState(() {
                              currentProject = updated;
                            });
                          }
                        } else if (value == 'delete') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(IconlyLight.edit, size: 18, color: Color(0xFF0F172A)),
                              SizedBox(width: 10),
                              Text(
                                'تعديل المشروع',
                                style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                currentProject.status == 'active'
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.replay_rounded,
                                size: 18,
                                color: const Color(0xFF0F172A),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                currentProject.status == 'active'
                                    ? 'تحديد كمكتمل'
                                    : 'إعادة كنشط',
                                style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(IconlyLight.delete, size: 18, color: Color(0xFFEF4444)),
                              SizedBox(width: 10),
                              Text(
                                'حذف المشروع',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: FutureBuilder<ProjectStats>(
          future: widget.viewModel.getStats(currentProject.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEA580C)),
              );
            }

            final stats = snapshot.data ??
                ProjectStats(
                  projectName: currentProject.name,
                  totalWages: 0,
                  totalAdvances: 0,
                  totalDays: 0,
                  workerIds: {},
                );

            // استخراج كائنات العمال المشاركين في هذا المشروع
            final userViewModel = Provider.of<UserViewModel>(context);
            final projectWorkers = userViewModel.allUsers
                .where((u) => u.id != null && stats.workerIds.contains(u.id!))
                .toList();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. حالة المشروع ──────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentProject.status == 'active'
                              ? const Color(0xFF10B981) // Success green
                              : const Color(0xFF94A3B8), // Muted grey
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentProject.status == 'active'
                            ? 'مشروع نشط'
                            : 'مشروع مكتمل',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── 2. قسم الملخص المالي (2x2 Grid) ─────────────────────
                  const Text(
                    'الملخص المالي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProjectSummaryGrid(stats: stats),

                  // ── 3. متابعة الميزانية (إن وُجدت) ───────────────────────
                  if (currentProject.budgetAmount != null &&
                      currentProject.budgetAmount! > 0) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x050F172A),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'متابعة الميزانية',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'الميزانية: ${currentProject.budgetAmount!.toStringAsFixed(0)} ج',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Cairo',
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          BudgetProgressBar(
                            spent: stats.totalSpent,
                            budget: currentProject.budgetAmount!,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── 4. قسم العمال ──────────────────────────────────────
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Text(
                        'العمال',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${projectWorkers.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // قائمة بطاقات العمال أو الحالة التوجيهية الفارغة
                  if (projectWorkers.isEmpty)
                    const ProjectEmptyWorkersHint(isZeroWorkers: true)
                  else ...[
                    ...projectWorkers.map((worker) => ProjectWorkerTile(
                          worker: worker,
                          projectName: currentProject.name,
                        )),
                    if (projectWorkers.length == 1) ...[
                      const SizedBox(height: 4),
                      const ProjectEmptyWorkersHint(isZeroWorkers: false),
                    ],
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
