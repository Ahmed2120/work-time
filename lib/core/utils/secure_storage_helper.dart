import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:work_time/core/config/app_config.dart';
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
  static const String _keyTrialStartDate = 'sec_trial_start_date';
  static const String keyActiveSubscriptionId = 'sec_active_subscription_id';
  static const String _keySubscriptionDate = 'sec_subscription_date';
  static const String _keySubscriptionExpiryDate = 'sec_subscription_expiry_date';

  /// Cached synchronous state for rapid UI checks
  static bool isTrialExpiredSync = false;
  static int remainingTrialDaysSync = AppConfig.trialDurationDays;

  /// Returns duration based on subscription tier
  static Duration getSubscriptionDuration(String productId) {
    switch (productId) {
      case AppConfig.subQuarterly:
        return const Duration(days: 90);
      case AppConfig.subBiannual:
        return const Duration(days: 180);
      case AppConfig.subYearly:
        return const Duration(days: 365);
      case AppConfig.subMonthly:
      default:
        return const Duration(days: 30);
    }
  }

  /// Parse transaction date string from Google Play (millis or ISO)
  static DateTime parseTransactionDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    final intMillis = int.tryParse(raw);
    if (intMillis != null) {
      return DateTime.fromMillisecondsSinceEpoch(intMillis);
    }
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  /// Records an active subscription with calculated expiration date
  static Future<void> recordSubscription({
    required String productId,
    DateTime? purchaseDate,
  }) async {
    try {
      final start = purchaseDate ?? DateTime.now();
      final duration = getSubscriptionDuration(productId);
      final expiry = start.add(duration);

      await _storage.write(key: keyActiveSubscriptionId, value: productId);
      await _storage.write(key: _keySubscriptionDate, value: start.toIso8601String());
      await _storage.write(key: _keySubscriptionExpiryDate, value: expiry.toIso8601String());
      await setUserExist(true);
      await setTrial(false);
      debugPrint('Recorded subscription $productId: started $start, expires $expiry');
    } catch (e) {
      debugPrint('Error recording subscription: $e');
    }
  }

  /// Get the recorded subscription expiration date
  static Future<DateTime?> getSubscriptionExpiryDate() async {
    try {
      final dateStr = await _storage.read(key: _keySubscriptionExpiryDate);
      if (dateStr != null && dateStr.isNotEmpty) {
        return DateTime.parse(dateStr);
      }
    } catch (e) {
      debugPrint('Error reading subscription expiry date: $e');
    }
    return null;
  }

  /// Check whether user ever had a recorded subscription purchase
  static Future<bool> wasSubscribedBefore() async {
    try {
      final subId = await _storage.read(key: keyActiveSubscriptionId);
      return subId != null && subId.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

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

      // Initialize trial start date on first launch
      await initTrialStartDateIfNeeded();

      // Sync latest values to fast in-memory variables
      final existVal = await isUserExist();
      final trialVal = await isTrial();

      iSEXIST = existVal;
      trial = trialVal;

      // Update trial expiration cache
      await syncTrialStatus();
    } catch (e) {
      debugPrint('SecureStorageHelper init error: $e');
    }
  }

  /// Initialize trial start date if not already recorded
  static Future<void> initTrialStartDateIfNeeded() async {
    try {
      final existingDate = await _storage.read(key: _keyTrialStartDate);
      if (existingDate == null) {
        final now = DateTime.now().toIso8601String();
        await _storage.write(key: _keyTrialStartDate, value: now);
        await setTrial(true);
      }
    } catch (e) {
      debugPrint('Error initializing trial start date: $e');
    }
  }

  /// Get the recorded trial start date
  static Future<DateTime> getTrialStartDate() async {
    try {
      final dateStr = await _storage.read(key: _keyTrialStartDate);
      if (dateStr != null) {
        return DateTime.parse(dateStr);
      }
    } catch (e) {
      debugPrint('Error reading trial start date: $e');
    }
    return DateTime.now();
  }

  /// Calculates remaining trial days out of 14 days
  static Future<int> getRemainingTrialDays() async {
    final bool isSubscribed = await isUserExist();
    if (isSubscribed) return 0;

    final startDate = await getTrialStartDate();
    final difference = DateTime.now().difference(startDate).inDays;
    final remaining = AppConfig.trialDurationDays - difference;
    return remaining.clamp(0, AppConfig.trialDurationDays);
  }

  /// Checks if the 14-day trial has expired (and user has not subscribed)
  static Future<bool> isTrialExpired() async {
    final bool isSubscribed = await isUserExist();
    if (isSubscribed) return false;

    if (AppConfig.isPlayStore) {
      final startDate = await getTrialStartDate();
      final difference = DateTime.now().difference(startDate).inDays;
      return difference >= AppConfig.trialDurationDays;
    }

    // For apkDirect fallback
    return !(await isTrial());
  }

  /// Syncs trial expiration in-memory cache
  static Future<void> syncTrialStatus() async {
    isTrialExpiredSync = await isTrialExpired();
    remainingTrialDaysSync = await getRemainingTrialDays();
  }

  /// Check whether the user has a verified purchased license.
  static Future<bool> isUserExist() async {
    try {
      final value = await _storage.read(key: _keyIsExist);
      final bool markedExist = value == 'true';
      if (!markedExist) return false;

      // In Play Store mode, verify that subscription has not passed its expiration date
      if (AppConfig.isPlayStore) {
        final expiry = await getSubscriptionExpiryDate();
        if (expiry != null) {
          final now = DateTime.now();
          if (now.isAfter(expiry)) {
            debugPrint('Subscription expired on $expiry (current: $now). Revoking active status.');
            await setUserExist(false);
            return false;
          }
        }
      }

      return true;
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
      if (exist) {
        await setTrial(false);
      }
      await syncTrialStatus();
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
      await syncTrialStatus();
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
    isTrialExpiredSync = false;
    remainingTrialDaysSync = AppConfig.trialDurationDays;
  }
}
