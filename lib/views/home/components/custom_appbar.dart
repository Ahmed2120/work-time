import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../core/utils/global_methods.dart';
import '../../../view_models/attendance_view_model.dart';
import '../../../view_models/user_view_model.dart';

AppBar customAppBar(BuildContext context) {
  final userViewModel = Provider.of<UserViewModel>(context);
  final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

  return !userViewModel.clickSearch
      ? AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: borderColor),
          ),
          actions: [
            IconButton(
              onPressed: () => userViewModel.changeClickSearch(),
              icon: const Icon(Icons.search_rounded, size: 22),
              tooltip: 'بحث',
            ),
            const SizedBox(width: 4),
          ],
          title: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: attendanceViewModel.dateTimeAttendance,
                firstDate: DateTime.parse('1900-01-01'),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(
                          primary: AppColors.primary,
                        ),
                  ),
                  child: child!,
                ),
              );
              attendanceViewModel.changeDate(date);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                ),
                const SizedBox(width: 6),
                Text(
                  '${GlobalMethods.getDayName(attendanceViewModel.dateTimeAttendance)}، '
                  '${GlobalMethods.getDateFormat(attendanceViewModel.dateTimeAttendance)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ],
            ),
          ),
        )
      : AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: borderColor),
          ),
          title: TextField(
            autofocus: true,
            onChanged: (txt) {
              if (txt.isEmpty) {
                userViewModel.filteringUser(userViewModel.dropDownValue);
                return;
              }
              userViewModel.searchUsers(txt);
            },
            decoration: InputDecoration(
              hintText: 'بحث عن عامل...',
              hintStyle: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  userViewModel.changeClickSearch();
                  userViewModel.filteringUser(userViewModel.dropDownValue);
                },
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
            cursorColor: AppColors.primary,
            textInputAction: TextInputAction.search,
          ),
        );
}
