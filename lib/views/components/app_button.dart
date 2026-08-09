import 'package:flutter/material.dart';
import 'package:work_time/core/theme/app_colors.dart';

enum AppButtonStyle { primary, secondary, danger }

/// Reusable enterprise button supporting primary / secondary / danger variants.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final AppButtonStyle style;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = AppButtonStyle.primary,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg;
    final Color fg;
    final BorderSide side;

    switch (style) {
      case AppButtonStyle.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        side = BorderSide.none;
        break;
      case AppButtonStyle.secondary:
        bg = isDark ? AppColors.darkSurface : Colors.white;
        fg = AppColors.primary;
        side = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.primary,
          width: 1.5,
        );
        break;
      case AppButtonStyle.danger:
        bg = AppColors.dangerBgLight;
        fg = AppColors.dangerText;
        side = const BorderSide(color: AppColors.dangerBgLight);
        break;
    }

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: side,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
