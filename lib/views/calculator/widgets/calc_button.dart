import 'package:flutter/material.dart';
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
        bgColor = isDark ? AppColors.darkNumKey : Colors.white;
        textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        break;
      case CalcButtonType.operator:
        bgColor = isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF); // Indigo tint
        textColor = isDark ? const Color(0xFFA5B4FC) : AppColors.primary;
        fontSize = 28;
        fontWeight = FontWeight.bold;
        break;
      case CalcButtonType.action:
        bgColor = isDark ? const Color(0xFF26324A) : const Color(0xFFF1F5F9);
        textColor = isDark ? const Color(0xFFF87171) : AppColors.danger;
        fontSize = 20;
        fontWeight = FontWeight.bold;
        break;
      case CalcButtonType.scientific:
        bgColor = isDark ? const Color(0xFF141D2E) : const Color(0xFFF1F5F9);
        textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
        fontSize = 15;
        fontWeight = FontWeight.w600;
        break;
      case CalcButtonType.equals:
        bgColor = AppColors.primary;
        textColor = Colors.white;
        fontSize = 30;
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
                          : AppColors.darkBorder.withValues(alpha: 0.6))
                      : (type == CalcButtonType.equals
                          ? Colors.transparent
                          : AppColors.lightBorder),
                  width: 1,
                ),
                boxShadow: type == CalcButtonType.equals
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : (isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]),
              ),
              child: Center(
                child: icon ??
                    Text(
                      text,
                      style: TextStyle(
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
