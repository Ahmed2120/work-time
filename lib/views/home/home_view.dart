import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/core/utils/global_methods.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';

import 'components/custom_add_button.dart';
import 'components/custom_appbar.dart';
import 'components/drawer/main_drawer.dart';
import 'components/dropDownMenuRow.dart';
import 'components/users_status_listview.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final keyScaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userViewModel = Provider.of<UserViewModel>(context);
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

    final totalUsers = userViewModel.users.length;
    final activeStatusFilter = userViewModel.statusFilter;

    return Scaffold(
      key: keyScaffold,
      appBar: customAppBar(context),
      drawer: const MainDrawer(),
      body: SafeArea(
        child: userViewModel.clickSearch
            ? const UsersStatusListview()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ─── Header: Date & Greeting ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${GlobalMethods.getDayName(attendanceViewModel.dateTimeAttendance)}، '
                            '${GlobalMethods.getDateFormat(attendanceViewModel.dateTimeAttendance)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'صباح الخير 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─── Attendance Summary Grid (Interactive Filter Cards) ────────
                    Consumer<AttendanceViewModel>(
                      builder: (context, attendProvider, _) {
                        return FutureBuilder<List<int>>(
                          future: _calculateAttendanceSummary(userViewModel, attendProvider),
                          builder: (context, snapshot) {
                            final presentCount = snapshot.data?[0] ?? 0;
                            final absentCount = snapshot.data?[1] ?? 0;
                            final pendingCount = snapshot.data?[2] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  // Card 1: الكل / إجمالي الموظفين
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context: context,
                                      title: 'الإجمالي',
                                      value: '$totalUsers',
                                      icon: Icons.people_alt_rounded,
                                      iconColor: AppColors.primary,
                                      bgColor: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.primaryLight,
                                      isSelected: activeStatusFilter == 'الكل',
                                      onTap: () => userViewModel.setStatusFilter('الكل'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Card 2: الحاضرون
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context: context,
                                      title: 'الحاضرون',
                                      value: '$presentCount',
                                      icon: Icons.check_circle_rounded,
                                      iconColor: AppColors.successText,
                                      bgColor: isDark
                                          ? AppColors.successBgDark
                                          : AppColors.successBgLight,
                                      isSelected: activeStatusFilter == 'حاضر',
                                      onTap: () => userViewModel.setStatusFilter('حاضر'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Card 3: الغائبون
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context: context,
                                      title: 'الغائبون',
                                      value: '$absentCount',
                                      icon: Icons.cancel_rounded,
                                      iconColor: AppColors.dangerText,
                                      bgColor: isDark
                                          ? AppColors.dangerBgDark
                                          : AppColors.dangerBgLight,
                                      isSelected: activeStatusFilter == 'غائب',
                                      onTap: () => userViewModel.setStatusFilter('غائب'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Card 4: غير المسجلين
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context: context,
                                      title: 'غير المسجلين',
                                      value: '$pendingCount',
                                      icon: Icons.help_outline_rounded,
                                      iconColor: AppColors.warningText,
                                      bgColor: isDark
                                          ? AppColors.warningBgDark
                                          : AppColors.warningBgLight,
                                      isSelected: activeStatusFilter == 'لم يسجل',
                                      onTap: () => userViewModel.setStatusFilter('لم يسجل'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ─── Filter & Add Button Bar ────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            activeStatusFilter == 'الكل'
                                ? 'الموظفون'
                                : 'الموظفون ($activeStatusFilter)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const Spacer(),
                          const DropDownMenuRow(),
                          const SizedBox(width: 8),
                          CustomAddButton(keyScaffold),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── Employee List ─────────────────────────────────────────────
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: const UsersStatusListview(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<List<int>> _calculateAttendanceSummary(
    UserViewModel userViewModel,
    AttendanceViewModel attendanceViewModel,
  ) async {
    int present = 0;
    int absent = 0;
    int pending = 0;

    for (var user in userViewModel.users) {
      final Attendance? attend =
          await attendanceViewModel.getAttendByUserAndDate(userId: user.id!);
      if (attend == null) {
        pending++;
      } else if (attend.status == 1) {
        present++;
      } else {
        absent++;
      }
    }
    return [present, absent, pending];
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? iconColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
