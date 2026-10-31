import 'package:flutter/material.dart';

class AppColors {
  // Brand Accents
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color emerald = Color(0xFF10B981);
  static const Color secondary = emerald;
  static const Color amber = Color(0xFFF59E0B);
  static const Color accent = amber;
  static const Color rose = Color(0xFFF43F5E);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF97316);
  static const Color danger = Color(0xFFEF4444);

  // Modern Dark Mode (OLED / Midnight)
  static const Color darkBackground = Color(0xFF080C14);
  static const Color darkSurface = Color(0xFF121926);
  static const Color darkCard = Color(0xFF161F30);
  static const Color darkKeypadBg = Color(0xFF0E1522);
  static const Color darkNumKey = Color(0xFF1A2338);
  static const Color darkOpKey = Color(0xFF23304A);
  static const Color darkBorder = Color(0xFF26354F);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Modern Clean Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightKeypadBg = Color(0xFFF1F5F9);
  static const Color lightNumKey = Color(0xFFFFFFFF);
  static const Color lightOpKey = Color(0xFFE2E8F0);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient equalsGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
