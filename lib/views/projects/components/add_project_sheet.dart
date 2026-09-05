import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/project.dart';
import 'package:work_time/view_models/project_view_model.dart';

/// Bottom sheet لإضافة أو تعديل مشروع
class AddProjectSheet extends StatefulWidget {
  final ProjectViewModel viewModel;
  final Project? existingProject; // null = إضافة جديدة، غير null = تعديل

  const AddProjectSheet({
    super.key,
    required this.viewModel,
    this.existingProject,
  });

  @override
  State<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends State<AddProjectSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  bool _isSaving = false;

  bool get isEditMode => widget.existingProject != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingProject?.name ?? '',
    );
    _budgetController = TextEditingController(
      text: widget.existingProject?.budgetAmount != null
          ? widget.existingProject!.budgetAmount!.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final double? budget = _budgetController.text.trim().isEmpty
        ? null
        : double.tryParse(_budgetController.text.trim());

    if (isEditMode) {
      final updated = widget.existingProject!.copyWith(
        name: _nameController.text.trim(),
        budgetAmount: budget,
      );
      await widget.viewModel.updateProject(updated);
    } else {
      final project = Project(
        name: _nameController.text.trim(),
        budgetAmount: budget,
        createdAt: DateTime.now().toIso8601String(),
      );
      await widget.viewModel.addProject(project);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isEditMode ? 'تعديل المشروع' : 'إضافة مشروع / موقع جديد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              TextFormField(
                controller: _nameController,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: _inputDecoration(
                  isDark: isDark,
                  label: 'اسم المشروع / الموقع *',
                  hint: 'مثال: فيلا التجمع، شقة المعادي...',
                  icon: Icons.location_on_outlined,
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'الرجاء إدخال اسم المشروع'
                    : null,
              ),
              const SizedBox(height: 14),

              // Budget field (optional)
              TextFormField(
                controller: _budgetController,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: _inputDecoration(
                  isDark: isDark,
                  label: 'الميزانية التقديرية للأجور (اختياري)',
                  hint: 'مثال: 50000',
                  icon: Icons.account_balance_wallet_outlined,
                  suffix: 'ج',
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          isEditMode ? 'حفظ التعديلات' : 'إضافة المشروع',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool isDark,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
      prefixIcon: Icon(icon, color: AppColors.primaryAmber, size: 20),
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryAmber, width: 1.5),
      ),
    );
  }
}
