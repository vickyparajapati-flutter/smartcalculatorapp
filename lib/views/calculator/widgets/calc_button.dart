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

    switch (type) {
      case CalcButtonType.number:
        bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        break;
      case CalcButtonType.operator:
        bgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        textColor = AppColors.primaryLight;
        break;
      case CalcButtonType.action:
        bgColor = isDark ? const Color(0xFF334155).withValues(alpha: 0.6) : const Color(0xFFE2E8F0);
        textColor = AppColors.danger;
        break;
      case CalcButtonType.scientific:
        bgColor = isDark ? const Color(0xFF1E293B).withValues(alpha: 0.8) : const Color(0xFFEEF2F6);
        textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
        break;
      case CalcButtonType.equals:
        bgColor = AppColors.primary;
        textColor = Colors.white;
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
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                color: type == CalcButtonType.equals ? null : bgColor,
                gradient: type == CalcButtonType.equals ? AppColors.equalsGradient : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
              ),
              child: Center(
                child: icon ??
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: type == CalcButtonType.scientific ? 16 : 24,
                        fontWeight: FontWeight.w600,
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
