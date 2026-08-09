import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.prefixIcon,
    this.hint,
    this.isPassword = false,
    this.border = 12,
    this.focusBorder = 12,
    required TextEditingController controller,
    this.label,
    this.isNumeric = false,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String? label;
  final bool isNumeric;
  final bool isPassword;
  final TextInputType keyboardType;
  final double border;
  final double focusBorder;
  final Widget? icon;
  final Widget? prefixIcon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return TextFormField(
      style: TextStyle(color: textColor, fontSize: 16, fontFamily: 'Cairo'),
      controller: _controller,
      textDirection: TextDirection.rtl,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.text
          ? null
          : [
              FilteringTextInputFormatter.allow(
                RegExp('[0-9]'),
              ),
            ],
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: icon,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        filled: true,
        fillColor: fillColor,
        labelText: label,
        hintStyle: TextStyle(fontSize: 14, color: labelColor, fontFamily: 'Cairo'),
        labelStyle: TextStyle(fontSize: 14, color: labelColor, fontFamily: 'Cairo'),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          borderRadius: BorderRadius.circular(focusBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.danger),
          borderRadius: BorderRadius.circular(border),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
          borderRadius: BorderRadius.circular(focusBorder),
        ),
      ),
      validator: (val) {
        if (_controller.text.isEmpty) {
          return 'من فضلك اكتب $label';
        }
        return null;
      },
    );
  }
}
