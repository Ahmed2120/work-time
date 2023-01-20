import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class ApiService{

  var fbm = FirebaseMessaging.instance;

  Future<String> getDeviceToken() async{
    String uniqueDeviceId = '';

    var deviceInfo = DeviceInfoPlugin();


      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.brand}:${androidDeviceInfo.id}' ; // unique ID on Android
print('uniqueDeviceId:----- $uniqueDeviceId');

    return uniqueDeviceId;
  }

  Future<bool> getUser(String email) async{
    const url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users.json';

    final response = await http.get(Uri.parse(url));
    final users = json.decode(response.body) as Map<String, dynamic>;
    String? userId;
    users.forEach((key, value) {
      if(value['email'] == email) {
        if(value['deviceToken'] == '') {
          userId = key;
          return;
        }
      }
    });
    print('userId:   $userId');
    if(userId != null) {
      setDeviceToken(userId!);
      print('exist users');
      return true;
    }
    print('no users');
    return false;
  }

  void setDeviceToken(String id) async{
    final url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users/$id.json';

    final deviceToken = await getDeviceToken();

      final result = await http.patch(Uri.parse(url),
          body: json.encode({
            'deviceToken': deviceToken,
          }));
      final users = json.decode(result.body);

      print('000000:   $users');

  }

  void addUser() async{
    final url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users.json';

    final result = await http.post(Uri.parse(url),
        body: json.encode({
          'email': 'osama@gmail.com',
          'deviceToken': '',
        }));
    final users = json.decode(result.body);

    print('000000:   $users');

  }
}