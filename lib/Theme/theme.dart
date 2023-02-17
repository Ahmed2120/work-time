import 'package:flutter/material.dart';

Color defaultColor=Color(0xFF16213E);
ThemeData lightThemeData=ThemeData(

    elevatedButtonTheme:ElevatedButtonThemeData(
        style:  ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF9BBB0),
            minimumSize: const Size(double.infinity, 10),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))
    ),
    fontFamily: 'Cairo',
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF16213E)
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: defaultColor,
    appBarTheme:  AppBarTheme(
      iconTheme: IconThemeData(
          color: Colors.white,
          size: 30
      ),
      elevation: 0,
      titleSpacing: 20,
      titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo'
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 25
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFFF5F5F5),
      unselectedItemColor: const Color(0xFFC4C4C2),
      selectedItemColor: const Color(0xFF162640),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Cairo'
      ),
        bodyLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo'
        ),
      bodySmall: TextStyle(
          color:  Colors.white, fontSize: 14, fontWeight: FontWeight.w500
      )
    )
);