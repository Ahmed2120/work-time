import 'package:work_time/core/utils/cache_helper.dart';

/// Application distribution variants (Flavors)
enum AppFlavor {
  /// Standalone APK distribution (e.g. Freelance / Direct client sales)
  /// - License verified via customer email recorded in Firebase.
  /// - No developer contact details displayed in app.
  /// - User can use trial, then enter email after direct payment.
  apkDirect,

  /// Google Play Store distribution
  /// - Uses Google Play In-App Purchases / Subscriptions.
  /// - First launch starts in trial mode with option to subscribe.
  playStore,
}

class AppConfig {
  /// ─── 🛠️ Default build flavor (can also be overridden via --dart-define=FLAVOR=...) ───
  static const AppFlavor _defaultFlavor = AppFlavor.apkDirect;

  /// Retrieves the active distribution flavor from the build environment or default
  static AppFlavor get currentFlavor {
    const flavorEnv = String.fromEnvironment('FLAVOR', defaultValue: '');
    if (flavorEnv == 'playStore') return AppFlavor.playStore;
    if (flavorEnv == 'apkDirect') return AppFlavor.apkDirect;
    return _defaultFlavor;
  }

  static bool get isApkDirect => currentFlavor == AppFlavor.apkDirect;
  static bool get isPlayStore => currentFlavor == AppFlavor.playStore;

  // ─── Feature Flags ───────────────────────────────────────────────────────
  /// Toggle cloud backup (Google Drive) feature visibility in the drawer & app
  static const bool enableBackupFeature = true;

  // ─── Trial Limits ────────────────────────────────────────────────────────
  static const int maxTrialWorkers = 5;
  static const int maxTrialNotes = 5;
  static const int maxTrialAttendanceDays = 7;

  // ─── Overtime Defaults ───────────────────────────────────────────────────
  static const List<double> supportedOvertimeMultipliers = [1.0, 1.25, 1.5, 1.75, 2.0];

  static double get defaultOvertimeMultiplier {
    final val = CacheHelper.getData(key: 'default_overtime_multiplier');
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return 1.5; // Default 1.5x (يوم ونصف)
  }

  static Future<void> setDefaultOvertimeMultiplier(double multiplier) async {
    await CacheHelper.saveData(key: 'default_overtime_multiplier', value: multiplier);
  }
}
