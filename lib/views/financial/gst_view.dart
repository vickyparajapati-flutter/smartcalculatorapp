import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/financial_provider.dart';

class GstView extends StatelessWidget {
  const GstView({super.key});

  @override
  Widget build(BuildContext context) {
    final fin = context.watch<FinancialProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    final rates = [3.0, 5.0, 12.0, 18.0, 28.0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Initial Amount', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: fin.gstAmount.toStringAsFixed(0),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 6, left: 12),
                        child: Text('₹', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null && parsed >= 0) {
                        fin.updateGstAmount(parsed);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Exclusive vs Inclusive Toggle
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                label: Text('GST Exclusive (+GST)'),
                icon: Icon(Icons.add_circle_outline),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text('GST Inclusive (-GST)'),
                icon: Icon(Icons.remove_circle_outline),
              ),
            ],
            selected: {fin.isGstInclusive},
            onSelectionChanged: (newSelection) {
              fin.toggleGstInclusive(newSelection.first);
            },
          ),
          const SizedBox(height: 16),

          // Quick GST Rate Chips
          const Text('Select GST Rate (%)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rates.map((rate) {
              final isSelected = fin.gstRate == rate;
              return ChoiceChip(
                label: Text('${rate.toStringAsFixed(0)}%'),
                selected: isSelected,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
                onSelected: (selected) {
                  if (selected) fin.updateGstRate(rate);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Results Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Net / Base Amount',
                  currencyFormatter.format(fin.netGstAmount),
                  isBold: false,
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  'CGST (${(fin.gstRate / 2).toStringAsFixed(1)}%)',
                  currencyFormatter.format(fin.cgst),
                  isBold: false,
                  color: Colors.grey,
                ),
                const SizedBox(height: 6),
                _buildSummaryRow(
                  'SGST (${(fin.gstRate / 2).toStringAsFixed(1)}%)',
                  currencyFormatter.format(fin.sgst),
                  isBold: false,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  'Total GST Tax',
                  currencyFormatter.format(fin.calculatedGstTax),
                  isBold: true,
                  color: AppColors.accent,
                ),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total Gross Price',
                  currencyFormatter.format(fin.totalGstAmount),
                  isBold: true,
                  fontSize: 22,
                  color: AppColors.primaryLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value,
      {bool isBold = false, double fontSize = 15, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

