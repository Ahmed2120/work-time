import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/user_view_model.dart';

class JobFilterDropdown extends StatelessWidget {
  const JobFilterDropdown({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userViewModel = Provider.of<UserViewModel>(context);

    // Only show if there are actual jobs registered besides 'الكل'
    if (userViewModel.jobs.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: userViewModel.selectedJob != 'الكل'
              ? AppColors.primaryAmber
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: userViewModel.selectedJob != 'الكل' ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.work_outline_rounded,
            color: userViewModel.selectedJob != 'الكل'
                ? AppColors.primaryAmber
                : AppColors.textSecondaryLight,
            size: 16,
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              value: userViewModel.selectedJob,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryAmber,
                size: 18,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              alignment: Alignment.topRight,
              items: userViewModel.jobs.map((String item) {
                final isSelected = item == userViewModel.selectedJob;
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item == 'الكل' ? 'كل المهن' : item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryAmber
                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val == null) return;
                userViewModel.setJobFilter(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
