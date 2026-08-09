import 'package:flutter/material.dart';
import 'package:work_time/core/utils/cache_helper.dart';

class ThemeViewModel with ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  late bool _isDarkMode;

  ThemeViewModel() {
    _isDarkMode = CacheHelper.getData(key: _themeKey) ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await CacheHelper.saveData(key: _themeKey, value: _isDarkMode);
    notifyListeners();
  }
}
