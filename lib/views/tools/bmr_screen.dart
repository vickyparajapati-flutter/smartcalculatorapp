import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tools_provider.dart';

class BmrScreen extends StatelessWidget {
  const BmrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('BMR & Calorie Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Daily Calorie Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Daily Maintenance Calories', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    '${tools.dailyCaloriesMaintenance.round()} kcal',
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Base BMR', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('${tools.bmr.round()} kcal',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.white24),
                      Column(
                        children: [
                          const Text('Weight Loss', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('${tools.dailyCaloriesWeightLoss.round()} kcal',
                              style: const TextStyle(color: Color(0xFFFEF08A), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gender Segmented Button
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(value: true, label: Text('Male 👨'), icon: Icon(Icons.male_rounded)),
                ButtonSegment<bool>(value: false, label: Text('Female 👩'), icon: Icon(Icons.female_rounded)),
              ],
              selected: {tools.isMale},
              onSelectionChanged: (val) => tools.setBmrGender(val.first),
            ),
            const SizedBox(height: 16),

            // Inputs Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: tools.bmrWeightKg.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Weight (kg)'),
                            onChanged: (v) => tools.setBmrData(weight: double.tryParse(v) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: tools.bmrHeightCm.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Height (cm)'),
                            onChanged: (v) => tools.setBmrData(height: double.tryParse(v) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: tools.bmrAgeYears.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Age'),
                            onChanged: (v) => tools.setBmrData(age: int.tryParse(v) ?? 0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<double>(
                      initialValue: tools.activityMultiplier,
                      decoration: const InputDecoration(labelText: 'Activity Level'),
                      items: const [
                        DropdownMenuItem(value: 1.2, child: Text('Sedentary (Little or no exercise)')),
                        DropdownMenuItem(value: 1.375, child: Text('Lightly active (1-3 days/week)')),
                        DropdownMenuItem(value: 1.55, child: Text('Moderately active (3-5 days/week)')),
                        DropdownMenuItem(value: 1.725, child: Text('Very active (6-7 days/week)')),
                      ],
                      onChanged: (v) {
                        if (v != null) tools.setBmrData(multiplier: v);
                      },
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
