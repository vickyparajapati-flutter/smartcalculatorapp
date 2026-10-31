import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
          // Original Price Input Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Original Price', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: fin.discountOriginalPrice.toStringAsFixed(0),
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
          const Text('Discount (%)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: discountOptions.map((rate) {
              final isSelected = fin.discountPercentage == rate;
              return ChoiceChip(
                label: Text('${rate.toStringAsFixed(0)}% Off'),
                selected: isSelected,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
                onSelected: (selected) {
                  if (selected) fin.updateDiscountPercentage(rate);
                },
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
            onChanged: (val) => fin.updateDiscountPercentage(val),
          ),
          const SizedBox(height: 8),

          // Additional Discount (e.g. Extra 10% coupon)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Additional Coupon Discount', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${fin.discountAdditionalPercentage.toStringAsFixed(0)} %',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.discountAdditionalPercentage.clamp(0.0, 50.0),
                    min: 0.0,
                    max: 50.0,
                    divisions: 50,
                    activeColor: AppColors.accent,
                    onChanged: (val) => fin.updateDiscountAdditionalPercentage(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Final Savings Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Final Discounted Price',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.finalDiscountedPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total You Save:', style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(
                      currencyFormatter.format(fin.totalDiscountSavings),
                      style: const TextStyle(
                        color: Color(0xFF4ADE80),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
