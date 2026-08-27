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

/// Metadata model for subscription tiers
class SubscriptionTier {
  final String id;
  final String title;
  final String durationText;
  final String fallbackPrice;
  final String? badgeText;
  final int? discountPercent;
  final bool isPopular;

  const SubscriptionTier({
    required this.id,
    required this.title,
    required this.durationText,
    required this.fallbackPrice,
    this.badgeText,
    this.discountPercent,
    this.isPopular = false,
  });
}

class AppConfig {
  /// ─── 🛠️ Default build flavor (can also be overridden via --dart-define=FLAVOR=...) ───
  static const AppFlavor _defaultFlavor = AppFlavor.playStore;

  /// Retrieves the active distribution flavor from the build environment or default
  static AppFlavor get currentFlavor {
    const flavorEnv = String.fromEnvironment('FLAVOR', defaultValue: '');
    if (flavorEnv == 'playStore') return AppFlavor.playStore;
    if (flavorEnv == 'apkDirect') return AppFlavor.apkDirect;
    return _defaultFlavor;
  }

  static bool get isApkDirect => currentFlavor == AppFlavor.apkDirect;
  static bool get isPlayStore => currentFlavor == AppFlavor.playStore;

  // ─── Google Play In-App Purchase Product IDs ──────────────────────────────
  static const String subMonthly = 'ommali_sub_monthly';
  static const String subQuarterly = 'ommali_sub_quarterly';
  static const String subBiannual = 'ommali_sub_biannual';
  static const String subYearly = 'ommali_sub_yearly';

  static const Set<String> subscriptionProductIds = {
    subMonthly,
    subQuarterly,
    subBiannual,
    subYearly,
  };

  /// Subscription tiers metadata with fallback pricing
  static const List<SubscriptionTier> subscriptionTiers = [
    SubscriptionTier(
      id: subYearly,
      title: 'اشتراك سنوي',
      durationText: '12 شهر',
      fallbackPrice: '199 ج.م',
      badgeText: 'الأكثر توفيراً (42%)',
      discountPercent: 42,
      isPopular: true,
    ),
    SubscriptionTier(
      id: subBiannual,
      title: 'اشتراك نصف سنوي',
      durationText: '6 أشهر',
      fallbackPrice: '119 ج.م',
      badgeText: 'توفير 31%',
      discountPercent: 31,
    ),
    SubscriptionTier(
      id: subQuarterly,
      title: 'اشتراك ربع سنوي',
      durationText: '3 أشهر',
      fallbackPrice: '69 ج.م',
      badgeText: 'توفير 27%',
      discountPercent: 27,
    ),
    SubscriptionTier(
      id: subMonthly,
      title: 'اشتراك شهري',
      durationText: '1 شهر',
      fallbackPrice: '29 ج.م',
    ),
  ];

  // ─── Feature Flags ───────────────────────────────────────────────────────
  /// Toggle cloud backup (Google Drive) feature visibility in the drawer & app
  static const bool enableBackupFeature = true;

  // ─── Trial Limits ────────────────────────────────────────────────────────
  /// Duration of the full unrestricted free trial in days (Play Store model)
  static const int trialDurationDays = 14;

  // Legacy fallback limits for direct APK
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
