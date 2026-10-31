import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/tools_provider.dart';

class UnitPriceScreen extends StatelessWidget {
  const UnitPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final cheaper = tools.cheaperItem;

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Price Comparison')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Winner Banner
            if (cheaper != 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.emeraldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item ${cheaper == 1 ? "A" : "B"} is Cheaper!',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'You save approx ${tools.savingsPercent.toStringAsFixed(1)}% per unit!',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Item A Card
            _buildItemCard(
              context,
              name: 'Item A',
              isWinner: cheaper == 1,
              price: tools.itemAPrice,
              qty: tools.itemAQuantity,
              unitPrice: tools.unitPriceA,
              onPriceChanged: (p) => tools.updateItemA(p, tools.itemAQuantity),
              onQtyChanged: (q) => tools.updateItemA(tools.itemAPrice, q),
            ),
            const SizedBox(height: 16),

            // Item B Card
            _buildItemCard(
              context,
              name: 'Item B',
              isWinner: cheaper == 2,
              price: tools.itemBPrice,
              qty: tools.itemBQuantity,
              unitPrice: tools.unitPriceB,
              onPriceChanged: (p) => tools.updateItemB(p, tools.itemBQuantity),
              onQtyChanged: (q) => tools.updateItemB(tools.itemBPrice, q),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context, {
    required String name,
    required bool isWinner,
    required double price,
    required double qty,
    required double unitPrice,
    required ValueChanged<double> onPriceChanged,
    required ValueChanged<double> onQtyChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isWinner ? AppColors.emerald : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (isWinner)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'BEST VALUE',
                      style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: price.toStringAsFixed(0),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Price (₹)'),
                    onChanged: (v) => onPriceChanged(double.tryParse(v) ?? 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: qty.toStringAsFixed(0),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantity / Weight'),
                    onChanged: (v) => onQtyChanged(double.tryParse(v) ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Cost per unit: ₹${unitPrice.toStringAsFixed(4)}',
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
