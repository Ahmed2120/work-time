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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _jobController = TextEditingController(text: widget.user?.job ?? '');
    _salaryController = TextEditingController(text: widget.user?.salary ?? '');
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
}
