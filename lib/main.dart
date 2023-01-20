import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:work_time/pages/start_page.dart';
import 'package:work_time/provider/user_provider.dart';

import 'pages/btm_bar_screen.dart';
import 'pages/home/home_page.dart';
import 'provider/attendance_provider.dart';
import 'provider/note_provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()..getUsers()..getTrash()..getSalaries()),
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
        theme: ThemeData(
          fontFamily: 'Cairo',
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF16213E)
          )
        ),
        home: const BottomBarScreen(),
      ),
    );
  }
}