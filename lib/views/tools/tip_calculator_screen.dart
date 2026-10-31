import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/tools_provider.dart';

class TipCalculatorScreen extends StatelessWidget {
  const TipCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final tipOptions = [0.0, 5.0, 10.0, 15.0, 20.0];

    return Scaffold(
      appBar: AppBar(title: const Text('Tip & Bill Splitter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Per Person Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Total Per Person', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormatter.format(tools.totalPerPerson),
                    style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Tip per person', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            currencyFormatter.format(tools.tipPerPerson),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.white24),
                      Column(
                        children: [
                          const Text('Total Bill + Tip', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            currencyFormatter.format(tools.totalBillWithTip),
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

            // Bill Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Bill Amount', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: tools.tipBillAmount.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(top: 8, left: 12),
                          child: Text('₹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onChanged: (val) => tools.updateTipBill(double.tryParse(val) ?? 0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tip Selection Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tip Percentage', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('${tools.tipPercentage.toStringAsFixed(0)} %',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.rose)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: tipOptions.map((tip) {
                        final isSelected = tools.tipPercentage == tip;
                        return ChoiceChip(
                          label: Text('${tip.toStringAsFixed(0)}%'),
                          selected: isSelected,
                          selectedColor: AppColors.rose,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                          onSelected: (selected) {
                            if (selected) tools.updateTipPercentage(tip);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Split Count Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Split between', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('${tools.tipSplitPeople} people',
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          icon: const Icon(Icons.remove),
                          onPressed: () => tools.updateTipSplitPeople(tools.tipSplitPeople - 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${tools.tipSplitPeople}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.add),
                          onPressed: () => tools.updateTipSplitPeople(tools.tipSplitPeople + 1),
                        ),
                      ],
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
