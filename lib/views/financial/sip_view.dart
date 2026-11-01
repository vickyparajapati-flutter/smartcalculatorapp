import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/financial_provider.dart';

class SipView extends StatelessWidget {
  const SipView({super.key});

  @override
  Widget build(BuildContext context) {
    final fin = context.watch<FinancialProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Total Wealth Card (Ultra-Thin Minimalist)
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
                  'EXPECTED TOTAL WEALTH',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.totalSipWealth),
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: AppColors.teal,
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
                        Text('Invested Amount', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.totalSipInvested),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Est. Wealth Gains', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.totalSipReturns),
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.teal)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Monthly Investment Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monthly Investment', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      Text(
                        currencyFormatter.format(fin.sipMonthlyInvestment),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.teal),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipMonthlyInvestment.clamp(500, 200000),
                    min: 500,
                    max: 200000,
                    divisions: 100,
                    activeColor: AppColors.teal,
                    onChanged: (val) => fin.updateSipMonthly(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Expected Return Rate Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Expected Return (p.a.)', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      Text(
                        '${fin.sipExpectedRate.toStringAsFixed(1)} %',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.teal),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipExpectedRate.clamp(1.0, 30.0),
                    min: 1.0,
                    max: 30.0,
                    divisions: 58,
                    activeColor: AppColors.teal,
                    onChanged: (val) => fin.updateSipRate(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Time Period Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Investment Tenure', style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      Text(
                        '${fin.sipYears} Years',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.teal),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipYears.toDouble().clamp(1, 40),
                    min: 1,
                    max: 40,
                    divisions: 39,
                    activeColor: AppColors.teal,
                    onChanged: (val) => fin.updateSipYears(val.toInt()),
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
