
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static Future _notificationDetails() async {
    final sound = "sound.wav";
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
          // sound: RawResourceAndroidNotificationSound(sound.split('.').first),
          enableVibration: false,
          importance: Importance.max,),
        iOS: IOSNotificationDetails(sound:  sound));
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    /// when app closed
    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotification.add(details.payload!);
    }
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotification.add(payload!);
      },
    );
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }


  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future showScheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payload,}) async {
    return _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(_scheduleWeekly(Time(8), days: [DateTime.friday]), tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static void cancel(int id) => _notification.cancel(id);

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(minutes: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}){
    tz.TZDateTime scheduleDate = _scheduleDaily(time);

    while (!days.contains(scheduleDate.weekday)){
      print('days: ${scheduleDate.weekday}');
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }
}
