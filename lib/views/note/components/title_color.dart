import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/note_view_model.dart';

class SwitchColor extends StatelessWidget {
  const SwitchColor({super.key});

  static const List<Color> _colorOptions = [
    AppColors.primary,      // Index 0: Indigo
    AppColors.success,      // Index 1: Green
    AppColors.warning,      // Index 2: Amber
    AppColors.danger,       // Index 3: Rose
    Color(0xFF64748B),      // Index 4: Slate
  ];

  static const List<Color> _bgOptions = [
    AppColors.primaryLight,  // Index 0: Indigo light
    AppColors.successBgLight,// Index 1: Green light
    AppColors.warningBgLight,// Index 2: Amber light
    AppColors.dangerBgLight, // Index 3: Rose light
    Color(0xFFF1F5F9),       // Index 4: Slate light
  ];

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = (noteViewModel.colorVal >= 0 && noteViewModel.colorVal < _colorOptions.length)
        ? noteViewModel.colorVal
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'لون الملاحظة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_colorOptions.length, (index) {
            final isSelected = selectedIndex == index;
            final color = _colorOptions[index];
            final bg = _bgOptions[index];

            return Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: GestureDetector(
                onTap: () {
                  noteViewModel.setColorVal(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? color.withValues(alpha: 0.2) : bg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
