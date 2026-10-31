import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
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
          // Converted Result Banner (Ultra-Thin Minimalist)
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
                  '${util.inputValue} ${util.fromUnit} =',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _formatOutput(util.convertedValue),
                  style: GoogleFonts.inter(
                    fontSize: 44,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  util.toUnit,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Category Selector Pills (Thin & Never Clipping)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: util.availableCategories.map((cat) {
                final isSelected = util.selectedUnitCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      util.setCategory(cat);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.primaryLight.withValues(alpha: 0.18) : AppColors.primary.withValues(alpha: 0.15))
                            : (isDark ? AppColors.darkCard : const Color(0xFFEDF2F7)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppColors.primaryLight : AppColors.primary)
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isSelected ? 1.0 : 0.6,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected
                              ? (isDark ? AppColors.primaryLight : AppColors.primary)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                    ),
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
                  Text('Enter Value', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: util.inputValue.toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                          return DropdownMenuItem(value: u, child: Text(u, style: GoogleFonts.inter(fontSize: 13)));
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
                          return DropdownMenuItem(value: u, child: Text(u, style: GoogleFonts.inter(fontSize: 13)));
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
