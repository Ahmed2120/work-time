import 'package:flutter/material.dart';
import 'package:work_time/l10n/app_localizations.dart';

extension ContextIArabic on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  bool get isEnglish => !isArabic;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this)!;
}