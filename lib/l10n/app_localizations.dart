import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// عنوان التطبيق الرئيسي
  ///
  /// In ar, this message translates to:
  /// **'عُمَّالي'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث...'**
  String get search;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @salary.
  ///
  /// In ar, this message translates to:
  /// **'الراتب'**
  String get salary;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات متاحة'**
  String get noData;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'ج'**
  String get currency;

  /// No description provided for @day.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get day;

  /// No description provided for @days.
  ///
  /// In ar, this message translates to:
  /// **'أيام'**
  String get days;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get ok;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير 👋'**
  String get goodMorning;

  /// No description provided for @totalWorkers.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get totalWorkers;

  /// No description provided for @present.
  ///
  /// In ar, this message translates to:
  /// **'حاضر'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In ar, this message translates to:
  /// **'غائب'**
  String get absent;

  /// No description provided for @notRecorded.
  ///
  /// In ar, this message translates to:
  /// **'غير مسجل'**
  String get notRecorded;

  /// No description provided for @workers.
  ///
  /// In ar, this message translates to:
  /// **'الموظفون'**
  String get workers;

  /// No description provided for @allJobs.
  ///
  /// In ar, this message translates to:
  /// **'كل المهن'**
  String get allJobs;

  /// No description provided for @searchWorkers.
  ///
  /// In ar, this message translates to:
  /// **'بحث في العمال'**
  String get searchWorkers;

  /// No description provided for @searchWorkersHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث في جميع العمال (بالاسم أو الوظيفة)...'**
  String get searchWorkersHint;

  /// No description provided for @closeSearch.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق البحث'**
  String get closeSearch;

  /// No description provided for @clear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clear;

  /// No description provided for @searchResults.
  ///
  /// In ar, this message translates to:
  /// **'نتائج البحث'**
  String get searchResults;

  /// No description provided for @workerUnit.
  ///
  /// In ar, this message translates to:
  /// **'عامل'**
  String get workerUnit;

  /// No description provided for @noWorkersFound.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عمال يطابقون'**
  String get noWorkersFound;

  /// No description provided for @addWorkerToTrack.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك أضف عمال لمتابعة التمام'**
  String get addWorkerToTrack;

  /// No description provided for @noWorkersWithStatus.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عمال بحالة'**
  String get noWorkersWithStatus;

  /// No description provided for @currently.
  ///
  /// In ar, this message translates to:
  /// **'حالياً'**
  String get currently;

  /// No description provided for @bulkAttendance.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل تمام جماعي'**
  String get bulkAttendance;

  /// No description provided for @selectStatusToApply.
  ///
  /// In ar, this message translates to:
  /// **'اختر الحالة لتطبيقها على المحددين'**
  String get selectStatusToApply;

  /// No description provided for @selectedWorkersCount.
  ///
  /// In ar, this message translates to:
  /// **'المحددين'**
  String get selectedWorkersCount;

  /// No description provided for @ofLabel.
  ///
  /// In ar, this message translates to:
  /// **'من أصل'**
  String get ofLabel;

  /// No description provided for @selectAll.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء تحديد الكل'**
  String get deselectAll;

  /// No description provided for @alreadyAttended.
  ///
  /// In ar, this message translates to:
  /// **'مسجّل مسبقاً'**
  String get alreadyAttended;

  /// No description provided for @selectAtLeastOneWorker.
  ///
  /// In ar, this message translates to:
  /// **'اختر موظفاً واحداً على الأقل'**
  String get selectAtLeastOneWorker;

  /// No description provided for @confirmAbsence.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تسجيل الغياب'**
  String get confirmAbsence;

  /// No description provided for @chooseWorkplaceAndConfirm.
  ///
  /// In ar, this message translates to:
  /// **'اختيار مكان العمل وتأكيد الحضور'**
  String get chooseWorkplaceAndConfirm;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الحفظ...'**
  String get saving;

  /// No description provided for @workplace.
  ///
  /// In ar, this message translates to:
  /// **'مكان العمل'**
  String get workplace;

  /// No description provided for @chooseWorkplace.
  ///
  /// In ar, this message translates to:
  /// **'اختر مكان العمل'**
  String get chooseWorkplace;

  /// No description provided for @defaultWorkplace.
  ///
  /// In ar, this message translates to:
  /// **'الورشة / الموقع'**
  String get defaultWorkplace;

  /// No description provided for @noWorkplace.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد'**
  String get noWorkplace;

  /// No description provided for @addNewWorkplace.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مكان عمل جديد'**
  String get addNewWorkplace;

  /// No description provided for @dailyAttendance.
  ///
  /// In ar, this message translates to:
  /// **'التمام اليومي'**
  String get dailyAttendance;

  /// No description provided for @attendanceStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التمام'**
  String get attendanceStatus;

  /// No description provided for @notRecordedToday.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تسجيل التمام اليوم'**
  String get notRecordedToday;

  /// No description provided for @withdrawMoney.
  ///
  /// In ar, this message translates to:
  /// **'سحب مبلغ مالي'**
  String get withdrawMoney;

  /// No description provided for @settleWeek.
  ///
  /// In ar, this message translates to:
  /// **'تصفية الحساب'**
  String get settleWeek;

  /// No description provided for @weeklyRecord.
  ///
  /// In ar, this message translates to:
  /// **'سجل الأسابيع'**
  String get weeklyRecord;

  /// No description provided for @overtime.
  ///
  /// In ar, this message translates to:
  /// **'عمل إضافي (أوفر تايم)'**
  String get overtime;

  /// No description provided for @overtimeHalfDay.
  ///
  /// In ar, this message translates to:
  /// **'إضافة نصف يوم كأوفر تايم'**
  String get overtimeHalfDay;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get amount;

  /// No description provided for @confirmWithdrawal.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد السحب'**
  String get confirmWithdrawal;

  /// No description provided for @alreadyRegistered.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل التمام مسبقاً'**
  String get alreadyRegistered;

  /// No description provided for @changeAttendanceConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تعديل تمام'**
  String get changeAttendanceConfirm;

  /// No description provided for @changeAttendanceMsg.
  ///
  /// In ar, this message translates to:
  /// **'سوف تقوم بتعديل التمام وجعله '**
  String get changeAttendanceMsg;

  /// No description provided for @workerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العامل'**
  String get workerName;

  /// No description provided for @jobTitle.
  ///
  /// In ar, this message translates to:
  /// **'المهنة'**
  String get jobTitle;

  /// No description provided for @dailyWage.
  ///
  /// In ar, this message translates to:
  /// **'الأجر اليومي'**
  String get dailyWage;

  /// No description provided for @addNewWorker.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عامل جديد'**
  String get addNewWorker;

  /// No description provided for @editWorker.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات العامل'**
  String get editWorker;

  /// No description provided for @deleteWorker.
  ///
  /// In ar, this message translates to:
  /// **'حذف العامل'**
  String get deleteWorker;

  /// No description provided for @moveToTrash.
  ///
  /// In ar, this message translates to:
  /// **'نقل لخارج العمل'**
  String get moveToTrash;

  /// No description provided for @restore.
  ///
  /// In ar, this message translates to:
  /// **'استعادة'**
  String get restore;

  /// No description provided for @outOfWork.
  ///
  /// In ar, this message translates to:
  /// **'خارج العمل'**
  String get outOfWork;

  /// No description provided for @noOutOfWork.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عمال خارج العمل حالياً'**
  String get noOutOfWork;

  /// No description provided for @projectsAndSites.
  ///
  /// In ar, this message translates to:
  /// **'المشاريع والمواقع'**
  String get projectsAndSites;

  /// No description provided for @addProject.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مشروع'**
  String get addProject;

  /// No description provided for @editProject.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المشروع'**
  String get editProject;

  /// No description provided for @deleteProject.
  ///
  /// In ar, this message translates to:
  /// **'حذف المشروع'**
  String get deleteProject;

  /// No description provided for @projectName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المشروع'**
  String get projectName;

  /// No description provided for @projectBudget.
  ///
  /// In ar, this message translates to:
  /// **'ميزانية المشروع'**
  String get projectBudget;

  /// No description provided for @refreshData.
  ///
  /// In ar, this message translates to:
  /// **'تحديث البيانات'**
  String get refreshData;

  /// No description provided for @totalPaid.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المدفوعات'**
  String get totalPaid;

  /// No description provided for @totalSpent.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الإنفاق'**
  String get totalSpent;

  /// No description provided for @totalAdvances.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي السلف'**
  String get totalAdvances;

  /// No description provided for @workDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام العمل'**
  String get workDays;

  /// No description provided for @workersCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد العمال'**
  String get workersCount;

  /// No description provided for @noProjects.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مشاريع مضافة'**
  String get noProjects;

  /// No description provided for @projectDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المشروع'**
  String get projectDetails;

  /// No description provided for @financialSummary.
  ///
  /// In ar, this message translates to:
  /// **'الملخص المالي'**
  String get financialSummary;

  /// No description provided for @activeWorkers.
  ///
  /// In ar, this message translates to:
  /// **'العمال المسجلين بالمشروع'**
  String get activeWorkers;

  /// No description provided for @noWorkersOnProject.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عمال مسجلين في هذا المشروع حتى الآن'**
  String get noWorkersOnProject;

  /// No description provided for @monthlyReports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير الشهرية'**
  String get monthlyReports;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get exportPdf;

  /// No description provided for @selectMonth.
  ///
  /// In ar, this message translates to:
  /// **'اختر الشهر'**
  String get selectMonth;

  /// No description provided for @totalWages.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الأجور'**
  String get totalWages;

  /// No description provided for @netPaid.
  ///
  /// In ar, this message translates to:
  /// **'صافي المدفوع'**
  String get netPaid;

  /// No description provided for @daysPresent.
  ///
  /// In ar, this message translates to:
  /// **'أيام الحضور'**
  String get daysPresent;

  /// No description provided for @daysAbsent.
  ///
  /// In ar, this message translates to:
  /// **'أيام الغياب'**
  String get daysAbsent;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الداكن'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الفاتح'**
  String get lightMode;

  /// No description provided for @dailyReminder.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه التمام اليومي'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In ar, this message translates to:
  /// **'الموعد'**
  String get reminderTime;

  /// No description provided for @backup.
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي'**
  String get backup;

  /// No description provided for @rateApp.
  ///
  /// In ar, this message translates to:
  /// **'تقييم التطبيق'**
  String get rateApp;

  /// No description provided for @feedback.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة الملاحظات'**
  String get feedback;

  /// No description provided for @subscription.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك'**
  String get subscription;

  /// No description provided for @whatsNew.
  ///
  /// In ar, this message translates to:
  /// **'ما الجديد'**
  String get whatsNew;

  /// No description provided for @manageWorkplaces.
  ///
  /// In ar, this message translates to:
  /// **'إدارة أماكن العمل'**
  String get manageWorkplaces;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notes;

  /// No description provided for @addNote.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملاحظة'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملاحظة'**
  String get editNote;

  /// No description provided for @noteTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الملاحظة'**
  String get noteTitle;

  /// No description provided for @noteContent.
  ///
  /// In ar, this message translates to:
  /// **'اكتب الملاحظة هنا...'**
  String get noteContent;

  /// No description provided for @noNotes.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملاحظات، أضف ملاحظة جديدة'**
  String get noNotes;

  /// No description provided for @trash.
  ///
  /// In ar, this message translates to:
  /// **'سلة المهملات'**
  String get trash;

  /// No description provided for @users.
  ///
  /// In ar, this message translates to:
  /// **'العاملين'**
  String get users;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @worker.
  ///
  /// In ar, this message translates to:
  /// **'عامل'**
  String get worker;

  /// No description provided for @addWorker.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عامل'**
  String get addWorker;

  /// No description provided for @editData.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البيانات'**
  String get editData;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @enterWorkerName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم العامل'**
  String get enterWorkerName;

  /// No description provided for @job.
  ///
  /// In ar, this message translates to:
  /// **'الوظيفة'**
  String get job;

  /// No description provided for @enterJob.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الوظيفة'**
  String get enterJob;

  /// No description provided for @dailyWageCategory.
  ///
  /// In ar, this message translates to:
  /// **'الفئة / الراتب اليومي'**
  String get dailyWageCategory;

  /// No description provided for @enterCategory.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الفئة'**
  String get enterCategory;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @workerAddedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة العامل بنجاح'**
  String get workerAddedSuccess;

  /// No description provided for @workerUpdatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل البيانات بنجاح'**
  String get workerUpdatedSuccess;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @pleaseWrite.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك اكتب'**
  String get pleaseWrite;

  /// No description provided for @dayCol.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get dayCol;

  /// No description provided for @dateCol.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get dateCol;

  /// No description provided for @attendanceCol.
  ///
  /// In ar, this message translates to:
  /// **'التمام'**
  String get attendanceCol;

  /// No description provided for @overtimeCol.
  ///
  /// In ar, this message translates to:
  /// **'السهرة'**
  String get overtimeCol;

  /// No description provided for @wageCol.
  ///
  /// In ar, this message translates to:
  /// **'اليومية'**
  String get wageCol;

  /// No description provided for @workplaceCol.
  ///
  /// In ar, this message translates to:
  /// **'مكان العمل'**
  String get workplaceCol;

  /// No description provided for @drawnCol.
  ///
  /// In ar, this message translates to:
  /// **'المسحوب'**
  String get drawnCol;

  /// No description provided for @weekPrefix.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع'**
  String get weekPrefix;

  /// No description provided for @totalAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ الكلي'**
  String get totalAmount;

  /// No description provided for @paidAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المدفوع'**
  String get paidAmount;

  /// No description provided for @remainingAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المتبقي'**
  String get remainingAmount;

  /// No description provided for @accountSettled.
  ///
  /// In ar, this message translates to:
  /// **'تم تصفية الحساب'**
  String get accountSettled;

  /// No description provided for @accountSettledSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تصفية حساب هذا الأسبوع بنجاح'**
  String get accountSettledSuccess;

  /// No description provided for @timeCol.
  ///
  /// In ar, this message translates to:
  /// **'الساعة'**
  String get timeCol;

  /// No description provided for @overtimeAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة سهرة'**
  String get overtimeAdded;

  /// No description provided for @none.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد'**
  String get none;

  /// No description provided for @addNewProjectTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مشروع / موقع جديد'**
  String get addNewProjectTitle;

  /// No description provided for @projectNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم المشروع / الموقع *'**
  String get projectNameRequired;

  /// No description provided for @pleaseEnterProjectName.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال اسم المشروع'**
  String get pleaseEnterProjectName;

  /// No description provided for @projectBudgetOptional.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية التقديرية للأجور (اختياري)'**
  String get projectBudgetOptional;

  /// No description provided for @budget.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية'**
  String get budget;

  /// No description provided for @wages.
  ///
  /// In ar, this message translates to:
  /// **'اليوميات'**
  String get wages;

  /// No description provided for @advances.
  ///
  /// In ar, this message translates to:
  /// **'السلف'**
  String get advances;

  /// No description provided for @noWorkersOnSiteYet.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عمال مسجلين في هذا الموقع حتى الآن'**
  String get noWorkersOnSiteYet;

  /// No description provided for @addWorkersHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف عمالك وابدأ في متابعة الحضور والحسابات بسهولة'**
  String get addWorkersHint;

  /// No description provided for @budgetExceededBy.
  ///
  /// In ar, this message translates to:
  /// **'تجاوزت الميزانية بمقدار'**
  String get budgetExceededBy;

  /// No description provided for @deleteProjectConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا المشروع؟'**
  String get deleteProjectConfirm;

  /// No description provided for @untitled.
  ///
  /// In ar, this message translates to:
  /// **'بدون عنوان'**
  String get untitled;

  /// No description provided for @noteSavedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملاحظة بنجاح'**
  String get noteSavedSuccess;

  /// No description provided for @noteUpdatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الملاحظة بنجاح'**
  String get noteUpdatedSuccess;

  /// No description provided for @addNewNote.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملاحظة جديدة'**
  String get addNewNote;

  /// No description provided for @saveNote.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الملاحظة'**
  String get saveNote;

  /// No description provided for @noteTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب عنوان الملاحظة...'**
  String get noteTitleHint;

  /// No description provided for @searchInNotes.
  ///
  /// In ar, this message translates to:
  /// **'بحث في الملاحظات...'**
  String get searchInNotes;

  /// No description provided for @noteColor.
  ///
  /// In ar, this message translates to:
  /// **'لون الملاحظة'**
  String get noteColor;

  /// No description provided for @deleteNoteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذه الملاحظة؟'**
  String get deleteNoteConfirm;

  /// No description provided for @permanentDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف نهائي'**
  String get permanentDelete;

  /// No description provided for @restoreTooltip.
  ///
  /// In ar, this message translates to:
  /// **'استعادة'**
  String get restoreTooltip;

  /// No description provided for @deleteWorkerPermanentlyConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا العامل نهائياً؟'**
  String get deleteWorkerPermanentlyConfirm;

  /// No description provided for @totalEarned.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المستحق'**
  String get totalEarned;

  /// No description provided for @withdrawnPaid.
  ///
  /// In ar, this message translates to:
  /// **'المسحوب / المدفوع'**
  String get withdrawnPaid;

  /// No description provided for @netRemaining.
  ///
  /// In ar, this message translates to:
  /// **'صافي المتبقي للعمال'**
  String get netRemaining;

  /// No description provided for @totalDaysPresent.
  ///
  /// In ar, this message translates to:
  /// **'أيام الحضور الكلية'**
  String get totalDaysPresent;

  /// No description provided for @workersStatement.
  ///
  /// In ar, this message translates to:
  /// **'كشف حساب العمال'**
  String get workersStatement;

  /// No description provided for @monthPrefix.
  ///
  /// In ar, this message translates to:
  /// **'شهر'**
  String get monthPrefix;

  /// No description provided for @exportAndSharePdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير تقرير PDF ومشاركته'**
  String get exportAndSharePdf;

  /// No description provided for @noDataForMonth.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات لهذا الشهر'**
  String get noDataForMonth;

  /// No description provided for @selectAnotherMonthHint.
  ///
  /// In ar, this message translates to:
  /// **'قم باختيار شهر آخر أو تسجيل حضور العمال لعرض التقارير.'**
  String get selectAnotherMonthHint;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مجدداً'**
  String get welcomeBack;

  /// No description provided for @biometricAuthPrompt.
  ///
  /// In ar, this message translates to:
  /// **'يرجى المصادقة بالبصمة أو رمز القفل للوصول إلى بيانات العمل'**
  String get biometricAuthPrompt;

  /// No description provided for @verifying.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق...'**
  String get verifying;

  /// No description provided for @unlockWithFingerprint.
  ///
  /// In ar, this message translates to:
  /// **'فتح التطبيق بالبصمة'**
  String get unlockWithFingerprint;

  /// No description provided for @trialVersion.
  ///
  /// In ar, this message translates to:
  /// **'نسخة تجريبية'**
  String get trialVersion;

  /// No description provided for @continueWithTrial.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة بنسخة تجريبية'**
  String get continueWithTrial;

  /// No description provided for @trialLimitedNote.
  ///
  /// In ar, this message translates to:
  /// **'النسخة التجريبية محدودة المدة — للحصول على الترخيص الكامل تواصل معنا'**
  String get trialLimitedNote;

  /// No description provided for @appSlogan.
  ///
  /// In ar, this message translates to:
  /// **'رفيق صاحب العمل لإدارة العمال واليوميات والتقارير'**
  String get appSlogan;

  /// No description provided for @feedbackType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الملاحظة'**
  String get feedbackType;

  /// No description provided for @feedbackFeatureSuggestion.
  ///
  /// In ar, this message translates to:
  /// **'اقتراح ميزة 💡'**
  String get feedbackFeatureSuggestion;

  /// No description provided for @feedbackBugReport.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة أو عطل ⚠️'**
  String get feedbackBugReport;

  /// No description provided for @feedbackGeneralOpinion.
  ///
  /// In ar, this message translates to:
  /// **'رأي عام 💬'**
  String get feedbackGeneralOpinion;

  /// No description provided for @writeYourFeedback.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رسالتك أو اقتراحك هنا...'**
  String get writeYourFeedback;

  /// No description provided for @sendFeedback.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الملاحظة'**
  String get sendFeedback;

  /// No description provided for @feedbackSentSuccess.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لك! تم إرسال ملاحظتك بنجاح'**
  String get feedbackSentSuccess;

  /// No description provided for @pleaseWriteMessageFirst.
  ///
  /// In ar, this message translates to:
  /// **'من فضلك اكتب رسالتك أولاً'**
  String get pleaseWriteMessageFirst;

  /// No description provided for @backupTitle.
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي السحابي'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احفظ بيانات عمالك وتقاريرك بأمان'**
  String get backupSubtitle;

  /// No description provided for @backupNow.
  ///
  /// In ar, this message translates to:
  /// **'نسخ احتياطي الآن'**
  String get backupNow;

  /// No description provided for @restoreBackup.
  ///
  /// In ar, this message translates to:
  /// **'استعادة نسخة احتياطية'**
  String get restoreBackup;

  /// No description provided for @lastBackup.
  ///
  /// In ar, this message translates to:
  /// **'آخر نسخة احتياطية'**
  String get lastBackup;

  /// No description provided for @neverBackedUp.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم النسخ مسبقاً'**
  String get neverBackedUp;

  /// No description provided for @backupStep1.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز البيانات وتشفيرها محلياً'**
  String get backupStep1;

  /// No description provided for @backupStep2.
  ///
  /// In ar, this message translates to:
  /// **'رفع النسخة الاحتياطية بأمان'**
  String get backupStep2;

  /// No description provided for @backupStep3.
  ///
  /// In ar, this message translates to:
  /// **'اكتمال وحفظ السجل'**
  String get backupStep3;

  /// No description provided for @upgradeToPro.
  ///
  /// In ar, this message translates to:
  /// **'الترقية للنسخة الاحترافية'**
  String get upgradeToPro;

  /// No description provided for @proDescription.
  ///
  /// In ar, this message translates to:
  /// **'احصل على جميع الميزات بدون قيود'**
  String get proDescription;

  /// No description provided for @proFeature1.
  ///
  /// In ar, this message translates to:
  /// **'عدد غير محدود من العمال والمشاريع'**
  String get proFeature1;

  /// No description provided for @proFeature2.
  ///
  /// In ar, this message translates to:
  /// **'نسخ احتياطي واستعادة سحابية غير محدودة'**
  String get proFeature2;

  /// No description provided for @proFeature3.
  ///
  /// In ar, this message translates to:
  /// **'تصدير تقارير PDF مفصلة مع مشاركة فورية'**
  String get proFeature3;

  /// No description provided for @proFeature4.
  ///
  /// In ar, this message translates to:
  /// **'دعم فني وتحديثات مستمرة'**
  String get proFeature4;

  /// No description provided for @subscribeMonthly.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك شهري'**
  String get subscribeMonthly;

  /// No description provided for @subscribeYearly.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك سنوي (الأفضل توفيراً)'**
  String get subscribeYearly;

  /// No description provided for @lifetimeAccess.
  ///
  /// In ar, this message translates to:
  /// **'مدى الحياة (دفعة واحدة)'**
  String get lifetimeAccess;

  /// No description provided for @restorePurchases.
  ///
  /// In ar, this message translates to:
  /// **'استعادة المشتريات'**
  String get restorePurchases;

  /// No description provided for @termsOfService.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveSubscription.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك اشتراك بالفعل؟'**
  String get alreadyHaveSubscription;

  /// No description provided for @orSelectPlan.
  ///
  /// In ar, this message translates to:
  /// **'أو اختر الخطة المناسبة لك'**
  String get orSelectPlan;

  /// No description provided for @activateLicense.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل ترخيص التطبيق'**
  String get activateLicense;

  /// No description provided for @activateLicenseSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني المسجل لدينا للتحقق من شراء التطبيق وتفعيله'**
  String get activateLicenseSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال البريد الإلكتروني'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صالح'**
  String get pleaseEnterValidEmail;

  /// No description provided for @activatePurchase.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الشراء'**
  String get activatePurchase;

  /// No description provided for @verifyAndLogin.
  ///
  /// In ar, this message translates to:
  /// **'التحقق وتسجيل الدخول'**
  String get verifyAndLogin;

  /// No description provided for @licenseActivatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تفعيل الترخيص بنجاح'**
  String get licenseActivatedSuccess;

  /// No description provided for @emailNotRegistered.
  ///
  /// In ar, this message translates to:
  /// **'هذا البريد غير مسجل كمشترك، يرجى شراء التطبيق أولاً.'**
  String get emailNotRegistered;

  /// No description provided for @connectionError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بالخادم'**
  String get connectionError;

  /// No description provided for @dialogAlert.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه'**
  String get dialogAlert;

  /// No description provided for @dialogOk.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get dialogOk;

  /// No description provided for @purchaseAlertTitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه عملية الشراء'**
  String get purchaseAlertTitle;

  /// No description provided for @subscribeNowGooglePlay.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك الآن عبر Google Play'**
  String get subscribeNowGooglePlay;

  /// No description provided for @upgradeToUnlimited.
  ///
  /// In ar, this message translates to:
  /// **'ترقية حساب عُمَّالي إلى غير المحدود'**
  String get upgradeToUnlimited;

  /// No description provided for @choosePackage.
  ///
  /// In ar, this message translates to:
  /// **'اختر الباقة المناسبة لمؤسستك واستمتع بجميع الميزات بلا حدود'**
  String get choosePackage;

  /// No description provided for @proFeatureUnlimitedWorkers.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عدد غير محدود من العمال والورش'**
  String get proFeatureUnlimitedWorkers;

  /// No description provided for @proFeatureUnlimitedAttendance.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الحضور والغياب والسهرات بلا قيود'**
  String get proFeatureUnlimitedAttendance;

  /// No description provided for @proFeatureCloudSync.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة سحابية أسبوعية تلقائية على Google Drive'**
  String get proFeatureCloudSync;

  /// No description provided for @proFeaturePdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير كشوف رواتب وحسابات PDF بلا حدود'**
  String get proFeaturePdf;

  /// No description provided for @chooseSubscriptionPlan.
  ///
  /// In ar, this message translates to:
  /// **'اختر خطة الاشتراك:'**
  String get chooseSubscriptionPlan;

  /// No description provided for @restorePreviousPurchases.
  ///
  /// In ar, this message translates to:
  /// **'استعادة المشتريات السابقة (Restore)'**
  String get restorePreviousPurchases;

  /// No description provided for @cannotOpenLink.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح الرابط في المتصفح'**
  String get cannotOpenLink;

  /// No description provided for @cannotOpenLinkError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح الرابط'**
  String get cannotOpenLinkError;

  /// No description provided for @workplaceLabel.
  ///
  /// In ar, this message translates to:
  /// **'مكان / موقع العمل'**
  String get workplaceLabel;

  /// No description provided for @workplaceHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: الورشة، موقع التجمع، فيلا زايد...'**
  String get workplaceHint;

  /// No description provided for @attendanceAlreadyPresent.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل التمام مسبقاً'**
  String get attendanceAlreadyPresent;

  /// No description provided for @attendanceAlreadyAbsent.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الغياب مسبقاً'**
  String get attendanceAlreadyAbsent;

  /// No description provided for @customOvertimeTitle.
  ///
  /// In ar, this message translates to:
  /// **'تخصيص حساب السهرة (الوقت الإضافي)'**
  String get customOvertimeTitle;

  /// No description provided for @baseDailyWage.
  ///
  /// In ar, this message translates to:
  /// **'اليومية الأساسية'**
  String get baseDailyWage;

  /// No description provided for @chooseOvertimeMultiplier.
  ///
  /// In ar, this message translates to:
  /// **'اختر معامل السهرة السريع:'**
  String get chooseOvertimeMultiplier;

  /// No description provided for @orEnterOvertimeManually.
  ///
  /// In ar, this message translates to:
  /// **'أو أدخل إجمالي يومية السهرة يدوياً:'**
  String get orEnterOvertimeManually;

  /// No description provided for @overtimeHintAmount.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 350'**
  String get overtimeHintAmount;

  /// No description provided for @apply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get apply;

  /// No description provided for @addOvertimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'إضافة سهرة'**
  String get addOvertimeLabel;

  /// No description provided for @subscriptionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت فترة الاشتراك'**
  String get subscriptionExpired;

  /// No description provided for @trialExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الفترة التجريبية'**
  String get trialExpired;

  /// No description provided for @renewSubscription.
  ///
  /// In ar, this message translates to:
  /// **'تجديد الاشتراك'**
  String get renewSubscription;

  /// No description provided for @upgradeAccount.
  ///
  /// In ar, this message translates to:
  /// **'ترقية الحساب'**
  String get upgradeAccount;

  /// No description provided for @dataSavedReadOnly.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك محفوظة بالكامل • وضع القراءة فقط'**
  String get dataSavedReadOnly;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الموعد'**
  String get reminderTimeLabel;

  /// No description provided for @reminderTimeTapToChange.
  ///
  /// In ar, this message translates to:
  /// **'اضغط للتغيير'**
  String get reminderTimeTapToChange;

  /// No description provided for @reminderPermissionError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تفعيل إذن الإشعارات من إعدادات الهاتف'**
  String get reminderPermissionError;

  /// No description provided for @reminderEnabled.
  ///
  /// In ar, this message translates to:
  /// **'تم تفعيل التنبيه اليومي الساعة'**
  String get reminderEnabled;

  /// No description provided for @reminderDisabled.
  ///
  /// In ar, this message translates to:
  /// **'تم إيقاف التنبيه اليومي'**
  String get reminderDisabled;

  /// No description provided for @reminderChanged.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير موعد التنبيه إلى'**
  String get reminderChanged;

  /// No description provided for @reminderPickerHelp.
  ///
  /// In ar, this message translates to:
  /// **'اختر وقت التنبيه اليومي للتمام'**
  String get reminderPickerHelp;

  /// No description provided for @am.
  ///
  /// In ar, this message translates to:
  /// **'صباحاً'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In ar, this message translates to:
  /// **'مساءً'**
  String get pm;

  /// No description provided for @upgradeAndSubscription.
  ///
  /// In ar, this message translates to:
  /// **'الترقية والاشتراك'**
  String get upgradeAndSubscription;

  /// No description provided for @activateLicenseDrawer.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل ترخيص التطبيق'**
  String get activateLicenseDrawer;

  /// No description provided for @unlimitedVersion.
  ///
  /// In ar, this message translates to:
  /// **'النسخة غير المحدودة'**
  String get unlimitedVersion;

  /// No description provided for @activeSubscriptionBadge.
  ///
  /// In ar, this message translates to:
  /// **'نشط ⭐'**
  String get activeSubscriptionBadge;

  /// No description provided for @renewSubscriptionDrawer.
  ///
  /// In ar, this message translates to:
  /// **'تجديد الاشتراك'**
  String get renewSubscriptionDrawer;

  /// No description provided for @upgradeAccountDrawer.
  ///
  /// In ar, this message translates to:
  /// **'ترقية الحساب'**
  String get upgradeAccountDrawer;

  /// No description provided for @subscriptionEndedBadge.
  ///
  /// In ar, this message translates to:
  /// **'انتهى الاشتراك 🔒'**
  String get subscriptionEndedBadge;

  /// No description provided for @trialEndedBadge.
  ///
  /// In ar, this message translates to:
  /// **'انتهت التجربة 🔒'**
  String get trialEndedBadge;

  /// No description provided for @remainingDays.
  ///
  /// In ar, this message translates to:
  /// **'متبقي'**
  String get remainingDays;

  /// No description provided for @dayUnit.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get dayUnit;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get details;

  /// No description provided for @workerMovedToOutOfWork.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف العامل ونقله الي خارج العمل'**
  String get workerMovedToOutOfWork;

  /// No description provided for @withdrawalExpiredMessage.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية الاستخدام. يرجى تجديد الاشتراك لتسجيل المسحوبات.'**
  String get withdrawalExpiredMessage;

  /// No description provided for @withdrawn.
  ///
  /// In ar, this message translates to:
  /// **'تم سحب'**
  String get withdrawn;

  /// No description provided for @notSpecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get notSpecified;

  /// No description provided for @markCompleted.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كمكتمل'**
  String get markCompleted;

  /// No description provided for @reopenActive.
  ///
  /// In ar, this message translates to:
  /// **'إعادة كنشط'**
  String get reopenActive;

  /// No description provided for @activeProject.
  ///
  /// In ar, this message translates to:
  /// **'مشروع نشط'**
  String get activeProject;

  /// No description provided for @completedProject.
  ///
  /// In ar, this message translates to:
  /// **'مشروع مكتمل'**
  String get completedProject;

  /// No description provided for @budgetTracking.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الميزانية'**
  String get budgetTracking;

  /// No description provided for @flushbarSubExpiredMsg.
  ///
  /// In ar, this message translates to:
  /// **'انتهت فترة اشتراكك في التطبيق. يرجى تجديد الاشتراك لمتابعة إضافة العمال وتسجيل الحضور.'**
  String get flushbarSubExpiredMsg;

  /// No description provided for @flushbarTrialExpiredMsg.
  ///
  /// In ar, this message translates to:
  /// **'انتهت فترة التجربة المجانية (14 يوماً). يرجى الاشتراك لمتابعة إضافة العمال وتسجيل الحضور.'**
  String get flushbarTrialExpiredMsg;

  /// No description provided for @flushbarLimitedTrialMsg.
  ///
  /// In ar, this message translates to:
  /// **'هذه نسخة تجريبية محدودة الاستخدام. قم بتفعيل الترخيص للاستخدام الكامل.'**
  String get flushbarLimitedTrialMsg;

  /// No description provided for @allDataEncryptedProtected.
  ///
  /// In ar, this message translates to:
  /// **'جميع البيانات والنسخ الاحتياطي مشفرة ومحمية بالكامل'**
  String get allDataEncryptedProtected;

  /// No description provided for @upgradeAccountAndSub.
  ///
  /// In ar, this message translates to:
  /// **'ترقية الحساب والاشتراك'**
  String get upgradeAccountAndSub;

  /// No description provided for @durationLabel.
  ///
  /// In ar, this message translates to:
  /// **'المدة'**
  String get durationLabel;

  /// No description provided for @discountLabel.
  ///
  /// In ar, this message translates to:
  /// **'خصم'**
  String get discountLabel;

  /// No description provided for @newBadge.
  ///
  /// In ar, this message translates to:
  /// **'جديد ✨'**
  String get newBadge;

  /// No description provided for @youAreOnLatestVersion.
  ///
  /// In ar, this message translates to:
  /// **'أنت على أحدث إصدار!'**
  String get youAreOnLatestVersion;

  /// No description provided for @updatesWillBePostedHere.
  ///
  /// In ar, this message translates to:
  /// **'سيتم نشر التحديثات والميزات الجديدة هنا فور إطلاقها.'**
  String get updatesWillBePostedHere;

  /// No description provided for @whatsNewInThisUpdate.
  ///
  /// In ar, this message translates to:
  /// **'ما الجديد في هذا التحديث؟ ✨'**
  String get whatsNewInThisUpdate;

  /// No description provided for @greatStartUsing.
  ///
  /// In ar, this message translates to:
  /// **'رائع، ابدأ الاستخدام'**
  String get greatStartUsing;

  /// No description provided for @workplaceAddedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة مكان العمل بنجاح ✅'**
  String get workplaceAddedSuccess;

  /// No description provided for @workplaceAlreadyExists.
  ///
  /// In ar, this message translates to:
  /// **'مكان العمل موجود بالفعل'**
  String get workplaceAlreadyExists;

  /// No description provided for @editWorkplaceTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل اسم مكان العمل'**
  String get editWorkplaceTitle;

  /// No description provided for @newWorkplaceHint.
  ///
  /// In ar, this message translates to:
  /// **'اسم مكان العمل الجديد'**
  String get newWorkplaceHint;

  /// No description provided for @pleaseWriteName.
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة الاسم'**
  String get pleaseWriteName;

  /// No description provided for @saveEdit.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديل'**
  String get saveEdit;

  /// No description provided for @workplaceUpdatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل مكان العمل بنجاح ✏️'**
  String get workplaceUpdatedSuccess;

  /// No description provided for @workplaceNameInUse.
  ///
  /// In ar, this message translates to:
  /// **'اسم مكان العمل مستخدم بالفعل'**
  String get workplaceNameInUse;

  /// No description provided for @deleteWorkplaceTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف مكان العمل'**
  String get deleteWorkplaceTitle;

  /// No description provided for @deleteWorkplaceConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا المكان؟\nسيتم حذفه من قائمة الاقتراحات ولن يظهر مجدداً.'**
  String get deleteWorkplaceConfirm;

  /// No description provided for @workplaceDeletedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف مكان العمل بنجاح'**
  String get workplaceDeletedSuccess;

  /// No description provided for @addWorkplaceHintInput.
  ///
  /// In ar, this message translates to:
  /// **'أضف مكان عمل (مثال: الورشة، الموقع الرئيسي)'**
  String get addWorkplaceHintInput;

  /// No description provided for @registeredWorkplaces.
  ///
  /// In ar, this message translates to:
  /// **'أماكن العمل المسجلة'**
  String get registeredWorkplaces;

  /// No description provided for @noWorkplacesAdded.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أماكن عمل مضافة'**
  String get noWorkplacesAdded;

  /// No description provided for @addWorkplacesHintDesc.
  ///
  /// In ar, this message translates to:
  /// **'أضف أماكن العمل هنا لتظهر في الاقتراحات وإمكانية تعديلها أو حذفها بسهولة'**
  String get addWorkplacesHintDesc;

  /// No description provided for @bulkAttendanceSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الحضور بنجاح ✅'**
  String get bulkAttendanceSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
