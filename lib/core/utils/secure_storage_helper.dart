import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:work_time/core/utils/cache_helper.dart';

/// Secure helper managing encrypted data storage using Android KeyStore & iOS Keychain.
class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _keyIsExist = 'sec_is_exist';
  static const String _keyTrial = 'sec_is_trial';

  /// Initializes secure storage, syncs in-memory flags (`trial`, `iSEXIST`),
  /// and migrates/cleans any legacy unencrypted flags from plain SharedPreferences.
  static Future<void> init() async {
    try {
      // Check if secure values already exist
      String? secExist = await _storage.read(key: _keyIsExist);
      String? secTrial = await _storage.read(key: _keyTrial);

      // One-time migration from legacy SharedPreferences if secure storage is empty
      if (secExist == null && secTrial == null) {
        final legacyExist = CacheHelper.getData(key: 'isExist');
        final legacyTrial = CacheHelper.getData(key: 'trial');

        if (legacyExist != null && legacyExist is bool) {
          await setUserExist(legacyExist);
        }
        if (legacyTrial != null && legacyTrial is bool) {
          await setTrial(legacyTrial);
        }
      }

      // Clean up sensitive keys from plain SharedPreferences to prevent tampering
      await CacheHelper.removeData(key: 'isExist');
      await CacheHelper.removeData(key: 'trial');

      // Sync latest values to fast in-memory variables
      final existVal = await isUserExist();
      final trialVal = await isTrial();

      iSEXIST = existVal;
      trial = trialVal;
    } catch (e) {
      debugPrint('SecureStorageHelper init error: $e');
    }
  }

  /// Check whether the user has a verified purchased license.
  static Future<bool> isUserExist() async {
    try {
      final value = await _storage.read(key: _keyIsExist);
      return value == 'true';
    } catch (e) {
      debugPrint('Error reading isUserExist from secure storage: $e');
      return false;
    }
  }

  /// Store verified user purchase status in encrypted storage.
  static Future<void> setUserExist(bool exist) async {
    try {
      await _storage.write(key: _keyIsExist, value: exist.toString());
      iSEXIST = exist;
    } catch (e) {
      debugPrint('Error saving isUserExist to secure storage: $e');
    }
  }

  /// Check whether trial mode is currently active.
  static Future<bool> isTrial() async {
    try {
      final value = await _storage.read(key: _keyTrial);
      return value == 'true';
    } catch (e) {
      debugPrint('Error reading isTrial from secure storage: $e');
      return false;
    }
  }

  /// Update trial mode status in encrypted storage.
  static Future<void> setTrial(bool isTrial) async {
    try {
      await _storage.write(key: _keyTrial, value: isTrial.toString());
      trial = isTrial;
    } catch (e) {
      debugPrint('Error saving isTrial to secure storage: $e');
    }
  }

  /// Generic write method for sensitive encrypted strings.
  static Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Generic read method for sensitive encrypted strings.
  static Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Generic delete method.
  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Clears all secured items.
  static Future<void> clearAll() async {
    await _storage.deleteAll();
    iSEXIST = false;
    trial = false;
  }
}
