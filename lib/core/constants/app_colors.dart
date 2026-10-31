import 'package:flutter/material.dart';

class AppColors {
  // Brand / Accent
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Red / Clear

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkNumKey = Color(0xFF1E293B);
  static const Color darkOpKey = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightNumKey = Color(0xFFFFFFFF);
  static const Color lightOpKey = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Category gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient equalsGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
