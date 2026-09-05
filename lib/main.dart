import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:work_time/core/services/daily_reminder_service.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/view_models/reports_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/note_view_model.dart';
import 'package:work_time/view_models/backup_view_model.dart';
import 'package:work_time/view_models/purchase_view_model.dart';
import 'package:work_time/view_models/project_view_model.dart';
import 'package:work_time/view_models/theme_view_model.dart';
import 'package:work_time/views/splash_view.dart';

import 'package:work_time/core/theme/theme.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  try {
    await CacheHelper.init();
    await SecureStorageHelper.init();
  } catch (e) {
    debugPrint("Storage init error: $e");
  }

  try {
    await DailyReminderService.init();
  } catch (e) {
    debugPrint("DailyReminderService init error: $e");
  }

  // Initialize dependencies with GetIt
  try {
    await setupServiceLocator();
  } catch (e) {
    debugPrint("setupServiceLocator error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => sl<ThemeViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<UserViewModel>()..getUsers(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<AttendanceViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<NoteViewModel>()..getNotes(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<BackupViewModel>()..initGoogleAuth(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<ReportsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<PurchaseViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<ProjectViewModel>()..loadProjects(),
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar'), // Arabic default
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'عُمَّالي',
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: themeViewModel.themeMode,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
