import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/attendance.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/EmptyScreen/empty_screen.dart';
import 'package:work_time/views/components/app_card.dart';
import 'package:work_time/views/components/constant.dart';

import '../../../data/models/user.dart';
import '../../users/user_detail.dart';
import 'custom_status.dart';

class UsersStatusListview extends StatelessWidget {
  const UsersStatusListview({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendProvider = Provider.of<AttendanceViewModel>(context);

    return Consumer<UserViewModel>(
      builder: (ctx, userViewModel, _) {
        final List<User> allUsers = userViewModel.users;
        final String statusFilter = userViewModel.statusFilter;

        if (allUsers.isEmpty) {
          return const SingleChildScrollView(
            child: EmptyScreen(title: 'من فضلك أضف عمال لمتابعة التمام'),
          );
        }

        return FutureBuilder<List<User>>(
          future: _getFilteredUsers(allUsers, attendProvider, statusFilter),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final filteredList = snapshot.data ?? allUsers;

            if (filteredList.isEmpty) {
              return SingleChildScrollView(
                child: EmptyScreen(
                  title: 'لا يوجد عمال بحالة "$statusFilter" حالياً',
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredList.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                final user = filteredList[index];
                final String firstLetter =
                    user.name.isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';

                return AppCard(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  onTap: () async {
                    userViewModel.setUser(user);
                    attendProvider.getWeeks(user.id!);
                    attendProvider.getAttendanceUserToDay(userId: user.id!);
                    attendProvider.getAttendanceUser(user.id!);
                    push(screen: UserDetail(), context: context);
                  },
                  child: Row(
                    children: [
                      // Circular Avatar Initial (#EEF2FF bg, #3730A3 text)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.primaryLight,
                        ),
                        child: Center(
                          child: Text(
                            firstLetter,
                            style: TextStyle(
                              color: isDark ? AppColors.indigoAccent : AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Employee Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (user.job.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                user.job,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontFamily: 'Cairo',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Status Badge
                      FutureBuilder<Attendance?>(
                        future: attendProvider.getAttendByUserAndDate(userId: user.id!),
                        builder: (context, statusSnapshot) {
                          final title = statusSnapshot.data == null
                              ? 'لم يسجل'
                              : statusSnapshot.data!.status == 1
                                  ? 'حاضر'
                                  : 'غائب';
                          return CustomStatusText(title);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<User>> _getFilteredUsers(
    List<User> users,
    AttendanceViewModel attendProvider,
    String statusFilter,
  ) async {
    if (statusFilter == 'الكل') return users;

    List<User> result = [];
    for (var user in users) {
      final Attendance? attend =
          await attendProvider.getAttendByUserAndDate(userId: user.id!);
      if (statusFilter == 'حاضر' && attend != null && attend.status == 1) {
        result.add(user);
      } else if (statusFilter == 'غائب' && attend != null && attend.status == 0) {
        result.add(user);
      } else if (statusFilter == 'لم يسجل' && attend == null) {
        result.add(user);
      }
    }
    return result;
  }
}
