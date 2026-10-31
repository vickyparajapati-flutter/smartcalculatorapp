import 'package:flutter/material.dart';

class AppColors {
  // Brand Logo Theme: Obsidian Blue-Grey + Vibrant Flame Orange
  static const Color primary = Color(0xFFFD6B01); // Signature Logo Flame Orange
  static const Color primaryLight = Color(0xFFFE8E02); // Bright Tangerine Glow
  static const Color primaryDark = Color(0xFFE05000); // Deep Flame

  // Logo Accent Palette
  static const Color orange = Color(0xFFFE8E02);
  static const Color flameOrange = Color(0xFFFD5A01);
  static const Color cyan = Color(0xFF38BDF8);
  static const Color teal = Color(0xFF2DD4BF);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFFBBF24);
  static const Color rose = Color(0xFFFB7185);
  static const Color violet = Color(0xFFA78BFA);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);
  static const Color danger = Color(0xFFF43F5E);

  // Aliases for compatibility
  static const Color secondary = emerald;
  static const Color accent = primaryLight;

  // ==================== LOGO SIGNATURE DARK THEME ====================
  // Extracted directly from logo.png center & gradient:
  static const Color darkBackground = Color(0xFF080E1A); // Deep Obsidian Blue-Grey
  static const Color darkSurface = Color(0xFF101826); // Subtle elevated surface
  static const Color darkCard = Color(0xFF141F2F); // Card Blue-Grey
  static const Color darkKeypadBg = Color(0xFF0A101D); // Keypad deck
  static const Color darkNumKey = Color(0xFF162132); // Number button pill
  static const Color darkOpKey = Color(0xFF222E42); // Operator button pill
  static const Color darkActionKey = Color(0xFF1C2638); // Function button (AC, %, ())
  static const Color darkBorder = Color(0x1FFFFFFF); // Hairline 12% white border

  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Crisp white
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted slate
  static const Color darkTextMuted = Color(0xFF64748B);

  // ==================== CLEAN LIGHT THEME ====================
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightKeypadBg = Color(0xFFF8FAFC);
  static const Color lightNumKey = Color(0xFFFFFFFF);
  static const Color lightOpKey = Color(0xFFFFF7ED); // Warm orange tint
  static const Color lightActionKey = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0x14000000);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Exact Logo Gradients
  static const LinearGradient equalsGradient = LinearGradient(
    colors: [Color(0xFFFD5A01), Color(0xFFFE8E02)], // Flame Orange from Logo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFD5A01), Color(0xFFEA580C)],
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
    colors: [Color(0xFF141F2F), Color(0xFF222E42)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
