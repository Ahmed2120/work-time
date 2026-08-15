import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/user_view_model.dart';

class DropDownMenuRow extends StatelessWidget {
  const DropDownMenuRow({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userViewModel = Provider.of<UserViewModel>(context, listen: true);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt_rounded,
            color: AppColors.accent,
            size: 18,
          ),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              value: userViewModel.dropDownValue,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accent,
                size: 20,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              alignment: Alignment.topRight,
              items: userViewModel.filteredUsers
                  .map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val == null) return;
                // userViewModel.getUsers().then((value) {
                  userViewModel.dropDownChane(val);
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}
