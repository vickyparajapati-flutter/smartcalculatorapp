import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../providers/calculator_provider.dart';
import '../../providers/vault_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../vault/vault_home_screen.dart';
import '../vault/vault_setup_dialog.dart';
import 'widgets/calc_button.dart';
import 'widgets/history_sheet.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Minimalist Top App Bar Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Thin Frosted All Tools Pill
                      InkWell(
                        onTap: () {
                          HapticService.lightClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : const Color(0xFFEDF2F7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.grid_view_rounded, size: 14, color: isDark ? AppColors.primaryLight : AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'All Tools (18+)',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Thin Scientific toggle pill
                      InkWell(
                        onTap: () => calc.toggleScientific(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: calc.isScientificExpanded
                                ? (isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.15))
                                : (isDark ? AppColors.darkCard : const Color(0xFFEDF2F7)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: calc.isScientificExpanded
                                  ? AppColors.primaryLight
                                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            'fx',
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: calc.isScientificExpanded
                                  ? AppColors.primaryLight
                                  : (isDark ? Colors.white60 : Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // History button with badge
                  Stack(
                    children: [
                      IconButton(
                        tooltip: 'Smart Tape / History',
                        icon: const Icon(Icons.history_rounded, size: 22),
                        onPressed: () => HistorySheet.show(context),
                      ),
                      if (calc.history.isNotEmpty)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 6, minHeight: 6),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Calculation Display Area (Modern Geometric Typography)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Modern Crisp Active Expression
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          calc.expression,
                          style: GoogleFonts.outfit(
                            fontSize: 58,
                            fontWeight: FontWeight.w400, // Clean, legible geometric numeral
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Clear Live Result Preview
                      if (calc.liveResult.isNotEmpty)
                        Text(
                          '= ${calc.liveResult}',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                            color: AppColors.primaryLight,
                          ),
                        )
                      else
                        const SizedBox(height: 31),
                    ],
                  ),
                ),
              ),
            ),

            // Keypad Area (Seamless edge-to-edge design)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Expandable Scientific Drawer (Thin & Delicate)
                  if (calc.isScientificExpanded) ...[
                    Row(
                      children: [
                        CalcButton(
                          text: 'sin',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('sin('),
                        ),
                        CalcButton(
                          text: 'cos',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('cos('),
                        ),
                        CalcButton(
                          text: 'tan',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('tan('),
                        ),
                        CalcButton(
                          text: 'ln',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('ln('),
                        ),
                        CalcButton(
                          text: 'log',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('log('),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CalcButton(
                          text: '√',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.appendScientificFunction('sqrt('),
                        ),
                        CalcButton(
                          text: '^',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.append('^'),
                        ),
                        CalcButton(
                          text: 'π',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.append('π'),
                        ),
                        CalcButton(
                          text: '(',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.append('('),
                        ),
                        CalcButton(
                          text: ')',
                          type: CalcButtonType.scientific,
                          onTap: () => calc.append(')'),
                        ),
                      ],
                    ),
                  ],

                  // Standard 4x5 Keypad (Thin & Floating)
                  // Row 1
                  Row(
                    children: [
                      CalcButton(
                        text: 'AC',
                        type: CalcButtonType.action,
                        onTap: () => calc.clear(),
                      ),
                      CalcButton(
                        text: '( )',
                        type: CalcButtonType.action,
                        onTap: () {
                          if (calc.rawExpression.contains('(') && !calc.rawExpression.contains(')')) {
                            calc.append(')');
                          } else {
                            calc.append('(');
                          }
                        },
                      ),
                      CalcButton(
                        text: '%',
                        type: CalcButtonType.action,
                        onTap: () => calc.append('%'),
                      ),
                      CalcButton(
                        text: '÷',
                        type: CalcButtonType.operator,
                        onTap: () => calc.append('÷'),
                      ),
                    ],
                  ),

                  // Row 2
                  Row(
                    children: [
                      CalcButton(text: '7', onTap: () => calc.append('7')),
                      CalcButton(text: '8', onTap: () => calc.append('8')),
                      CalcButton(text: '9', onTap: () => calc.append('9')),
                      CalcButton(
                        text: '×',
                        type: CalcButtonType.operator,
                        onTap: () => calc.append('×'),
                      ),
                    ],
                  ),

                  // Row 3
                  Row(
                    children: [
                      CalcButton(text: '4', onTap: () => calc.append('4')),
                      CalcButton(text: '5', onTap: () => calc.append('5')),
                      CalcButton(text: '6', onTap: () => calc.append('6')),
                      CalcButton(
                        text: '−',
                        type: CalcButtonType.operator,
                        onTap: () => calc.append('-'),
                      ),
                    ],
                  ),

                  // Row 4
                  Row(
                    children: [
                      CalcButton(text: '1', onTap: () => calc.append('1')),
                      CalcButton(text: '2', onTap: () => calc.append('2')),
                      CalcButton(text: '3', onTap: () => calc.append('3')),
                      CalcButton(
                        text: '+',
                        type: CalcButtonType.operator,
                        onTap: () => calc.append('+'),
                      ),
                    ],
                  ),

                  // Row 5
                  Row(
                    children: [
                      CalcButton(text: '0', onTap: () => calc.append('0')),
                      CalcButton(text: '.', onTap: () => calc.append('.')),
                      CalcButton(
                        text: '⌫',
                        type: CalcButtonType.action,
                        icon: const Icon(Icons.backspace_outlined, size: 20, color: AppColors.rose),
                        onTap: () => calc.delete(),
                        onLongPress: () => calc.clear(),
                      ),
                      CalcButton(
                        text: '=',
                        type: CalcButtonType.equals,
                        onTap: () {
                          final vault = context.read<VaultProvider>();
                          if (vault.isConfigured) {
                            final res = vault.unlock(calc.rawExpression);
                            if (res != VaultUnlockResult.failed) {
                              calc.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const VaultHomeScreen()),
                              );
                              return;
                            }
                          }
                          calc.equals();
                        },
                        onLongPress: () {
                          HapticService.mediumClick();
                          VaultSetupDialog.show(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
