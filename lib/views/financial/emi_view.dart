import 'package:flutter/material.dart';
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
          // EMI Result Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Monthly EMI',
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.monthlyEmi),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Principal', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(fin.loanPrincipal),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(height: 24, width: 1, color: Colors.white24),
                    Column(
                      children: [
                        const Text('Total Interest', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(fin.totalLoanInterest),
                          style: const TextStyle(color: Color(0xFFFDE047), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
                      const Text('Loan Amount', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        currencyFormatter.format(fin.loanPrincipal),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanPrincipal.clamp(10000, 10000000),
                    min: 10000,
                    max: 10000000,
                    divisions: 100,
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
                      const Text('Interest Rate (p.a.)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${fin.loanAnnualRate.toStringAsFixed(1)} %',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanAnnualRate.clamp(1.0, 30.0),
                    min: 1.0,
                    max: 30.0,
                    divisions: 58,
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
                      const Text('Loan Tenure', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${(fin.loanTenureMonths / 12).toStringAsFixed(1)} Yrs (${fin.loanTenureMonths} Mos)',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.loanTenureMonths.toDouble().clamp(6, 360),
                    min: 6,
                    max: 360,
                    divisions: 59,
                    onChanged: (val) => fin.updateLoanTenureMonths(val.toInt()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Total Payment Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount Payable:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  currencyFormatter.format(fin.totalLoanPayment),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
