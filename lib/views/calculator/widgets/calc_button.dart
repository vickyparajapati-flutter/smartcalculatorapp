import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

enum CalcButtonType { number, operator, action, equals, scientific }

class CalcButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final CalcButtonType type;
  final Widget? icon;
  final int flex;

  const CalcButton({
    super.key,
    required this.text,
    required this.onTap,
    this.onLongPress,
    this.type = CalcButtonType.number,
    this.icon,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    double fontSize = 28;
    FontWeight fontWeight = FontWeight.w300; // Ultra-thin luxury weight

    switch (type) {
      case CalcButtonType.number:
        bgColor = isDark ? AppColors.darkNumKey : AppColors.lightNumKey;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        fontSize = 28;
        fontWeight = FontWeight.w300;
        break;
      case CalcButtonType.operator:
        bgColor = isDark ? AppColors.darkOpKey : AppColors.lightOpKey;
        textColor = isDark ? AppColors.primaryLight : AppColors.primary;
        fontSize = 28;
        fontWeight = FontWeight.w300; // Delicate mathematical glyphs
        break;
      case CalcButtonType.action:
        bgColor = isDark ? AppColors.darkActionKey : AppColors.lightActionKey;
        textColor = isDark ? AppColors.rose : AppColors.danger;
        fontSize = 18;
        fontWeight = FontWeight.w400;
        break;
      case CalcButtonType.scientific:
        bgColor = isDark ? const Color(0xFF111925) : const Color(0xFFEDF2F7);
        textColor = isDark ? AppColors.primaryLight.withValues(alpha: 0.85) : AppColors.primaryDark;
        fontSize = 14;
        fontWeight = FontWeight.w400;
        break;
      case CalcButtonType.equals:
        bgColor = AppColors.primary;
        textColor = Colors.white;
        fontSize = 32;
        fontWeight = FontWeight.w300;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(26),
            child: Ink(
              decoration: BoxDecoration(
                color: type == CalcButtonType.equals ? null : bgColor,
                gradient: type == CalcButtonType.equals ? AppColors.equalsGradient : null,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.6,
                ),
                boxShadow: type == CalcButtonType.equals
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: icon ??
                    Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
