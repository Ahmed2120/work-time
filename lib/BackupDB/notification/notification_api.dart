import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationApi{

  static final _notifications=FlutterLocalNotificationsPlugin();

  static Future _notificationDetails()async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'channel description',
        importance: Importance.max
      ),
      iOS: DarwinNotificationDetails()
    );
  }

  static Future showNotification({
  int id=0,
  String? title,
    String? body,
    String? payload
})async =>_notifications.show(id, title, body, await _notificationDetails(),payload: payload);

//    final FlutterLocalNotificationsPlugin notificationsPlugin=FlutterLocalNotificationsPlugin();
// Future initNotification()async{
//   AndroidInitializationSettings initializationSettingsAndroid=const AndroidInitializationSettings('ic_launcher');
//   var initializationSettingsIos=DarwinInitializationSettings(requestAlertPermission: true,requestBadgePermission: true
//   ,requestSoundPermission: true,
//     onDidReceiveLocalNotification: (int id,String? body,String? payload,String? title)async{}
//   );
//   var initializationSettings=InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIos);
//   await notificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse notificationResponse)async{
//
//   });
// }
//
//    notificationDetails(){
//   return const NotificationDetails(
//     android: AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max),
//     iOS: DarwinNotificationDetails()
//   );
//    }
//
// Future showNotification({int id=0,String? title,String? payload,String? body})async{
//   return notificationsPlugin.show(id, title, body,await notificationDetails());
// }


//  static final StreamController<String?> selectNotificationStream =
//   StreamController<String?>.broadcast();
//
//   static Future<NotificationDetails> _notificationDetails()async{
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         importance: Importance.max
//       ),
//       iOS: DarwinNotificationDetails()
//     );
//   }
//
//   static Future showNotification({int id = 0,
//     String? title,
//     String? body,
//     String? payLoad}
//       )async{
//     print('========= notification');
//     _notification.show(id, title, body,payload:payLoad,  await _notificationDetails() );
//   }
//
// static Future init({bool initSchedule=false})async{
//   final android=AndroidInitializationSettings('app_icon');
//   final ios=DarwinInitializationSettings();
//   final settings=InitializationSettings(android:android,iOS: ios);
//   await _notification.initialize(settings,onDidReceiveNotificationResponse: (notificationResponse){
//     selectNotificationStream.add(notificationResponse.payload);
//     print('notification(${notificationResponse.id}) action tapped: ');
//   });
// }
}