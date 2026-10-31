import 'package:flutter/material.dart';

class AppColors {
  // Brand BlueGrey Accents
  static const Color primary = Color(0xFF0284C7); // Sky 600
  static const Color primaryLight = Color(0xFF38BDF8); // Sky 400
  static const Color primaryDark = Color(0xFF0369A1); // Sky 700

  // Accent highlights that shine against BlueGrey
  static const Color cyan = Color(0xFF38BDF8);
  static const Color teal = Color(0xFF2DD4BF);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFFBBF24);
  static const Color rose = Color(0xFFFB7185);
  static const Color violet = Color(0xFFA78BFA);
  static const Color orange = Color(0xFFFB923C);
  static const Color danger = Color(0xFFF43F5E);

  // Aliases for compatibility
  static const Color secondary = emerald;
  static const Color accent = amber;

  // ==================== PREMIUM BLUE-GREY DARK THEME ====================
  static const Color darkBackground = Color(0xFF131B21); // Deepest Blue-Grey
  static const Color darkSurface = Color(0xFF1C2730); // Card Blue-Grey
  static const Color darkCard = Color(0xFF1E2A34); // Elevated Surface
  static const Color darkKeypadBg = Color(0xFF17222A); // Keypad deck
  static const Color darkNumKey = Color(0xFF263541); // Number buttons
  static const Color darkOpKey = Color(0xFF334656); // Operator buttons
  static const Color darkActionKey = Color(0xFF2C3C48); // Functional buttons (AC, (), %)
  static const Color darkBorder = Color(0xFF2F404E); // Crisp subtle borders

  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Crisp slate white
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted Blue-Grey
  static const Color darkTextMuted = Color(0xFF64748B);

  // ==================== CLEAN BLUE-GREY LIGHT THEME ====================
  static const Color lightBackground = Color(0xFFF1F5F9); // Slate-50 Ice BlueGrey
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightKeypadBg = Color(0xFFE2E8F0);
  static const Color lightNumKey = Color(0xFFFFFFFF);
  static const Color lightOpKey = Color(0xFFCFD8DC);
  static const Color lightActionKey = Color(0xFFE2E8F0);
  static const Color lightBorder = Color(0xFFCBD5E1);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient equalsGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)], // Cyan Electric Gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFFFB7185)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGreyGradient = LinearGradient(
    colors: [Color(0xFF263238), Color(0xFF37474F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
