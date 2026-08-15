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
import 'package:work_time/view_models/theme_view_model.dart';
import 'package:work_time/views/splash_view.dart';

import 'core/notifications/notification_api.dart';
import 'package:work_time/core/theme/theme.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  trial = false;
  await NotificationApi.init(initScheduled: true);
  await DailyReminderService.init();

  // Initialize dependencies with GetIt
  await setupServiceLocator();

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
            title: 'Work Time',
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
