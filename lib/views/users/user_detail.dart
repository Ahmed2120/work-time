import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/components/app_button.dart';

import 'components/appbar.dart';
import 'components/attendance.dart';
import 'components/attendance_detail.dart';
import 'components/build_card.dart';
import 'components/draw_money.dart';
import 'components/over_time.dart';
import 'components/slid_bottom_sheet/slid_bottom_sheet.dart';
import 'components/text_row.dart';
import 'components/user_data.dart';

class UserDetail extends StatelessWidget {
  UserDetail({super.key});

  final _keyScaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: true);
    final model = attendanceViewModel.attendanceModel;

    return Consumer<UserViewModel>(
      builder: (ctx, userVM, _) {
        final User user = userVM.user;

        return Scaffold(
          key: _keyScaffold,
          appBar: appBar(userVM, context, user, _keyScaffold),
          body: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // ─── Worker Profile Header Card ──────────────────────────────
                UserData(user: user),

                const SizedBox(height: 20),

                // ─── Attendance Recording Section ───────────────────────────
                Text(
                  'التمام اليومي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 10),

                // Segmented Attendance Control
                AttendanceWidget(user: user),

                const SizedBox(height: 16),

                // Attendance Status Card
                BuildCard(
                  Column(
                    children: [
                      TextRow(
                        title: 'حالة التمام',
                        txt: model.isEmpty
                            ? 'لم يتم تسجيل التمام اليوم'
                            : attendanceViewModel.attendanceText,
                      ),
                      if (model.isNotEmpty && model.last.status == 1)
                        const AttendanceDetail(),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Overtime Checkbox (if present)
                if (model.isNotEmpty && model.last.status == 1) ...[
                  OverTime(user: user),
                  const SizedBox(height: 12),
                ],

                // Action: Withdraw Amount (Indigo Secondary Style - Not Red!)
                if (model.isNotEmpty && model.last.status == 1) ...[
                  AppButton(
                    label: 'سحب مبلغ مالـي',
                    icon: Icons.payments_rounded,
                    style: AppButtonStyle.primary,
                    onPressed: () {
                      _keyScaffold.currentState!.showBottomSheet(
                        (context) => ChangeNotifierProvider.value(
                          value: user,
                          child: DrawFinance(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Action: Attendance Days Sheet
                AppButton(
                  label: 'عرض سجل أيام الحضور',
                  icon: Icons.calendar_month_rounded,
                  style: AppButtonStyle.secondary,
                  onPressed: () {
                    attendanceViewModel.getWeeklyAttendance(user.id!).then((value) {
                      attendanceViewModel.getAttendanceUser(user.id!);
                      showSheet(context);
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
