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
    double fontSize = 26;
    FontWeight fontWeight = FontWeight.w600;

    switch (type) {
      case CalcButtonType.number:
        bgColor = isDark ? AppColors.darkNumKey : AppColors.lightNumKey;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        fontSize = 27;
        fontWeight = FontWeight.w600;
        break;
      case CalcButtonType.operator:
        bgColor = isDark ? AppColors.darkOpKey : AppColors.lightOpKey;
        textColor = isDark ? AppColors.cyan : AppColors.primaryDark;
        fontSize = 29;
        fontWeight = FontWeight.bold;
        break;
      case CalcButtonType.action:
        bgColor = isDark ? AppColors.darkActionKey : AppColors.lightActionKey;
        textColor = isDark ? AppColors.rose : AppColors.danger;
        fontSize = 21;
        fontWeight = FontWeight.bold;
        break;
      case CalcButtonType.scientific:
        bgColor = isDark ? const Color(0xFF1B2630) : const Color(0xFFE2E8F0);
        textColor = isDark ? AppColors.cyan.withValues(alpha: 0.9) : AppColors.primaryDark;
        fontSize = 15;
        fontWeight = FontWeight.w600;
        break;
      case CalcButtonType.equals:
        bgColor = AppColors.primary;
        textColor = Colors.white;
        fontSize = 32;
        fontWeight = FontWeight.bold;
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
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              decoration: BoxDecoration(
                color: type == CalcButtonType.equals ? null : bgColor,
                gradient: type == CalcButtonType.equals ? AppColors.equalsGradient : null,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? (type == CalcButtonType.equals
                          ? Colors.transparent
                          : AppColors.darkBorder.withValues(alpha: 0.7))
                      : (type == CalcButtonType.equals
                          ? Colors.transparent
                          : AppColors.lightBorder),
                  width: 1.2,
                ),
                boxShadow: type == CalcButtonType.equals
                    ? [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: icon ??
                    Text(
                      text,
                      style: GoogleFonts.outfit(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor,
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
