import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

Color defaultColor = AppColors.primaryPurple;

// ─── Light Theme ──────────────────────────────────────────────────────────────
ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Cairo',
  primaryColor: AppColors.primaryPurple,
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardColor: AppColors.lightSurface,

  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryPurple,
    secondary: AppColors.primaryNavy,
    surface: AppColors.lightSurface,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.textPrimaryLight,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleSpacing: 20,
    iconTheme: IconThemeData(color: AppColors.textPrimaryLight, size: 22),
    actionsIconTheme: IconThemeData(color: AppColors.textPrimaryLight, size: 22),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: AppColors.textPrimaryLight,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo',
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.lightBorder, width: 1),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
  ),

  iconTheme: const IconThemeData(color: AppColors.primaryPurple, size: 22),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    unselectedItemColor: AppColors.textSecondaryLight,
    selectedItemColor: AppColors.primaryPurple,
    elevation: 0,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
    unselectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    hintStyle: const TextStyle(
      color: AppColors.textSecondaryLight,
      fontSize: 14,
      fontFamily: 'Cairo',
    ),
    labelStyle: const TextStyle(
      color: AppColors.textSecondaryLight,
      fontSize: 14,
      fontFamily: 'Cairo',
    ),
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: AppColors.lightSurface),

  dividerTheme: const DividerThemeData(
    color: AppColors.lightBorder,
    thickness: 1,
    space: 1,
  ),

  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
      fontFamily: 'Cairo',
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryLight,
      fontFamily: 'Cairo',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
      fontFamily: 'Cairo',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryLight,
      fontFamily: 'Cairo',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryLight,
      fontFamily: 'Cairo',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
      fontFamily: 'Cairo',
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? AppColors.primaryPurple : Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
  ),
);

// ─── Dark Theme ───────────────────────────────────────────────────────────────
ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Cairo',
  primaryColor: AppColors.primaryPurple,
  scaffoldBackgroundColor: AppColors.darkBackground,
  cardColor: AppColors.darkSurface,

  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryPurple,
    secondary: AppColors.primaryNavy,
    surface: AppColors.darkSurface,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleSpacing: 20,
    iconTheme: IconThemeData(color: AppColors.textPrimaryDark, size: 22),
    actionsIconTheme: IconThemeData(color: AppColors.textPrimaryDark, size: 22),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: AppColors.textPrimaryDark,
      fontWeight: FontWeight.w700,
      fontFamily: 'Cairo',
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.darkBorder, width: 1),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
  ),

  iconTheme: const IconThemeData(color: AppColors.indigoAccent, size: 22),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    unselectedItemColor: AppColors.textSecondaryDark,
    selectedItemColor: AppColors.indigoAccent,
    elevation: 0,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
    unselectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.darkBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.darkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.indigoAccent, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    hintStyle: const TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 14,
      fontFamily: 'Cairo',
    ),
    labelStyle: const TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 14,
      fontFamily: 'Cairo',
    ),
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: AppColors.darkSurface),

  dividerTheme: const DividerThemeData(
    color: AppColors.darkBorder,
    thickness: 1,
    space: 1,
  ),

  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
      fontFamily: 'Cairo',
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
      fontFamily: 'Cairo',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
      fontFamily: 'Cairo',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryDark,
      fontFamily: 'Cairo',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryDark,
      fontFamily: 'Cairo',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
      fontFamily: 'Cairo',
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? AppColors.indigoAccent : Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
  ),
);
