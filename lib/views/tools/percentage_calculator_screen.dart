import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/tools_provider.dart';

class PercentageCalculatorScreen extends StatelessWidget {
  const PercentageCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode 1: What is X% of Y?
            _buildSectionCard(
              context,
              title: 'What is X% of Y?',
              icon: Icons.pie_chart_outline_rounded,
              color: AppColors.violet,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          label: 'Percent (%)',
                          initial: tools.p1Percent.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP1Percent(double.tryParse(v) ?? 0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('of', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Expanded(
                        child: _buildNumberInput(
                          label: 'Total Value',
                          initial: tools.p1Total.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP1Total(double.tryParse(v) ?? 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildResultPill(
                    label: '${tools.p1Percent}% of ${tools.p1Total.toStringAsFixed(0)}',
                    result: tools.p1Result.toStringAsFixed(2),
                    color: AppColors.violet,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mode 2: X is what % of Y?
            _buildSectionCard(
              context,
              title: 'X is what % of Y?',
              icon: Icons.percent_rounded,
              color: AppColors.primary,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          label: 'Part (X)',
                          initial: tools.p2Part.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP2Part(double.tryParse(v) ?? 0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Expanded(
                        child: _buildNumberInput(
                          label: 'Whole (Y)',
                          initial: tools.p2Whole.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP2Whole(double.tryParse(v) ?? 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildResultPill(
                    label: '${tools.p2Part.toStringAsFixed(0)} is',
                    result: '${tools.p2Result.toStringAsFixed(2)} %',
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mode 3: % Increase or Decrease
            _buildSectionCard(
              context,
              title: 'Percentage Increase / Decrease',
              icon: Icons.trending_up_rounded,
              color: AppColors.emerald,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          label: 'From (Old)',
                          initial: tools.p3From.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP3From(double.tryParse(v) ?? 0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.arrow_forward_rounded, size: 20),
                      ),
                      Expanded(
                        child: _buildNumberInput(
                          label: 'To (New)',
                          initial: tools.p3To.toStringAsFixed(0),
                          onChanged: (v) => tools.updateP3To(double.tryParse(v) ?? 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildResultPill(
                    label: tools.p3ChangePercent >= 0 ? 'Increase' : 'Decrease',
                    result: '${tools.p3ChangePercent.abs().toStringAsFixed(2)} %',
                    color: tools.p3ChangePercent >= 0 ? AppColors.emerald : AppColors.danger,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({required String label, required String initial, required ValueChanged<String> onChanged}) {
    return TextFormField(
      initialValue: initial,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildResultPill({required String label, required String result, required Color color, required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
          Text(result, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
