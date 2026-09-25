import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_time/core/utils/cache_helper.dart';

/// خدمة إدارة طلب تقييم التطبيق بأسلوب خطوة واحدة ذكي وغير مزعج
class RateService {
  static const String _keyLaunchCount = 'rate_launch_count';
  static const String _keyLastPromptDate = 'rate_last_prompt_date';
  static const String _keyHasRated = 'rate_has_rated';
  static const String _appPackageName = 'com.ashraf.workTime';

  /// تتبع فتح التطبيق لزيادة العداد صامتاً
  static void trackAppLaunch() {
    try {
      final int currentCount = (CacheHelper.getData(key: _keyLaunchCount) as int?) ?? 0;
      CacheHelper.saveData(key: _keyLaunchCount, value: currentCount + 1);
    } catch (e) {
      debugPrint('Error tracking app launch: $e');
    }
  }

  /// طلب التقييم الداخلي في خطوة واحدة في اللحظات الإيجابية (مثل تصفية الحساب)
  static Future<bool> checkAndRequestReview() async {
    try {
      // 1. هل قيّم المستخدم من قبل أو طلب عدم الإزعاج؟
      final bool hasRated = (CacheHelper.getData(key: _keyHasRated) as bool?) ?? false;
      if (hasRated) return false;

      // 2. هل فتح التطبيق مرات كافية (3 مرات على الأقل)؟
      final int launchCount = (CacheHelper.getData(key: _keyLaunchCount) as int?) ?? 0;
      if (launchCount < 3) return false;

      // 3. هل تم طلب التقييم مؤخراً خلال آخر 30 يوماً؟
      final String? lastPromptStr = CacheHelper.getData(key: _keyLastPromptDate) as String?;
      if (lastPromptStr != null) {
        final lastPrompt = DateTime.tryParse(lastPromptStr);
        if (lastPrompt != null) {
          final differenceInDays = DateTime.now().difference(lastPrompt).inDays;
          if (differenceInDays < 30) return false;
        }
      }

      // 4. استدعاء واجهة جوجل الرسمية In-App Review
      final inAppReview = InAppReview.instance;
      final isAvailable = await inAppReview.isAvailable();

      if (isAvailable) {
        await inAppReview.requestReview();
        // تسجيل تاريخ الطلب لمنع التكرار
        await CacheHelper.saveData(
          key: _keyLastPromptDate,
          value: DateTime.now().toIso8601String(),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting in-app review: $e');
      return false;
    }
  }

  /// طلب التقييم بدون قيود — يُستخدم فقط بعد إرسال المقترح (لحظة مشاركة حقيقية)
  static Future<void> forceRequestReview() async {
    try {
      final bool hasRated = (CacheHelper.getData(key: _keyHasRated) as bool?) ?? false;
      if (hasRated) return; // لا نزعج من قيّم بالفعل

      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await CacheHelper.saveData(
          key: _keyLastPromptDate,
          value: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      debugPrint('Error forcing in-app review: $e');
    }
  }

  /// فتح صفحة التطبيق في المتجر مباشرة (عند الضغط من القائمة الجانبية Drawer)
  static Future<void> openStoreListing() async {
    try {
      await CacheHelper.saveData(key: _keyHasRated, value: true);
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.openStoreListing(appStoreId: _appPackageName);
      } else {
        final url = Uri.parse('https://play.google.com/store/apps/details?id=$_appPackageName');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Error opening store listing: $e');
      final url = Uri.parse('https://play.google.com/store/apps/details?id=$_appPackageName');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }
}
