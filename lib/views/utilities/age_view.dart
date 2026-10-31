import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/utility_provider.dart';

class AgeView extends StatelessWidget {
  const AgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final util = context.watch<UtilityProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final age = util.ageResult;
    final dateFormatter = DateFormat('dd MMMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Birth Date Selector Card
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.cake_rounded, color: Colors.white),
              ),
              title: const Text('Date of Birth', style: TextStyle(fontSize: 13, color: Colors.grey)),
              subtitle: Text(
                dateFormatter.format(util.birthDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: FilledButton.tonal(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: util.birthDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    util.updateBirthDate(picked);
                  }
                },
                child: const Text('Change'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Primary Age Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Your Current Age',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAgeUnit(age.years.toString(), 'Years'),
                    Container(height: 36, width: 1, color: Colors.white24),
                    _buildAgeUnit(age.months.toString(), 'Months'),
                    Container(height: 36, width: 1, color: Colors.white24),
                    _buildAgeUnit(age.days.toString(), 'Days'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Next Birthday Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Text('🎂', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Birthday',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Coming in ${age.nextBirthdayDays} days on a ${age.nextBirthdayDayOfWeek}!',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Summary Stats Grid
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Months', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          '${age.totalMonths}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Days', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          '${age.totalDays}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
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

  Widget _buildAgeUnit(String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
