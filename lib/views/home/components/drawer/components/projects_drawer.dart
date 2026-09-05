import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/projects/projects_view.dart';

import '../../../../../core/utils/extensions/context_extension.dart';

class ProjectsDrawer extends StatelessWidget {
  const ProjectsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => push(screen: const ProjectsView(), context: context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightAmber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.construction_rounded,
                    size: 20,
                    color: AppColors.primaryAmber,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'المشاريع والمواقع',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Transform.flip(
                  flipX: context.isArabic,
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
