import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/view_models/attendance_view_model.dart';

import 'components/week_data.dart';

void showSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (modalContext) => const AttendanceWeeksBottomSheet(),
  );
}

class AttendanceWeeksBottomSheet extends StatelessWidget {
  const AttendanceWeeksBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // ─── Drag Handle ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // ─── Sheet Header ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سجل أسابيع الحضور',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder.withValues(alpha: 0.5),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

              // ─── Sheet Content ────────────────────────────────────────
              Expanded(
                child: Consumer<AttendanceViewModel>(
                  builder: (context, attendanceVM, _) {
                    final sortedGroups = attendanceVM.sortedWeekGroups;
                    print(sortedGroups);

                    if (sortedGroups.isEmpty) {
                      return ListView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.primaryPurple.withValues(alpha: 0.2)
                                        : AppColors.lightPurple,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 32,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا يوجد سجل حضور مسجل',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'لم يتم تسجيل أي أيام حضور لهذا العامل حتى الآن.\nقم بتسجيل التمام اليومي أولاً لتظهر الأسابيع هنا.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontFamily: 'Cairo',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: sortedGroups.length,
                      itemBuilder: (BuildContext context, int index) {
                        return WeekData(
                          weekGroup: sortedGroups[index],
                          weekNumber: index + 1,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
