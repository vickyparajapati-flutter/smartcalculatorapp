import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../providers/financial_provider.dart';

class DiscountView extends StatelessWidget {
  const DiscountView({super.key});

  @override
  Widget build(BuildContext context) {
    final fin = context.watch<FinancialProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final discountOptions = [10.0, 20.0, 30.0, 40.0, 50.0, 70.0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Final Price Card (Ultra-Thin Minimalist)
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
                  'FINAL DISCOUNTED PRICE',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.finalDiscountedPrice),
                  style: GoogleFonts.outfit(
                    fontSize: 40,
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
                        Text('Original Price', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.discountOriginalPrice),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Savings', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.totalDiscountSavings),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.emerald)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Original Price Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Original Price', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: fin.discountOriginalPrice.toStringAsFixed(0),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(prefixText: '₹ '),
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null && parsed >= 0) {
                        fin.updateDiscountOriginalPrice(parsed);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Primary Discount Quick Chips
          Text(
            'DISCOUNT PERCENTAGE',
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
            children: discountOptions.map((rate) {
              final isSelected = fin.discountPercentage == rate;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      fin.updateDiscountPercentage(rate);
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
                          fontSize: 13,
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
          const SizedBox(height: 12),

          // Custom Discount Slider
          Slider(
            value: fin.discountPercentage.clamp(0.0, 99.0),
            min: 0.0,
            max: 99.0,
            divisions: 99,
            activeColor: isDark ? AppColors.primaryLight : AppColors.primary,
            onChanged: (val) => fin.updateDiscountPercentage(val),
          ),
          const SizedBox(height: 12),

          // Additional Discount (Coupon) Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Extra Coupon Discount', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      Text(
                        '${fin.discountAdditionalPercentage.toStringAsFixed(0)} %',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.rose),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.discountAdditionalPercentage.clamp(0.0, 50.0),
                    min: 0.0,
                    max: 50.0,
                    divisions: 50,
                    activeColor: AppColors.rose,
                    onChanged: (val) => fin.updateDiscountAdditionalPercentage(val),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
