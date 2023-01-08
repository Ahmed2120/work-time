import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time/provider/user_provider.dart';

import 'pages/btm_bar_screen.dart';
import 'pages/home/home_page.dart';
import 'provider/attendance_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()..getUsers()),
        ChangeNotifierProvider(create: (context)=> AttendanceProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'work time',
        theme: ThemeData(
          fontFamily: 'Cairo',
          primarySwatch: Colors.blue,
        ),
        home: const BottomBarScreen(),
      ),
    );
  }
}