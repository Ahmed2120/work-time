import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/view_models/project_view_model.dart';
import 'package:work_time/views/projects/components/add_project_sheet.dart';
import 'package:work_time/views/projects/components/project_card.dart';
import 'package:work_time/views/projects/project_detail_view.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProjectViewModel>().loadProjects();
      }
    });
  }

  void _showAddSheet(BuildContext context, ProjectViewModel vm, {project}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddProjectSheet(
        viewModel: vm,
        existingProject: project,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = Provider.of<ProjectViewModel>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.l10n.projectsAndSites,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 24),
            color: AppColors.primaryAmber,
            tooltip: context.l10n.refreshData,
            onPressed: () => vm.loadProjects(),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
            color: AppColors.primaryAmber,
            tooltip: context.l10n.addProject,
            onPressed: () => _showAddSheet(context, vm),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryAmber,
        onRefresh: () => vm.loadProjects(),
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryAmber))
            : vm.projects.isEmpty
                ? _EmptyState(onAdd: () => _showAddSheet(context, vm))
                : _ProjectsList(vm: vm, isDark: isDark, onAdd: () => _showAddSheet(context, vm)),
      ),
      floatingActionButton: vm.projects.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSheet(context, vm),
              backgroundColor: AppColors.primaryAmber,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                context.l10n.addProject,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : null,
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction_rounded,
                  size: 72,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.noProjects,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.noProjects,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text(
                    context.l10n.addProject,
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Projects List ────────────────────────────────────────────────────────────

class _ProjectsList extends StatelessWidget {
  final ProjectViewModel vm;
  final bool isDark;
  final VoidCallback onAdd;

  const _ProjectsList({
    required this.vm,
    required this.isDark,
    required this.onAdd,
  });

  void _openDetail(BuildContext context, project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailView(project: project, viewModel: vm),
      ),
    ).then((_) {
      vm.loadProjects();
    });
  }

  void _confirmDelete(BuildContext context, project) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المشروع', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: Text(
          'سيتم حذف مشروع "${project.name}" نهائياً. لن تُحذف سجلات الحضور المرتبطة به.',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () {
              vm.deleteProject(project.id!);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(fontFamily: 'Cairo', color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Active Projects
        if (vm.activeProjects.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'المشاريع النشطة (${vm.activeProjects.length})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final project = vm.activeProjects[index];
                return ProjectCard(
                  project: project,
                  viewModel: vm,
                  onTap: () => _openDetail(context, project),
                  onEdit: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddProjectSheet(viewModel: vm, existingProject: project),
                  ),
                  onDelete: () => _confirmDelete(context, project),
                );
              },
              childCount: vm.activeProjects.length,
            ),
          ),
        ],

        // Completed Projects
        if (vm.completedProjects.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'المشاريع المكتملة (${vm.completedProjects.length})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final project = vm.completedProjects[index];
                return ProjectCard(
                  project: project,
                  viewModel: vm,
                  onTap: () => _openDetail(context, project),
                  onEdit: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddProjectSheet(viewModel: vm, existingProject: project),
                  ),
                  onDelete: () => _confirmDelete(context, project),
                );
              },
              childCount: vm.completedProjects.length,
            ),
          ),
        ],

        // Bottom spacing for FAB
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}
