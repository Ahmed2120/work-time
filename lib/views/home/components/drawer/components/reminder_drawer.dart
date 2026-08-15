import 'package:flutter/material.dart';
import 'package:work_time/core/services/daily_reminder_service.dart';
import 'package:work_time/core/theme/app_colors.dart';
import 'package:work_time/views/components/functions.dart';

class ReminderDrawer extends StatefulWidget {
  const ReminderDrawer({super.key});

  @override
  State<ReminderDrawer> createState() => _ReminderDrawerState();
}

class _ReminderDrawerState extends State<ReminderDrawer> {
  bool _isReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final enabled = await DailyReminderService.isReminderEnabled();
    final time = await DailyReminderService.getReminderTime();
    if (mounted) {
      setState(() {
        _isReminderEnabled = enabled;
        _reminderTime = time;
      });
    }
  }

  Future<void> _toggleReminder(bool value) async {
    if (value) {
      final granted = await DailyReminderService.requestPermission();
      if (!granted && mounted) {
        showToast(context, 'يرجى تفعيل إذن الإشعارات من إعدادات الهاتف', color: AppColors.warning);
      }
      await DailyReminderService.scheduleDailyReminder(_reminderTime);
      if (mounted) {
        showToast(context, 'تم تفعيل التنبيه اليومي الساعة ${_formatTime(_reminderTime)} ⏰');
      }
    } else {
      await DailyReminderService.cancelReminder();
      if (mounted) {
        showToast(context, 'تم إيقاف التنبيه اليومي');
      }
    }

    setState(() {
      _isReminderEnabled = value;
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      helpText: 'اختر وقت التنبيه اليومي للتمام',
      cancelText: 'إلغاء',
      confirmText: 'حفظ',
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });

      if (_isReminderEnabled) {
        await DailyReminderService.scheduleDailyReminder(picked);
        if (mounted) {
          showToast(context, 'تم تغيير موعد التنبيه إلى ${_formatTime(picked)} ⏰');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    size: 20,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تنبيه التمام اليومي',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (_isReminderEnabled)
                        InkWell(
                          onTap: _pickTime,
                          child: Text(
                            'الموعد: ${_formatTime(_reminderTime)} (اضغط للتغيير)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _isReminderEnabled,
                  activeTrackColor: AppColors.primaryPurple,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFCBD5E1),
                  onChanged: _toggleReminder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
    final period = time.period == DayPeriod.am ? 'صباحاً' : 'مساءً';
    return '$hour:$minute $period';
  }
}
