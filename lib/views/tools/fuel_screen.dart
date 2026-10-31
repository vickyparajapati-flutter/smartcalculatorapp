import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/tools_provider.dart';

class FuelScreen extends StatelessWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Mileage & Trip Cost')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cost Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFCA8A04), Color(0xFFEAB308)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Estimated Trip Fuel Cost', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormatter.format(tools.totalTripFuelCost),
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Fuel Needed', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('${tools.totalFuelNeededLiters.toStringAsFixed(1)} Liters',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.white24),
                      Column(
                        children: [
                          const Text('Cost / Km', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(currencyFormatter.format(tools.costPerKm),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
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
                    TextFormField(
                      initialValue: tools.fuelDistanceKm.toStringAsFixed(0),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Trip Distance (km)'),
                      onChanged: (v) => tools.updateFuelData(distance: double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: tools.fuelEfficiencyKmpl.toStringAsFixed(1),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Vehicle Mileage / Efficiency (km/L)'),
                      onChanged: (v) => tools.updateFuelData(mileage: double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: tools.fuelPricePerLiter.toStringAsFixed(1),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Fuel Price per Liter (₹)'),
                      onChanged: (v) => tools.updateFuelData(price: double.tryParse(v) ?? 0),
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
