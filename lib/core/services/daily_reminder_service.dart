import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:work_time/core/theme/app_colors.dart';

class DailyReminderService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _keyReminderEnabled = 'daily_reminder_enabled';
  static const String _keyReminderHour = 'daily_reminder_hour';
  static const String _keyReminderMinute = 'daily_reminder_minute';

  static const int _notificationId = 1001;
  static const String _channelId = 'attendance_reminder_channel_v2';
  static const String _channelName = 'تنبيهات التمام اليومي';
  static const String _channelDescription = 'تذكير يومي لتسجيل حضور وانصراف العمال';

  static bool _initialized = false;
  static bool _isRequestingPermission = false;

  /// Initialize Notification plugin and timezone safely
  static Future<void> init() async {
    if (_initialized) return;

    try {
      try {
        tz.initializeTimeZones();
        final timezoneResult = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneResult.localizedName?.name ?? 'Africa/Cairo'));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
        } catch (_) {}
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(settings: initSettings);

      // Create notification channel explicitly for Android 8.0+
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );
        await androidImplementation.createNotificationChannel(channel);
      }

      _initialized = true;

      // Reschedule if reminder was enabled
      final isEnabled = await isReminderEnabled();
      if (isEnabled) {
        final time = await getReminderTime();
        await scheduleDailyReminder(time);
      }
    } catch (e) {
      debugPrint("Error initializing DailyReminderService: $e");
    }
  }

  /// Request Notification permission safely without concurrent crash
  static Future<bool> requestPermission() async {
    if (_isRequestingPermission) return false;
    _isRequestingPermission = true;

    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? notifGranted =
          await androidImplementation?.requestNotificationsPermission();

      await androidImplementation?.requestExactAlarmsPermission();

      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final bool? iosGranted = await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return (notifGranted ?? false) || (iosGranted ?? false);
    } catch (e) {
      debugPrint("Error requesting notification permission: $e");
      return false;
    } finally {
      _isRequestingPermission = false;
    }
  }

  /// Schedule daily recurring reminder at specified time
  static Future<void> scheduleDailyReminder(TimeOfDay time) async {
    try {
      await init();
      await cancelReminder();

      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time.hour, time.minute);

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        color: AppColors.primaryAmber,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Try exact alarm first, fallback to inexact if exact alarm is restricted on Android 12+
      try {
        await _notificationsPlugin.zonedSchedule(
          id: _notificationId,
          title: 'تذكير التمام اليومي 📋',
          body: 'حان وقت تسجيل حضور وانصراف العمال لليوم.',
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        debugPrint("Exact alarm failed, trying inexact: $e");
        try {
          await _notificationsPlugin.zonedSchedule(
            id: _notificationId,
            title: 'تذكير التمام اليومي 📋',
            body: 'حان وقت تسجيل حضور وانصراف العمال لليوم.',
            scheduledDate: scheduledDate,
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
        } catch (fallbackError) {
          debugPrint("Inexact alarm also failed: $fallbackError");
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyReminderEnabled, true);
      await prefs.setInt(_keyReminderHour, time.hour);
      await prefs.setInt(_keyReminderMinute, time.minute);
    } catch (e) {
      debugPrint("Error in scheduleDailyReminder: $e");
    }
  }

  /// Trigger test notification in N seconds (for testing scheduled alarms)
  static Future<void> scheduleTestNotificationInSeconds({int seconds = 5}) async {
    try {
      await init();
      final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        color: AppColors.primaryAmber,
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.zonedSchedule(
        id: 9998,
        title: 'تجربة التنبيه المجدول ⏱️',
        body: 'يعمل التنبيه المجدول بنجاح بعد $seconds ثوانٍ!',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint("Error in scheduleTestNotificationInSeconds: $e");
    }
  }

  /// Cancel reminder
  static Future<void> cancelReminder() async {
    try {
      await _notificationsPlugin.cancel(id: _notificationId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyReminderEnabled, false);
    } catch (_) {}
  }

  /// Trigger immediate test notification
  static Future<void> showTestNotification() async {
    try {
      await init();
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        color: AppColors.primaryAmber,
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        id: 9999,
        title: 'تجربة التنبيه 🔔',
        body: 'تم ضبط التنبيه اليومي بنجاح لتسجيل حضور العمال.',
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      debugPrint("Error showing test notification: $e");
    }
  }

  /// Check if reminder is enabled
  static Future<bool> isReminderEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyReminderEnabled) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Get saved reminder time (default 09:00 AM)
  static Future<TimeOfDay> getReminderTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hour = prefs.getInt(_keyReminderHour) ?? 9;
      final minute = prefs.getInt(_keyReminderMinute) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
