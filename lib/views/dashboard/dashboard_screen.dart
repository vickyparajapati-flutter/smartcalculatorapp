import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../models/calculator_item.dart';
import '../financial/gst_view.dart';
import '../financial/emi_view.dart';
import '../financial/sip_view.dart';
import '../financial/discount_view.dart';
import '../utilities/bmi_view.dart';
import '../utilities/age_view.dart';
import '../utilities/unit_view.dart';
import '../tools/percentage_calculator_screen.dart';
import '../tools/tip_calculator_screen.dart';
import '../tools/unit_price_screen.dart';
import '../tools/salary_screen.dart';
import '../tools/bmr_screen.dart';
import '../tools/water_screen.dart';
import '../tools/fuel_screen.dart';
import '../tools/date_screen.dart';
import '../tools/currency_screen.dart';
import '../tools/gst_invoice_screen.dart';
import '../vault/vault_setup_dialog.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int index)? onSwitchTab;

  const DashboardScreen({super.key, this.onSwitchTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchQuery = '';
  CalculatorCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredItems = CalculatorItem.allItems.where((item) {
      if (item.id == 'simple_calc') return false; // Simple calc is the main tab
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Calculators (18+)'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search any calculator (GST, EMI, BMI, Tip...)...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: [
                _buildCategoryChip('All', null),
                _buildCategoryChip('💰 Finance', CalculatorCategory.finance),
                _buildCategoryChip('📐 Math', CalculatorCategory.math),
                _buildCategoryChip('🩺 Health', CalculatorCategory.health),
                _buildCategoryChip('⚡ Converters', CalculatorCategory.converter),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Tools Grid
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('No calculator found'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildToolCard(context, item, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, CalculatorCategory? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : null,
        ),
        onSelected: (_) {
          HapticService.selectionClick();
          setState(() => _selectedCategory = category);
        },
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, CalculatorItem item, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightClick();
          _openTool(context, item.id);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.2,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.primaryColor, item.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: item.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 22),
                  ),
                  if (item.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '★ HOT',
                        style: TextStyle(
                          color: AppColors.amber,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTool(BuildContext context, String toolId) {
    Widget? page;
    switch (toolId) {
      case 'currency_calc':
        page = const CurrencyScreen();
        break;
      case 'gst_invoice_calc':
        page = const GstInvoiceScreen();
        break;
      case 'vault_tool':
        VaultSetupDialog.show(context);
        return;
      case 'percentage_calc':
        page = const PercentageCalculatorScreen();
        break;
      case 'tip_calc':
        page = const TipCalculatorScreen();
        break;
      case 'unit_price_calc':
        page = const UnitPriceScreen();
        break;
      case 'salary_calc':
        page = const SalaryScreen();
        break;
      case 'bmr_calc':
        page = const BmrScreen();
        break;
      case 'water_calc':
        page = const WaterScreen();
        break;
      case 'fuel_calc':
        page = const FuelScreen();
        break;
      case 'date_calc':
        page = const DateScreen();
        break;
      case 'gst_calc':
        page = Scaffold(appBar: AppBar(title: const Text('GST Calculator')), body: const GstView());
        break;
      case 'emi_calc':
        page = Scaffold(appBar: AppBar(title: const Text('Loan & EMI')), body: const EmiView());
        break;
      case 'sip_calc':
        page = Scaffold(appBar: AppBar(title: const Text('SIP Calculator')), body: const SipView());
        break;
      case 'discount_calc':
        page = Scaffold(appBar: AppBar(title: const Text('Discount Calculator')), body: const DiscountView());
        break;
      case 'bmi_calc':
        page = Scaffold(appBar: AppBar(title: const Text('BMI Calculator')), body: const BmiView());
        break;
      case 'age_calc':
        page = Scaffold(appBar: AppBar(title: const Text('Age Calculator')), body: const AgeView());
        break;
      case 'unit_calc':
        page = Scaffold(appBar: AppBar(title: const Text('Unit Converter')), body: const UnitView());
        break;
    }

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    }
  }
}

