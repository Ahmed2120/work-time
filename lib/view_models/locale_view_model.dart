import 'package:flutter/material.dart';
import 'package:work_time/core/utils/cache_helper.dart';

class LocaleViewModel with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  late String _languageCode;

  LocaleViewModel() {
    _languageCode = CacheHelper.getData(key: _localeKey) ?? 'ar';
  }

  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  bool get isArabic => _languageCode == 'ar';
  bool get isEnglish => _languageCode == 'en';

  Future<void> setLocale(String langCode) async {
    if (_languageCode == langCode) return;
    _languageCode = langCode;
    await CacheHelper.saveData(key: _localeKey, value: langCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final next = _languageCode == 'ar' ? 'en' : 'ar';
    await setLocale(next);
  }
}

