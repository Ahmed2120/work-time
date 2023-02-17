import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/user_provider.dart';

import 'BackupDB/notification/notification_api.dart';
import 'Theme/theme.dart';
import 'cash_helper.dart';
import 'pages/splash_page.dart';
import 'provider/attendance_provider.dart';
import 'provider/note_provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();
  trial=CashHelper.getData(key: 'trial')??false;
 await NotificationApi.init(initScheduled: true);
  NotificationApi.showScheduleNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()..getUsers()),
        ChangeNotifierProvider(create: (context)=> AttendanceProvider()),
        ChangeNotifierProvider(create: (context)=> NoteProvider()..getNotes())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale('ar', 'AE') 
        ],
        title: 'work time',
        theme: lightThemeData,
        home: const SplashPage(),
      ),
    );
  }
}