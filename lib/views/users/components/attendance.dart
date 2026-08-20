import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/theme/app_colors.dart';

import '../../../core/utils/cache_helper.dart';
import '../../../core/utils/global_methods.dart';
import '../../../data/models/attendance.dart';
import '../../../data/models/user.dart';
import '../../../view_models/attendance_view_model.dart';
import '../../components/constant.dart';
import '../../components/custom_textField.dart';
import '../../components/functions.dart';

class AttendanceWidget extends StatefulWidget {
  const AttendanceWidget({required this.user, super.key});
  final User user;

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  final _formKey = GlobalKey<FormState>();
  final _workPlaceController = TextEditingController();
  bool _hasInitializedWorkPlace = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceViewModel>(context, listen: false).getWorkPlaces();
    });
  }

  @override
  void dispose() {
    _workPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: true);
    final isPresent = attendanceViewModel.attendanceModel.isNotEmpty &&
        attendanceViewModel.attendanceModel.last.status == 1;
    final isAbsent = attendanceViewModel.attendanceModel.isNotEmpty &&
        attendanceViewModel.attendanceModel.last.status == 0;

    // Pre-populate workplace: first from today's record, then from the most recent previous location
    if (!_hasInitializedWorkPlace) {
      String? placeToFill;

      // Priority 1: today's already-recorded attendance
      if (attendanceViewModel.attendanceModel.isNotEmpty) {
        final currentPlace = attendanceViewModel.attendanceModel.last.workPlace;
        if (currentPlace.isNotEmpty && currentPlace != 'لا يوجد') {
          placeToFill = currentPlace;
        }
      }

      // Priority 2: most recently used workplace (first item from DB query)
      if (placeToFill == null && attendanceViewModel.previousWorkPlaces.isNotEmpty) {
        placeToFill = attendanceViewModel.previousWorkPlaces.first;
      }

      if (placeToFill != null) {
        _workPlaceController.text = placeToFill;
        _hasInitializedWorkPlace = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Segmented Control [ حاضر | غائب ] ─────────────────────────────
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              // Button: حاضر (Success Green #10B981 when selected)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    if ((attendanceViewModel.attendanceUser.length) >= AppConfig.maxTrialAttendanceDays && trial) {
                      showFlushBar(context);
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      final placeText = _workPlaceController.text.trim();
                      if (attendanceViewModel.attendanceModel.isEmpty) {
                        final Attendance attendance = Attendance(
                          userId: widget.user.id!,
                          weekEnd: '${GlobalMethods.getWeekDay(attendanceViewModel.dateTimeAttendance)}',
                          todayDate: '${attendanceViewModel.dateTimeAttendance}',
                          workPlace: placeText.isNotEmpty ? placeText : 'الورشة / الموقع',
                          weekId: await attendanceViewModel.setWeekId(userId: widget.user.id!),
                          weekStatus: 0,
                          overTimeStatus: 0,
                          salary: widget.user.salary,
                          status: 1,
                          salaryReceived: '0',
                        );
                        attendanceViewModel.addAttendance(attendance);
                        attendanceViewModel.getAttendanceUserToDay(userId: widget.user.id!);
                        attendanceViewModel.getWeeks(widget.user.id!);
                        attendanceViewModel.getWorkPlaces();
                      } else {
                        if (attendanceViewModel.attendanceModel.last.status == 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => alert(
                              context: context,
                              txt: 'حاضر',
                              color: AppColors.success,
                              onPressed: () {
                                final attendance = Attendance(
                                  id: attendanceViewModel.attendanceModel.last.id,
                                  workPlace: placeText.isNotEmpty ? placeText : attendanceViewModel.attendanceModel.last.workPlace,
                                  userId: widget.user.id!,
                                  todayDate: '${attendanceViewModel.dateTimeAttendance}',
                                  weekEnd: attendanceViewModel.attendanceModel.last.weekEnd,
                                  weekId: attendanceViewModel.attendanceModel.last.weekId,
                                  weekStatus: attendanceViewModel.attendanceModel.last.weekStatus,
                                  status: 1,
                                  overTimeStatus: 0,
                                  salary: widget.user.salary,
                                  salaryReceived: '0',
                                );

                                attendanceViewModel.updateAttendance(attendance: attendance);
                                attendanceViewModel.getAttendanceUserToDay(userId: widget.user.id!);
                                attendanceViewModel.getWorkPlaces();
                                pop(context);
                              },
                            ),
                          );
                        } else {
                          showToast(context, 'تم تسجيل التمام مسبقاً');
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isPresent ? AppColors.success : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: isPresent
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'حاضر',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isPresent
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Button: غائب (Danger Red #EF4444 when selected)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    if (attendanceViewModel.attendanceModel.isEmpty) {
                      final Attendance attendance = Attendance(
                        userId: widget.user.id!,
                        todayDate: '${attendanceViewModel.dateTimeAttendance}',
                        weekEnd: '${GlobalMethods.getWeekDay(attendanceViewModel.dateTimeAttendance)}',
                        weekId: await attendanceViewModel.setWeekId(userId: widget.user.id!),
                        status: 0,
                        weekStatus: 0,
                        overTimeStatus: 0,
                        salary: '0',
                        salaryReceived: '0',
                        workPlace: 'لا يوجد',
                      );
                      attendanceViewModel.addAttendance(attendance);
                      attendanceViewModel.getAttendanceUserToDay(userId: widget.user.id!);
                      attendanceViewModel.getWeeks(widget.user.id!);
                    } else {
                      if (attendanceViewModel.attendanceModel.last.status == 1) {
                        showDialog(
                          context: context,
                          builder: (ctx) => alert(
                            context: context,
                            txt: 'غائب',
                            color: AppColors.danger,
                            onPressed: () {
                              final attendance = Attendance(
                                id: attendanceViewModel.attendanceModel.last.id,
                                userId: widget.user.id!,
                                todayDate: '${attendanceViewModel.dateTimeAttendance}',
                                weekEnd: attendanceViewModel.attendanceModel.last.weekEnd,
                                weekId: attendanceViewModel.attendanceModel.last.weekId,
                                weekStatus: attendanceViewModel.attendanceModel.last.weekStatus,
                                status: 0,
                                overTimeStatus: 0,
                                salary: '0',
                                salaryReceived: '0',
                                workPlace: 'لا يوجد',
                              );
                              attendanceViewModel.updateAttendance(attendance: attendance);
                              attendanceViewModel.getAttendanceUserToDay(userId: widget.user.id!);
                              pop(context);
                            },
                          ),
                        );
                      } else {
                        showToast(context, 'تم تسجيل الغياب مسبقاً');
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isAbsent ? AppColors.danger : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: isAbsent
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'غائب',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isAbsent
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ─── Work Location Field with Quick Suggestion Chips ─────────────────
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _workPlaceController,
                label: 'مكان / موقع العمل (اختياري)',
                hint: 'مثال: الورشة، موقع التجمع، فيلا زايد...',
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: AppColors.primaryAmber),
              ),
              if (attendanceViewModel.previousWorkPlaces.isNotEmpty) ...[
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: attendanceViewModel.previousWorkPlaces.take(8).map((place) {
                      final isSelected = _workPlaceController.text == place;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ActionChip(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightAmber,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryAmber
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: 1,
                          ),
                          label: Text(
                            place,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primaryAmber
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _workPlaceController.text = place;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
