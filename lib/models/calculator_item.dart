import 'package:flutter/material.dart';

enum CalculatorCategory {
  finance,
  math,
  health,
  converter,
}

class CalculatorItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final CalculatorCategory category;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isPopular;

  const CalculatorItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.primaryColor,
    required this.secondaryColor,
    this.isPopular = false,
  });

  static const List<CalculatorItem> allItems = [
    // --- Math & Essentials ---
    CalculatorItem(
      id: 'simple_calc',
      title: 'Standard Calculator',
      subtitle: 'Basic & scientific math with tape',
      icon: Icons.calculate_rounded,
      category: CalculatorCategory.math,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF4F46E5),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'percentage_calc',
      title: 'Percentage Calculator',
      subtitle: 'X% of Y, % change & discount',
      icon: Icons.percent_rounded,
      category: CalculatorCategory.math,
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFF7C3AED),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'date_calc',
      title: 'Date & Days Calculator',
      subtitle: 'Days between dates & add/subtract days',
      icon: Icons.calendar_month_rounded,
      category: CalculatorCategory.math,
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF2563EB),
    ),
    CalculatorItem(
      id: 'unit_price_calc',
      title: 'Unit Price Comparison',
      subtitle: 'Find which pack or grocery deal is cheaper',
      icon: Icons.compare_arrows_rounded,
      category: CalculatorCategory.math,
      primaryColor: Color(0xFF0EA5E9),
      secondaryColor: Color(0xFF0284C7),
    ),

    // --- Finance & Money ---
    CalculatorItem(
      id: 'gst_calc',
      title: 'GST / Sales Tax',
      subtitle: 'CGST, SGST, Net & Gross price',
      icon: Icons.receipt_long_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF059669),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'emi_calc',
      title: 'Loan & EMI Calculator',
      subtitle: 'Home, car & personal loan schedule',
      icon: Icons.account_balance_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFFF59E0B),
      secondaryColor: Color(0xFFD97706),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'sip_calc',
      title: 'SIP & Mutual Funds',
      subtitle: 'Compound interest & wealth growth',
      icon: Icons.trending_up_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFF059669),
      secondaryColor: Color(0xFF047857),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'tip_calc',
      title: 'Tip & Bill Splitter',
      subtitle: 'Split restaurant bills per person with tip',
      icon: Icons.diversity_3_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFFDB2777),
    ),
    CalculatorItem(
      id: 'discount_calc',
      title: 'Discount & Sale',
      subtitle: 'Double discounts, coupons & savings',
      icon: Icons.local_offer_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFFF43F5E),
      secondaryColor: Color(0xFFE11D48),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'salary_calc',
      title: 'Salary & Take-Home Pay',
      subtitle: 'Gross to in-hand monthly salary',
      icon: Icons.payments_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFF14B8A6),
      secondaryColor: Color(0xFF0D9488),
    ),

    // --- Health & Lifestyle ---
    CalculatorItem(
      id: 'bmi_calc',
      title: 'BMI & Ideal Weight',
      subtitle: 'Body mass index & health target',
      icon: Icons.monitor_weight_rounded,
      category: CalculatorCategory.health,
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF059669),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'bmr_calc',
      title: 'BMR & Calorie Needs',
      subtitle: 'Basal metabolic rate & daily energy',
      icon: Icons.local_fire_department_rounded,
      category: CalculatorCategory.health,
      primaryColor: Color(0xFFF97316),
      secondaryColor: Color(0xFFEA580C),
    ),
    CalculatorItem(
      id: 'age_calc',
      title: 'Age & Birthday Countdown',
      subtitle: 'Exact age, months, days & next bday',
      icon: Icons.cake_rounded,
      category: CalculatorCategory.health,
      primaryColor: Color(0xFFA855F7),
      secondaryColor: Color(0xFF9333EA),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'water_calc',
      title: 'Daily Water Intake',
      subtitle: 'Hydration goal based on body weight',
      icon: Icons.water_drop_rounded,
      category: CalculatorCategory.health,
      primaryColor: Color(0xFF06B6D4),
      secondaryColor: Color(0xFF0891B2),
    ),

    // --- Converters & Utilities ---
    CalculatorItem(
      id: 'vault_tool',
      title: 'Secret Calculator Vault',
      subtitle: 'Type PIN & press = to unlock hidden photos & notes',
      icon: Icons.lock_outline_rounded,
      category: CalculatorCategory.converter,
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFBE123C),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'currency_calc',
      title: 'Currency Converter',
      subtitle: '30+ world currencies (USD, INR, EUR, AED...)',
      icon: Icons.currency_exchange_rounded,
      category: CalculatorCategory.converter,
      primaryColor: Color(0xFF059669),
      secondaryColor: Color(0xFF047857),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'gst_invoice_calc',
      title: 'GST Invoice & Bill Maker',
      subtitle: 'Generate printable tax receipts with CGST/SGST',
      icon: Icons.receipt_rounded,
      category: CalculatorCategory.finance,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF4F46E5),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'unit_calc',
      title: 'Unit Converter',
      subtitle: 'Length, weight, speed, temp & storage',
      icon: Icons.sync_alt_rounded,
      category: CalculatorCategory.converter,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF4F46E5),
      isPopular: true,
    ),
    CalculatorItem(
      id: 'fuel_calc',
      title: 'Fuel Mileage & Trip Cost',
      subtitle: 'Distance, fuel efficiency & travel cost',
      icon: Icons.local_gas_station_rounded,
      category: CalculatorCategory.converter,
      primaryColor: Color(0xFFEAB308),
      secondaryColor: Color(0xFFCA8A04),
    ),
  ];
}

