import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      categoryColor = AppColors.amber;
    } else if (bmiResult.bmi < 25.0) {
      categoryColor = AppColors.teal;
    } else if (bmiResult.bmi < 30.0) {
      categoryColor = AppColors.orange;
    } else {
      categoryColor = AppColors.danger;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // BMI Result Banner (Ultra-Thin Minimalist)
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BODY MASS INDEX (BMI)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bmiResult.bmi.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                    color: categoryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    bmiResult.category,
                    style: GoogleFonts.inter(
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  bmiResult.tip,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
                const SizedBox(height: 12),
                Text(
                  'Ideal Weight: ${bmiResult.idealMinWeight.toStringAsFixed(1)} kg − ${bmiResult.idealMaxWeight.toStringAsFixed(1)} kg',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                      Text('Height', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400)),
                      Text(
                        '${util.heightCm.toStringAsFixed(0)} cm (${(util.heightCm / 30.48).toStringAsFixed(1)} ft)',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.cyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: util.heightCm.clamp(90.0, 240.0),
                    min: 90.0,
                    max: 240.0,
                    divisions: 150,
                    activeColor: AppColors.cyan,
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
                      Text('Weight', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400)),
                      Text(
                        '${util.weightKg.toStringAsFixed(1)} kg (${(util.weightKg * 2.20462).toStringAsFixed(1)} lbs)',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.cyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: util.weightKg.clamp(20.0, 200.0),
                    min: 20.0,
                    max: 200.0,
                    divisions: 180,
                    activeColor: AppColors.cyan,
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
