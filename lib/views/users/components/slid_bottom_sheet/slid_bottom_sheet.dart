import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet2/sliding_sheet2.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../../view_models/attendance_view_model.dart';
import 'components/week_data.dart';

Future showSheet(BuildContext context) => showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        cornerRadius: 24,
        duration: const Duration(milliseconds: 250),
        avoidStatusBar: true,
        snapSpec: const SnapSpec(
          snappings: [.45, .85],
        ),
        builder: _buildSheet,
        headerBuilder: _buildHeader,
      ),
    );

Widget _buildHeader(context, state) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Material(
    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    child: Padding(
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
  );
}

Widget _buildSheet(context, state) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

  return Material(
    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: attendanceViewModel.weeksList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => WeekData(index: index),
        ),
      ),
    ),
  );
}
