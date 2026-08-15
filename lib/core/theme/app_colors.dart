import 'package:flutter/material.dart';

/// Enterprise HR Design System Tokens for WorkTime.
class AppColors {
  // ─── Brand Colors ───────────────────────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF1F3557);
  static const Color primaryPurple = Color(0xFF4338B8);
  static const Color lightPurple = Color(0xFFEEF0FF);

  // Backward compatibility alias for main brand action
  static const Color primary = primaryPurple;
  static const Color primaryDark = primaryNavy;
  static const Color primaryLight = lightPurple;
  static const Color accent = primaryPurple;
  static const Color accentHover = primaryNavy;
  static const Color indigoAccent = Color(0xFF6366F1);

  // ─── Backgrounds & Surfaces ─────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE4E8F0);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // ─── Status: Present (حاضر) ─────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successText = Color(0xFF047857);
  static const Color successBgLight = Color(0xFFECFDF5);
  static const Color successBgDark = Color(0xFF064E3B);

  // ─── Status: Absent (غائب) ──────────────────────────────────────────────────
  static const Color error = Color(0xFFEF476F);
  static const Color danger = Color(0xFFEF476F);
  static const Color dangerText = Color(0xFFBE123C);
  static const Color dangerBgLight = Color(0xFFFFF1F2);
  static const Color dangerBgDark = Color(0xFF881337);

  // ─── Status: Pending / Overtime (سهرة / لم يسجل) ───────────────────────────
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningText = Color(0xFFB45309);
  static const Color warningBgLight = Color(0xFFFFFBEB);
  static const Color warningBgDark = Color(0xFF78350F);

  // ─── Typography ─────────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF172033);
  static const Color textSecondaryLight = Color(0xFF718096);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ─── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4338B8), Color(0xFF1F3557)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4338B8), Color(0xFF3730A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
