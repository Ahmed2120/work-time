import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'telemetry_service.dart';

/// خدمة إرسال المقترحات والشكاوى إلى Firebase Realtime Database
class FeedbackService {
  static const String _firebaseDbUrl = 'https://worktime-33fa5-default-rtdb.firebaseio.com';

  static Future<bool> sendFeedback({
    required String type,
    required String message,
    String? contactInfo,
  }) async {
    try {
      final uuid = TelemetryService.getOrCreateUuid();

      String deviceModel = 'Unknown Device';
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceModel = '${androidInfo.brand} ${androidInfo.model}'.trim();
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
        }
      } catch (_) {}

      final payload = {
        'uuid': uuid,
        'type': type,
        'message': message.trim(),
        'contactInfo': (contactInfo ?? '').trim(),
        'deviceModel': deviceModel,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final url = Uri.parse('$_firebaseDbUrl/feedbacks.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Feedback sent successfully: ${response.body}');
        return true;
      } else {
        debugPrint('Feedback submission failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending feedback: $e');
      return false;
    }
  }
}
