import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:work_time/core/utils/secure_storage_helper.dart';

class ApiService {

  Future<String> getDeviceToken() async {
    String uniqueDeviceId = '';

    var deviceInfo = DeviceInfoPlugin();

    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId =
        '${androidDeviceInfo.brand}:${androidDeviceInfo.id}'; // unique ID on Android

    return uniqueDeviceId;
  }

  Future<bool> getUser(String email) async {
    final encodedEmail = email.trim().toLowerCase().replaceAll('.', ',');
    final url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users/$encodedEmail.json';

    final deviceToken = await getDeviceToken();
    try {
      final response = await http.get(Uri.parse(url));
      print('Requesting URL: $url');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body == 'null') {
        print('User not found at path: users/$encodedEmail');
        return false;
      }

      final userData = json.decode(response.body) as Map<String, dynamic>;

      if (userData['deviceToken'] == '' || userData['deviceToken'] == null || userData['deviceToken'] == deviceToken) {
        await setDeviceToken(encodedEmail);

        // Record subscription date from Firebase into local secure storage
        if (userData['subscriptionDate'] != null) {
          final subDate = DateTime.tryParse(userData['subscriptionDate'].toString());
          if (subDate != null) {
            await SecureStorageHelper.recordSubscription(
              productId: userData['plan']?.toString() ?? 'direct_license',
              purchaseDate: subDate,
            );
          }
        }

        print('User verified successfully');
        return true;
      }

      print('Device mismatch: expected ${userData['deviceToken']}, got $deviceToken');
      return false;
    } on SocketException {
      throw Exception('فشل الاتصال بالخادم ، تأكد من اتصالك بالإنترنت 📶');
    } on FormatException {
      throw Exception("Bad response 🙄");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> setDeviceToken(String encodedEmail) async {
    final url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users/$encodedEmail.json';

    final deviceToken = await getDeviceToken();

    await http.patch(Uri.parse(url),
        body: json.encode({
          'deviceToken': deviceToken,
          'lastLogin': DateTime.now().toIso8601String(),
        }));
    
    print('Device token updated for: $encodedEmail');
  }
}
