import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/data/models/currency_item.dart';

class CurrencyViewModel with ChangeNotifier {
  static const String _keyCurrencyCode = 'app_user_currency_code';

  CurrencyItem _currentCurrency = CurrencyItem.supportedCurrencies.first;
  CurrencyItem get currentCurrency => _currentCurrency;

  String get code => _currentCurrency.code;
  String get flag => _currentCurrency.flag;

  String currentSymbol(bool isArabic) => _currentCurrency.getSymbol(isArabic);
  String currentName(bool isArabic) => _currentCurrency.getName(isArabic);

  List<CurrencyItem> get allCurrencies => CurrencyItem.supportedCurrencies;

  /// Initializes currency from cache, or auto-detects from device locale if running for the first time.
  void initCurrency() {
    try {
      final savedCode = CacheHelper.getData(key: _keyCurrencyCode) as String?;
      if (savedCode != null && savedCode.isNotEmpty) {
        _currentCurrency = CurrencyItem.findByCode(savedCode);
      } else {
        // Auto-detect based on device locale country code
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        _currentCurrency = CurrencyItem.detectFromLocale(deviceLocale);
        // Persist auto-detected default
        CacheHelper.saveData(key: _keyCurrencyCode, value: _currentCurrency.code);
      }
    } catch (_) {
      _currentCurrency = CurrencyItem.supportedCurrencies.first;
    }
    notifyListeners();
  }

  /// Sets user currency and persists it across app restarts.
  Future<void> setCurrency(CurrencyItem currency) async {
    _currentCurrency = currency;
    await CacheHelper.saveData(key: _keyCurrencyCode, value: currency.code);
    notifyListeners();
  }
}
