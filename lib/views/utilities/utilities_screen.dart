import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'bmi_view.dart';
import 'age_view.dart';
import 'unit_view.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Utilities'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: [
              Tab(icon: Icon(Icons.favorite_rounded), text: 'BMI Health'),
              Tab(icon: Icon(Icons.cake_rounded), text: 'Age Calc'),
              Tab(icon: Icon(Icons.sync_alt_rounded), text: 'Unit Converter'),
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

