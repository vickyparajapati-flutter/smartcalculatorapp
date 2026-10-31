import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'bmi_view.dart';
import 'age_view.dart';
import 'unit_view.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Daily Utilities',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.cyan,
            indicatorWeight: 2,
            dividerColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            labelColor: isDark ? AppColors.cyan : AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
            tabs: const [
              Tab(text: 'BMI Health'),
              Tab(text: 'Age & Birthday'),
              Tab(text: 'Unit Converter'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BmiView(),
            AgeView(),
            UnitView(),
          ],
        ),
      ),
    );
  }
}
