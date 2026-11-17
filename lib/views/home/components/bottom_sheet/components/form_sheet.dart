import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/extensions/context_extension.dart';
import 'package:work_time/views/components/app_button.dart';

import 'package:work_time/core/utils/secure_storage_helper.dart';
import '../../../../../core/utils/cache_helper.dart';
import '../../../../../data/models/user.dart';
import '../../../../../view_models/user_view_model.dart';
import '../../../../components/constant.dart';
import '../../../../components/custom_textField.dart';
import '../../../../components/functions.dart';

class FormSheet extends StatefulWidget {
  final User? user;
  const FormSheet({this.user, super.key});

  @override
  State<FormSheet> createState() => _FormSheetState();
}

class _FormSheetState extends State<FormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _jobController;
  late final TextEditingController _salaryController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _selectedRatio = 1.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _jobController = TextEditingController(text: widget.user?.job ?? '');
    _salaryController = TextEditingController(text: widget.user?.salary ?? '');
    _selectedRatio = widget.user?.defaultDayRatio ?? 1.0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Field 1: الاسم ──────────────────────────────────────────────
            Text(
              context.l10n.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: _nameController,
              label: context.l10n.enterWorkerName,
              hint: context.l10n.enterWorkerName,
            ),

            const SizedBox(height: 16),

            // ─── Field 2: الوظيفة ────────────────────────────────────────────
            Text(
              context.l10n.job,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: _jobController,
              label: context.l10n.enterJob,
              hint: context.l10n.enterJob,
            ),

            const SizedBox(height: 16),

            // ─── Field 3: الفئة ──────────────────────────────────────────────
            Text(
              context.l10n.dailyWageCategory,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: _salaryController,
              label: context.l10n.enterCategory,
              hint: context.l10n.enterCategory,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // ─── Field 4: نوع الدوام الافتراضي ───────────────────────────────
            Text(
              context.l10n.defaultWorkShift,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  _buildShiftOption(
                    label: context.l10n.fullDayShort,
                    ratio: 1.0,
                    color: AppColors.success,
                    isSelected: _selectedRatio == 1.0,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildShiftOption(
                    label: context.l10n.halfDayShort,
                    ratio: 0.5,
                    color: AppColors.primaryAmber,
                    isSelected: _selectedRatio == 0.5,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildShiftOption(
                    label: context.l10n.quarterDayShort,
                    ratio: 0.25,
                    color: Colors.blueAccent,
                    isSelected: _selectedRatio == 0.25,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.defaultWorkShiftHint,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 24),

            // ─── Primary Button ──────────────────────────────────────────────
            AppButton(
              label: widget.user == null ? context.l10n.addWorker : context.l10n.saveChanges,
              icon: widget.user == null ? Icons.person_add_alt_1_rounded : Icons.edit_rounded,
              onPressed: () async {
                final provider = Provider.of<UserViewModel>(context, listen: false);
                if (widget.user == null) {
                  final bool isExpired = AppConfig.isPlayStore
                      ? await SecureStorageHelper.isTrialExpired()
                      : ((provider.users.length + provider.usersTrash.length) >= AppConfig.maxTrialWorkers && trial);

                  if (isExpired) {
                    if (context.mounted) showFlushBar(context);
                    return;
                  }
                }
                if (!_formKey.currentState!.validate()) return;

                if (widget.user == null) {
                  final userModel = User(
                    name: _nameController.text,
                    job: _jobController.text,
                    salary: _salaryController.text,
                    defaultDayRatio: _selectedRatio,
                  );
                  provider.addUser(userModel);
                  if (context.mounted) {
                    showToast(context, context.l10n.workerAddedSuccess);
                    pop(context);
                  }
                } else {
                  final userModel = User(
                    id: widget.user!.id,
                    name: _nameController.text,
                    job: _jobController.text,
                    salary: _salaryController.text,
                    isDeleted: widget.user!.isDeleted,
                    defaultDayRatio: _selectedRatio,
                  );
                  provider.updateUser(userModel);
                  provider.setUser(userModel);
                  if (context.mounted) {
                    showToast(context, context.l10n.workerUpdatedSuccess);
                    pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftOption({
    required String label,
    required double ratio,
    required Color color,
    required bool isSelected,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _selectedRatio = ratio),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.25 : 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? color
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }
}
