import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/work_place.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/work_place_view_model.dart';

class ManageWorkPlacesView extends StatefulWidget {
  const ManageWorkPlacesView({super.key});

  @override
  State<ManageWorkPlacesView> createState() => _ManageWorkPlacesViewState();
}

class _ManageWorkPlacesViewState extends State<ManageWorkPlacesView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _addWorkPlace(WorkPlaceViewModel vm) async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final added = await vm.addWorkPlace(name);
    if (!mounted) return;
    if (added) {
      _controller.clear();
      _focusNode.unfocus();
      context.read<AttendanceViewModel>().getWorkPlaces();
      _showSnack('تم إضافة مكان العمل بنجاح ✅', AppColors.success);
    } else {
      _showSnack('مكان العمل موجود بالفعل', AppColors.warning);
    }
  }

  Future<void> _editWorkPlace(WorkPlaceViewModel vm, WorkPlace wp) async {
    final editController = TextEditingController(text: wp.name);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تعديل اسم مكان العمل',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: editController,
            textDirection: TextDirection.rtl,
            autofocus: true,
            style: const TextStyle(fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: 'اسم مكان العمل الجديد',
              prefixIcon: const Icon(Icons.edit_location_outlined, color: AppColors.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'يرجى كتابة الاسم';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop(editController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('حفظ التعديل', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != wp.name) {
      final updated = await vm.updateWorkPlace(wp, result);
      if (!mounted) return;
      if (updated) {
        context.read<AttendanceViewModel>().getWorkPlaces();
        _showSnack('تم تعديل مكان العمل بنجاح ✏️', AppColors.success);
      } else {
        _showSnack('اسم مكان العمل مستخدم بالفعل', AppColors.warning);
      }
    }
  }

  Future<void> _confirmDelete(WorkPlaceViewModel vm, WorkPlace wp) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف مكان العمل', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: Text(
          'هل تريد حذف "${wp.name}"؟\nسيتم حذفه من قائمة الاقتراحات ولن يظهر مجدداً.',
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await vm.deleteWorkPlace(wp);
      if (!mounted) return;
      context.read<AttendanceViewModel>().getWorkPlaces();
      _showSnack('تم حذف مكان العمل بنجاح', AppColors.danger);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'إدارة أماكن العمل',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      body: Consumer<WorkPlaceViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              // ─── Add Workplace Input ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'أضف مكان عمل (مثال: الورشة، الموقع الرئيسي)',
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        onSubmitted: (_) => _addWorkPlace(vm),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _AddButton(onTap: () => _addWorkPlace(vm)),
                  ],
                ),
              ),

              // ─── Header Info ────────────────────────────────────────────
              if (vm.workPlaces.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'أماكن العمل المسجلة (${vm.workPlaces.length})',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

              // ─── List or Empty State ────────────────────────────────────
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : vm.workPlaces.isEmpty
                        ? _EmptyState(isDark: isDark)
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            physics: const BouncingScrollPhysics(),
                            itemCount: vm.workPlaces.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final wp = vm.workPlaces[index];
                              return _WorkPlaceTile(
                                workPlace: wp,
                                isDark: isDark,
                                onEdit: () => _editWorkPlace(vm, wp),
                                onDelete: () => _confirmDelete(vm, wp),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Add Button ─────────────────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

// ─── WorkPlace Tile (Edit & Delete actions) ──────────────────────────────────
class _WorkPlaceTile extends StatelessWidget {
  const _WorkPlaceTile({
    required this.workPlace,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  final WorkPlace workPlace;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryLight.withValues(alpha: 0.15) : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              workPlace.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
            tooltip: 'تعديل',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
            tooltip: 'حذف',
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.primaryLight.withValues(alpha: 0.15) : AppColors.primaryLight,
            ),
            child: const Icon(Icons.location_off_outlined, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أماكن عمل مضافة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'أضف أماكن العمل هنا لتظهر في الاقتراحات وإمكانية تعديلها أو حذفها بسهولة',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Cairo',
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
