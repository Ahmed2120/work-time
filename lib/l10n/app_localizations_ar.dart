// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سجل العمل';

  @override
  String get present => 'حاضر';

  @override
  String get absent => 'غائب';

  @override
  String get users => 'العاملين';

  @override
  String get notes => 'الملاحظات';

  @override
  String get trash => 'سلة المهملات';

  @override
  String get all => 'الكل';

  @override
  String get salary => 'الراتب';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get search => 'بحث...';

  @override
  String get noData => 'لا توجد بيانات متاحة';
}
