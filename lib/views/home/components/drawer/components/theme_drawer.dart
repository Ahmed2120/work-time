import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/theme_view_model.dart';

class ThemeDrawer extends StatelessWidget {
  const ThemeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final isDark = themeViewModel.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5),
      child: SwitchListTile(
        value: isDark,
        onChanged: (value) => themeViewModel.toggleTheme(value),
        secondary: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            key: ValueKey(isDark),
            size: 24,
            color: AppColors.accent,
          ),
        ),
        title: Text(
          isDark ? 'الوضع الداكن' : 'الوضع الفاتح',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
        activeThumbColor: AppColors.accent,
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }
}
