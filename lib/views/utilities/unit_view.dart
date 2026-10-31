import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/utility_provider.dart';

class UnitView extends StatelessWidget {
  const UnitView({super.key});

  @override
  Widget build(BuildContext context) {
    final util = context.watch<UtilityProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: util.availableCategories.map((cat) {
                final isSelected = util.selectedUnitCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    onSelected: (selected) {
                      if (selected) util.setCategory(cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Input Value Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Value', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: util.inputValue.toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) {
                        util.setInputValue(parsed);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Unit Pickers & Swap Row
          Row(
            children: [
              // From Unit
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: util.availableUnits.contains(util.fromUnit) ? util.fromUnit : util.availableUnits.first,
                        isExpanded: true,
                        items: util.availableUnits.map((u) {
                          return DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 14)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) util.setFromUnit(val);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Swap Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: IconButton.filledTonal(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  onPressed: () => util.swapUnits(),
                ),
              ),

              // To Unit
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: util.availableUnits.contains(util.toUnit) ? util.toUnit : util.availableUnits.last,
                        isExpanded: true,
                        items: util.availableUnits.map((u) {
                          return DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 14)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) util.setToUnit(val);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Converted Result Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  '${util.inputValue} ${util.fromUnit} =',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _formatOutput(util.convertedValue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  util.toUnit,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatOutput(double val) {
    if (val.isNaN || val.isInfinite) return 'Error';
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    String s = val.toStringAsFixed(6);
    while (s.contains('.') && (s.endsWith('0') || s.endsWith('.'))) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }
}
