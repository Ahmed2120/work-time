import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/l10n/app_localizations.dart';
import 'package:work_time/view_models/currency_view_model.dart';

extension ContextIArabic on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  bool get isEnglish => !isArabic;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Reactive currency symbol (use inside `build` methods).
  String get currency =>
      Provider.of<CurrencyViewModel>(this, listen: true).currentSymbol(isArabic);

  /// Non-listening currency symbol (safe inside `onPressed` / `onTap` callbacks).
  String get currencyRead =>
      Provider.of<CurrencyViewModel>(this, listen: false).currentSymbol(isArabic);
}