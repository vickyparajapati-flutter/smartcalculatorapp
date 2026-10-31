import 'package:flutter/material.dart';

class AppColors {
  // Brand BlueGrey Accents - Sleek & Thin Minimalist
  static const Color primary = Color(0xFF0284C7); // Sky 600
  static const Color primaryLight = Color(0xFF38BDF8); // Sky 400
  static const Color primaryDark = Color(0xFF0369A1); // Sky 700

  // Subtle accent highlights (Thin & Refined)
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

  // ==================== ULTRA-THIN LUXURY BLUE-GREY DARK ====================
  // Seamless edge-to-edge dark canvas (Matte minimalist)
  static const Color darkBackground = Color(0xFF0C1116); // Deepest refined blue-grey
  static const Color darkSurface = Color(0xFF131A21); // Subtle elevated surface
  static const Color darkCard = Color(0xFF161F27); // Flat matte card
  static const Color darkKeypadBg = Color(0xFF0C1116); // Seamless, no demarcation
  static const Color darkNumKey = Color(0xFF162029); // Floating matte number pill
  static const Color darkOpKey = Color(0xFF1F2C38); // Subtle operator contrast
  static const Color darkActionKey = Color(0xFF1A242D); // Subtle function pill
  static const Color darkBorder = Color(0x1AFFFFFF); // Hairline 10% white border

  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Light delicate text
  static const Color darkTextSecondary = Color(0xFF64748B); // Muted Blue-Grey
  static const Color darkTextMuted = Color(0xFF475569);

  // ==================== ULTRA-THIN CRISP LIGHT ====================
  static const Color lightBackground = Color(0xFFF8FAFC); // Clean airy canvas
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightKeypadBg = Color(0xFFF8FAFC);
  static const Color lightNumKey = Color(0xFFFFFFFF);
  static const Color lightOpKey = Color(0xFFEDF2F7);
  static const Color lightActionKey = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0x14000000); // 8% black hairline

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient equalsGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
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
    colors: [Color(0xFF1A232A), Color(0xFF26333D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
