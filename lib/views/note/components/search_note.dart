import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/note_view_model.dart';

class SearchNote extends StatelessWidget {
  const SearchNote({
    super.key,
    required TextEditingController controller,
  }) : _searchController = controller;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SizedBox(
      height: 52,
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          fontFamily: 'Cairo',
        ),
        onChanged: (txt) {
          if (txt.isEmpty) {
            Provider.of<NoteViewModel>(context, listen: false).getNotes();
          } else {
            Provider.of<NoteViewModel>(context, listen: false).searchNote(txt);
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          hintText: 'بحث في الملاحظات...',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
            fontFamily: 'Cairo',
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
