import 'package:flutter/material.dart';

/// Design System Palette 1: "المقاولات والورش الذكية" (Industrial Amber & Slate Charcoal 🏗️)
/// Tailored specifically for "عُمَّالي | Ommali".
class AppColors {
  // ─── Brand Colors ───────────────────────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF0F172A);      // Deep Slate Charcoal (Header & Dark Elements)
  static const Color primarySlate = Color(0xFF1E293B);     // Charcoal Card Surface
  static const Color primaryAmber = Color(0xFFEA580C);     // Warm Amber Rust / Industrial Orange
  static const Color primaryAmberDark = Color(0xFFC2410C); // Deep Amber
  static const Color lightAmber = Color(0xFFFFF7ED);       // Soft Warm Peach background
  static const Color amberAccent = Color(0xFFF97316);      // Vibrant Amber Highlight

  // Compatibility aliases
  static const Color primary = primaryAmber;
  static const Color primaryDark = primaryNavy;
  static const Color primaryLight = lightAmber;
  static const Color accent = primaryAmber;
  static const Color accentHover = primaryAmberDark;
  static const Color indigoAccent = primaryAmber;
  static const Color primaryPurple = primaryAmber;
  static const Color lightPurple = lightAmber;

  // ─── Backgrounds & Surfaces ─────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF151C2C);
  static const Color darkBorder = Color(0xFF243048);

  // ─── Status: Present (حاضر) ─────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);          // Emerald Green (reserved for Present)
  static const Color successText = Color(0xFF047857);
  static const Color successBgLight = Color(0xFFECFDF5);
  static const Color successBgDark = Color(0xFF064E3B);

  // ─── Status: Absent (غائب) ──────────────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);            // Crimson Red (reserved for Absent)
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerText = Color(0xFFB91C1C);
  static const Color dangerBgLight = Color(0xFFFEF2F2);
  static const Color dangerBgDark = Color(0xFF7F1D1D);

  // ─── Status: Pending / Overtime (سهرة / لم يسجل) ───────────────────────────
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningText = Color(0xFFB45309);
  static const Color warningBgLight = Color(0xFFFFFBEB);
  static const Color warningBgDark = Color(0xFF78350F);

  // ─── Typography ─────────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ─── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient drawerHeaderGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
