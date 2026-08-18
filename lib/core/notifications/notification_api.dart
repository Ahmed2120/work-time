import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static Future<NotificationDetails> _notificationDetails() async {
    const sound = "sound.wav";
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
        importance: Importance.max,
        icon: '@drawable/ic_stat_notification',
      ),
      iOS: const DarwinNotificationDetails(sound: sound),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@drawable/ic_stat_notification');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notification.initialize(settings: settings);
  }

  static Future showScheduleNotification({
    int id = 0,
    String? payload,
  }) async {
    return _notification.zonedSchedule(
      id: id,
      title: 'نسخ إحتياطي',
      body: 'قم بعمل نسخ احتياطي لحفظ البيانات الجديدة',
      scheduledDate: tz.TZDateTime.from(
        _scheduleWeekly(const Time(8, 0, 0), days: [DateTime.friday]),
        tz.local,
      ),
      notificationDetails: await _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static void cancel(int id) => _notification.cancel(id: id);

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }
}

class Time {
  final int hour;
  final int minute;
  final int second;

  const Time(this.hour, [this.minute = 0, this.second = 0]);
}
