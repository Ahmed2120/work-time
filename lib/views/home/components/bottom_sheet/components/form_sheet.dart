import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/app_button.dart';

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
              'الاسم',
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
              label: 'أدخل اسم العامل',
              hint: 'أدخل اسم العامل...',
            ),

            const SizedBox(height: 16),

            // ─── Field 2: الوظيفة ────────────────────────────────────────────
            Text(
              'الوظيفة',
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
              label: 'أدخل الوظيفة',
              hint: 'أدخل الوظيفة (مثال: مهندس، فني...)...',
            ),

            const SizedBox(height: 16),

            // ─── Field 3: الفئة ──────────────────────────────────────────────
            Text(
              'الفئة / الراتب اليومي',
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
              label: 'أدخل الفئة',
              hint: 'أدخل المبلغ أو الراتب اليومي...',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // ─── Primary Button ──────────────────────────────────────────────
            AppButton(
              label: widget.user == null ? '+ إضافة عامل' : 'حفظ التعديلات',
              icon: widget.user == null ? Icons.person_add_alt_1_rounded : Icons.edit_rounded,
              onPressed: () {
                final provider = Provider.of<UserViewModel>(context, listen: false);
                if ((provider.users.length + provider.usersTrash.length) >= AppConfig.maxTrialWorkers && trial) {
                  showFlushBar(context);
                  return;
                }
                if (!_formKey.currentState!.validate()) return;

                if (widget.user == null) {
                  final userModel = User(
                    name: _nameController.text,
                    job: _jobController.text,
                    salary: _salaryController.text,
                  );
                  provider.addUser(userModel);
                  showToast(context, 'تم إضافة العامل بنجاح');
                  pop(context);
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
                  showToast(context, 'تم تعديل البيانات بنجاح');
                  pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
