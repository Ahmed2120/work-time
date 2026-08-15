import 'dart:ui';

import 'package:flutter/material.dart';

extension ContextIArabic on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  bool get isEnglish => !isArabic;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}