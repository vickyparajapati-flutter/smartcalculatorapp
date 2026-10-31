import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/financial_provider.dart';

class EmiView extends StatelessWidget {
  const EmiView({super.key});

  @override
  Widget build(BuildContext context) {
    final fin = context.watch<FinancialProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // EMI Result Banner (Ultra-Thin Luxury Card)
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
                  'MONTHLY EMI',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.monthlyEmi),
                  style: GoogleFonts.inter(
                    fontSize: 38,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                    color: AppColors.cyan,
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
                        Text('Principal Amount', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.loanPrincipal),
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Interest', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(currencyFormatter.format(fin.totalLoanInterest),
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.amber)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Loan Principal Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loan Amount', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400)),
                      Text(
                        currencyFormatter.format(fin.loanPrincipal),
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.cyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanPrincipal.clamp(10000, 10000000),
                    min: 10000,
                    max: 10000000,
                    divisions: 100,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => fin.updateLoanPrincipal(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Interest Rate Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Interest Rate (p.a.)', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400)),
                      Text(
                        '${fin.loanAnnualRate.toStringAsFixed(1)} %',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.cyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanAnnualRate.clamp(1.0, 30.0),
                    min: 1.0,
                    max: 30.0,
                    divisions: 58,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => fin.updateLoanRate(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tenure Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loan Tenure', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400)),
                      Text(
                        '${(fin.loanTenureMonths / 12).toStringAsFixed(1)} Yrs (${fin.loanTenureMonths} Mos)',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.cyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanTenureMonths.toDouble().clamp(6, 360),
                    min: 6,
                    max: 360,
                    divisions: 59,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => fin.updateLoanTenureMonths(val.toInt()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Total Payment Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount Payable', style: GoogleFonts.inter(color: Colors.grey, fontSize: 13)),
                  Text(
                    currencyFormatter.format(fin.totalLoanPayment),
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
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
