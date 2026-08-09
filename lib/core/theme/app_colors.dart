import 'package:flutter/material.dart';

/// Centralized design token system for WorkTime app.
/// Follows strict SaaS/HR color rules:
/// - Indigo is the main brand color (buttons, nav, actions)
/// - Green/Amber/Red ONLY for semantic attendance status
class AppColors {
  // ─── Brand Colors ───────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3730A3);        // Deep Indigo
  static const Color primaryLight = Color(0xFFEEF2FF);  // Soft Indigo Tint
  static const Color primaryDark = Color(0xFF312E81);   // Darker Indigo

  // ─── Backgrounds & Surfaces ─────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // ─── Status: Present (حاضر) ─────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successText = Color(0xFF047857);
  static const Color successBgLight = Color(0xFFECFDF5);
  static const Color successBgDark = Color(0xFF064E3B);

  // ─── Status: Absent (غائب) ──────────────────────────────────────────────────
  static const Color danger = Color(0xFFF43F5E);
  static const Color dangerText = Color(0xFFBE123C);
  static const Color dangerBgLight = Color(0xFFFFF1F2);
  static const Color dangerBgDark = Color(0xFF881337);

  // ─── Status: Unregistered (لم يسجل) ─────────────────────────────────────────
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
    colors: [Color(0xFF3730A3), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF3730A3), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy aliases kept for backward compatibility
  static const Color accent = primary;
  static const Color accentHover = primaryDark;
  static const Color indigoAccent = Color(0xFF818CF8);
}
