import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'package:work_time/data/repositories/database_handler.dart';

/// خدمة المزامنة والإحصائيات الصامتة لتتبع عدد المستخدمين والعمال
class TelemetryService {
  static const String _keyUuid = 'app_user_uuid';
  static const String _keyLastSync = 'last_telemetry_sync';
  static const String _keyFirstSeen = 'app_first_seen_date';
  static const String _firebaseDbUrl = 'https://worktime-33fa5-default-rtdb.firebaseio.com';

  /// توليد أو استرجاع الـ UUID الدائم للجهاز
  static String getOrCreateUuid() {
    try {
      String? uuid = CacheHelper.getData(key: _keyUuid) as String?;
      if (uuid == null || uuid.isEmpty) {
        uuid = _generateUuidV4();
        CacheHelper.saveData(key: _keyUuid, value: uuid);
      }
      return uuid;
    } catch (e) {
      debugPrint('Error getting UUID: $e');
      return _generateUuidV4();
    }
  }

  /// مزامنة صامتة كل 24 ساعة بدون إزعاج المستخدم أو التأثير على سرعة التطبيق
  static Future<void> syncTelemetrySilently() async {
    try {
      final now = DateTime.now();

      // التحقق مما إذا تم التزامن خلال آخر 24 ساعة
      final String? lastSyncStr = CacheHelper.getData(key: _keyLastSync) as String?;
      if (lastSyncStr != null) {
        final lastSync = DateTime.tryParse(lastSyncStr);
        if (lastSync != null && now.difference(lastSync).inHours < 24) {
          debugPrint('Telemetry already synced within 24 hours.');
          return;
        }
      }

      final uuid = getOrCreateUuid();

      // حفظ تاريخ أول فتح إن لم يكن محفوظاً
      String? firstSeen = CacheHelper.getData(key: _keyFirstSeen) as String?;
      if (firstSeen == null || firstSeen.isEmpty) {
        firstSeen = now.toIso8601String();
        await CacheHelper.saveData(key: _keyFirstSeen, value: firstSeen);
      }

      // جلب عدد العمال والمشاريع من قاعدة البيانات المحلية SQLite
      final db = await DatabaseHandler().initializeDB();
      int employeeCount = 0;
      int projectsCount = 0;

      try {
        final empRes = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE isDeleted = 0');
        if (empRes.isNotEmpty) {
          employeeCount = (empRes.first['count'] as int?) ?? 0;
        }
      } catch (_) {}

      try {
        final projRes = await db.rawQuery('SELECT COUNT(*) as count FROM projects');
        if (projRes.isNotEmpty) {
          projectsCount = (projRes.first['count'] as int?) ?? 0;
        }
      } catch (_) {}

      // جلب معلومات الجهاز
      String deviceModel = 'Unknown Device';
      String osVersion = 'Unknown';
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceModel = '${androidInfo.brand} ${androidInfo.model}'.trim();
          osVersion = 'Android ${androidInfo.version.release}';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
          osVersion = 'iOS ${iosInfo.systemVersion}';
        }
      } catch (_) {}

      // التحقق من حالة الاشتراك والتجربة
      bool isSubscribed = false;
      bool isTrial = true;
      try {
        isSubscribed = await SecureStorageHelper.isUserExist();
        isTrial = await SecureStorageHelper.isTrial();
      } catch (_) {}

      // تجهيز الحزمة الإحصائية
      final payload = {
        'uuid': uuid,
        'employeeCount': employeeCount,
        'projectsCount': projectsCount,
        'deviceModel': deviceModel,
        'osVersion': osVersion,
        'isSubscribed': isSubscribed,
        'isTrial': isTrial,
        'firstSeen': firstSeen,
        'lastSeen': now.toIso8601String(),
      };

      // إرسال البيانات إلى Firebase Realtime Database عبر PATCH
      final url = Uri.parse('$_firebaseDbUrl/devices/$uuid.json');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Telemetry synced successfully: $payload');
        await CacheHelper.saveData(key: _keyLastSync, value: now.toIso8601String());
      } else {
        debugPrint('Telemetry sync failed with code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Silent telemetry error: $e');
    }
  }

  /// خوارزمية توليد UUID v4 قياسي
  static String _generateUuidV4() {
    final random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // RFC 4122 v4
    values[8] = (values[8] & 0x3f) | 0x80; // Variant 10
    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
