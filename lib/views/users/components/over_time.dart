import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../data/models/attendance.dart';
import '../../../data/models/user.dart';
import '../../../view_models/attendance_view_model.dart';

class OverTime extends StatefulWidget {
  const OverTime({required this.user, super.key});
  final User user;

  @override
  State<OverTime> createState() => _OverTimeState();
}

class _OverTimeState extends State<OverTime> {
  void _updateAttendanceSalary(
    AttendanceViewModel attendanceViewModel,
    Attendance model,
    bool isOvertime,
    String salaryValue,
  ) {
    attendanceViewModel.changeCheckBox(isOvertime);
    final attendance = Attendance(
      id: model.id,
      workPlace: model.workPlace,
      userId: model.userId,
      weekEnd: model.weekEnd,
      todayDate: model.todayDate,
      weekId: model.weekId,
      weekStatus: model.weekStatus,
      status: model.status,
      salary: isOvertime ? salaryValue : widget.user.salary,
      overTimeStatus: isOvertime ? 1 : 0,
      salaryReceived: model.salaryReceived,
    );
    attendanceViewModel.updateAttendance(attendance: attendance);
    attendanceViewModel.getAttendanceUserToDay(userId: model.userId);
  }

  void _showCustomOvertimeDialog(
    BuildContext context,
    AttendanceViewModel attendanceViewModel,
    Attendance model,
  ) {
    final baseSalary = double.tryParse(widget.user.salary) ?? 0.0;
    final customSalaryController = TextEditingController(text: model.salary);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.primaryAmber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'تخصيص حساب السهرة (الوقت الإضافي)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'اليومية الأساسية: ${widget.user.salary} ج.م',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر معامل السهرة السريع:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConfig.supportedOvertimeMultipliers.map((multiplier) {
                  final calculated = (baseSalary * multiplier).toStringAsFixed(1).replaceAll('.0', '');
                  return ActionChip(
                    backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightAmber,
                    side: const BorderSide(color: AppColors.primaryAmber, width: 1),
                    label: Text(
                      '×$multiplier ($calculated ج.م)',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.primaryAmber,
                      ),
                    ),
                    onPressed: () {
                      _updateAttendanceSalary(attendanceViewModel, model, true, calculated);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'أو أدخل إجمالي يومية السهرة يدوياً:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customSalaryController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'مثال: 350',
                        suffixText: 'ج.م',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAmber,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final customVal = customSalaryController.text.trim();
                      if (customVal.isNotEmpty) {
                        _updateAttendanceSalary(attendanceViewModel, model, true, customVal);
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('تطبيق', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
    if (attendanceViewModel.attendanceModel.isEmpty) {
      return const SizedBox.shrink();
    }
    final model = attendanceViewModel.attendanceModel.last;
    final isOvertimeActive = model.overTimeStatus != 0;
    final defaultMult = AppConfig.defaultOvertimeMultiplier;
    final baseSalary = double.tryParse(widget.user.salary) ?? 0.0;
    final defaultOvertimeSalary = (baseSalary * defaultMult).toStringAsFixed(1).replaceAll('.0', '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: isOvertimeActive,
            activeColor: AppColors.primaryAmber,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (val) {
              if (val == null) return;
              _updateAttendanceSalary(
                attendanceViewModel,
                model,
                val,
                val ? defaultOvertimeSalary : widget.user.salary,
              );
            },
          ),
          InkWell(
            onTap: () {
              if (!isOvertimeActive) {
                _updateAttendanceSalary(attendanceViewModel, model, true, defaultOvertimeSalary);
              }
              _showCustomOvertimeDialog(context, attendanceViewModel, model);
            },
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Text(
                  'إضافة سهرة',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (isOvertimeActive) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.lightAmber,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryAmber, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${model.salary} ج.م',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAmber,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.edit_outlined, size: 12, color: AppColors.primaryAmber),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
