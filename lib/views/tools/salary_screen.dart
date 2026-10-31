import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/tools_provider.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Salary & Take-Home Pay')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // In-Hand Salary Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Net Monthly In-Hand Salary', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormatter.format(tools.netInHandSalary),
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Deductions', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            currencyFormatter.format(tools.totalDeductions),
                            style: const TextStyle(color: Color(0xFFFCA5A5), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.white24),
                      Column(
                        children: [
                          const Text('Annual In-Hand', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            currencyFormatter.format(tools.annualTakeHome),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gross Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gross Monthly Salary', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: tools.grossMonthlySalary.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(prefixText: '₹ '),
                      onChanged: (v) => tools.updateSalary(gross: double.tryParse(v) ?? 0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Deductions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Monthly Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: tools.pfDeduction.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'PF / EPF Deduction (₹)'),
                      onChanged: (v) => tools.updateSalary(pf: double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: tools.taxDeduction.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Income Tax / TDS (₹)'),
                      onChanged: (v) => tools.updateSalary(tax: double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: tools.otherDeduction.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Professional Tax / Others (₹)'),
                      onChanged: (v) => tools.updateSalary(other: double.tryParse(v) ?? 0),
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
