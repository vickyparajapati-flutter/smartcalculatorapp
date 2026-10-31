import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/utility_provider.dart';

class BmiView extends StatelessWidget {
  const BmiView({super.key});

  @override
  Widget build(BuildContext context) {
    final util = context.watch<UtilityProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bmiResult = util.bmiResult;

    Color categoryColor;
    if (bmiResult.bmi < 18.5) {
      categoryColor = Colors.orange;
    } else if (bmiResult.bmi < 25.0) {
      categoryColor = const Color(0xFF10B981); // Emerald
    } else if (bmiResult.bmi < 30.0) {
      categoryColor = Colors.amber;
    } else {
      categoryColor = AppColors.danger;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // BMI Result Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [Colors.white, const Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: categoryColor.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Column(
              children: [
                const Text('Body Mass Index (BMI)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  bmiResult.bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bmiResult.category,
                    style: TextStyle(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  bmiResult.tip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Ideal Weight: ${bmiResult.idealMinWeight.toStringAsFixed(1)} kg - ${bmiResult.idealMaxWeight.toStringAsFixed(1)} kg',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Height Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Height', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${util.heightCm.toStringAsFixed(0)} cm (${(util.heightCm / 30.48).toStringAsFixed(1)} ft)',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: util.heightCm.clamp(90.0, 240.0),
                    min: 90.0,
                    max: 240.0,
                    divisions: 150,
                    onChanged: (val) => util.updateHeight(val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Weight Slider Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Weight', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${util.weightKg.toStringAsFixed(1)} kg (${(util.weightKg * 2.20462).toStringAsFixed(1)} lbs)',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: util.weightKg.clamp(20.0, 200.0),
                    min: 20.0,
                    max: 200.0,
                    divisions: 180,
                    onChanged: (val) => util.updateWeight(val),
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
