import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/financial_provider.dart';

class SipView extends StatelessWidget {
  const SipView({super.key});

  @override
  Widget build(BuildContext context) {
    final fin = context.watch<FinancialProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Total Wealth Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Expected Total Wealth',
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(fin.totalSipWealth),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Invested Amount', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(fin.totalSipInvested),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(height: 24, width: 1, color: Colors.white24),
                    Column(
                      children: [
                        const Text('Est. Returns', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(fin.totalSipReturns),
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
                      const Text('Monthly Investment', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        currencyFormatter.format(fin.sipMonthlyInvestment),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipMonthlyInvestment.clamp(500, 200000),
                    min: 500,
                    max: 200000,
                    divisions: 100,
                    activeColor: AppColors.secondary,
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
                      const Text('Expected Return (p.a.)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${fin.sipExpectedRate.toStringAsFixed(1)} %',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipExpectedRate.clamp(1.0, 30.0),
                    min: 1.0,
                    max: 30.0,
                    divisions: 58,
                    activeColor: AppColors.secondary,
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
                      const Text('Time Period (Years)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${fin.sipYears} Years',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  Slider(
                    value: fin.sipYears.toDouble().clamp(1, 40),
                    min: 1,
                    max: 40,
                    divisions: 39,
                    activeColor: AppColors.secondary,
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
