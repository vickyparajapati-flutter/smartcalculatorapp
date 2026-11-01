import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
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
          // Total Gross Result Banner (Thin Luxury Card)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.6,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL GROSS AMOUNT',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.totalGstAmount),
                  style: GoogleFonts.outfit(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Base Net Price', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.netGstAmount),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total GST (${fin.gstRate.toStringAsFixed(0)}%)', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.calculatedGstTax),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.primaryLight : AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Exclusive vs Inclusive Toggle (Sleek Pills)
          Row(
            children: [
              Expanded(
                child: _buildToggleOption(
                  label: '+ GST (Exclusive)',
                  isSelected: !fin.isGstInclusive,
                  onTap: () => fin.toggleGstInclusive(false),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleOption(
                  label: '− GST (Inclusive)',
                  isSelected: fin.isGstInclusive,
                  onTap: () => fin.toggleGstInclusive(true),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Initial Amount', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: fin.gstAmount.toStringAsFixed(0),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      prefixText: '₹ ',
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
          const SizedBox(height: 16),

          // Rate Selector Chips (Thin Minimalist Pills)
          Text(
            'SELECT GST RATE',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rates.map((rate) {
              final isSelected = fin.gstRate == rate;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      fin.updateGstRate(rate);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.primaryLight.withValues(alpha: 0.18) : AppColors.primary.withValues(alpha: 0.15))
                            : (isDark ? AppColors.darkCard : const Color(0xFFEDF2F7)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? (isDark ? AppColors.primaryLight : AppColors.primary) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isSelected ? 1.0 : 0.6,
                        ),
                      ),
                      child: Text(
                        '${rate.toStringAsFixed(0)}%',
                        style: GoogleFonts.outfit(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? (isDark ? AppColors.primaryLight : AppColors.primary) : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Tax Split Breakdown (CGST & SGST)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'CGST (${(fin.gstRate / 2).toStringAsFixed(1)}%)',
                    currencyFormatter.format(fin.cgst),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'SGST (${(fin.gstRate / 2).toStringAsFixed(1)}%)',
                    currencyFormatter.format(fin.sgst),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primaryLight.withValues(alpha: 0.18) : AppColors.primary.withValues(alpha: 0.15))
              : (isDark ? AppColors.darkCard : const Color(0xFFEDF2F7)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? (isDark ? AppColors.primaryLight : AppColors.primary) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.0 : 0.6,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? (isDark ? AppColors.primaryLight : AppColors.primary) : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 13.5, color: Colors.grey)),
        Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
