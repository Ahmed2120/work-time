import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/user.dart';

import 'components/form_sheet.dart';
import 'components/header_sheet.dart';

class AddingUserBottomSheet extends StatelessWidget {
  const AddingUserBottomSheet({this.user, super.key});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // ─── Drag Handle ───────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ─── Header ───────────────────────────────────────────────────
              HeaderSheet(title: user != null ? 'تعديل البيانات' : 'إضافة عامل'),

              const SizedBox(height: 16),

              // ─── Form Inputs & Primary Button ─────────────────────────────
              FormSheet(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
