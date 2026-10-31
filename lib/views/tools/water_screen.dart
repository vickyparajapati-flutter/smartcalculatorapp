import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tools_provider.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Water Intake')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Water Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('💧 Recommended Daily Water', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '${tools.dailyWaterLiters.toStringAsFixed(1)} Liters',
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Approx ${tools.dailyWaterGlasses} glasses (250ml each)',
                    style: const TextStyle(color: Color(0xFFE0F2FE), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inputs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Body Weight', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('${tools.waterWeightKg.toStringAsFixed(0)} kg',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                      ],
                    ),
                    Slider(
                      value: tools.waterWeightKg.clamp(30.0, 160.0),
                      min: 30.0,
                      max: 160.0,
                      divisions: 130,
                      activeColor: const Color(0xFF0284C7),
                      onChanged: (val) => tools.setWaterData(val, tools.exerciseMinutes),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Workout / Exercise', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('${tools.exerciseMinutes} mins',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                      ],
                    ),
                    Slider(
                      value: tools.exerciseMinutes.toDouble().clamp(0.0, 180.0),
                      min: 0.0,
                      max: 180.0,
                      divisions: 18,
                      activeColor: const Color(0xFF0284C7),
                      onChanged: (val) => tools.setWaterData(tools.waterWeightKg, val.toInt()),
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
