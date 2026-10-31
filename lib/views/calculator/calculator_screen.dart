import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../providers/calculator_provider.dart';
import 'widgets/calc_button.dart';
import 'widgets/history_sheet.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Scientific toggle pill
                  FilterChip(
                    label: const Text('fx Scientific'),
                    selected: calc.isScientificExpanded,
                    onSelected: (_) => calc.toggleScientific(),
                    showCheckmark: false,
                    avatar: Icon(
                      Icons.functions_rounded,
                      size: 18,
                      color: calc.isScientificExpanded ? Colors.white : AppColors.primary,
                    ),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: calc.isScientificExpanded
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),

                  Row(
                    children: [
                      // Theme Switcher
                      IconButton(
                        tooltip: 'Toggle Theme',
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: isDark ? Colors.amber : Colors.indigo,
                        ),
                        onPressed: () => themeProvider.toggleTheme(),
                      ),

                      // History button with badge
                      Stack(
                        children: [
                          IconButton(
                            tooltip: 'Smart Tape / History',
                            icon: const Icon(Icons.history_rounded),
                            onPressed: () => HistorySheet.show(context),
                          ),
                          if (calc.history.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calculation Display Area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Active Expression
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          calc.expression,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Live Result Preview
                      if (calc.liveResult.isNotEmpty)
                        Text(
                          '= ${calc.liveResult}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
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

            const Divider(height: 1, thickness: 0.5),

            // Keypad Area
            Expanded(
              flex: calc.isScientificExpanded ? 6 : 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Expandable Scientific Drawer
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

                    // Standard 4x5 Keypad
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
                          type: CalcButtonType.operator,
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
                          type: CalcButtonType.operator,
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
                          text: '-',
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
                          icon: const Icon(Icons.backspace_outlined, size: 22, color: AppColors.danger),
                          onTap: () => calc.delete(),
                          onLongPress: () => calc.clear(),
                        ),
                        CalcButton(
                          text: '=',
                          type: CalcButtonType.equals,
                          onTap: () => calc.equals(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
