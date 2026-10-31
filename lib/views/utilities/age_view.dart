import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.cake_outlined, color: AppColors.cyan, size: 20),
              ),
              title: Text('Date of Birth', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              subtitle: Text(
                dateFormatter.format(util.birthDate),
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: TextButton(
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
                child: Text('Change', style: GoogleFonts.inter(color: AppColors.cyan, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Primary Age Banner (Ultra-Thin Minimalist)
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
              children: [
                Text(
                  'CURRENT AGE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAgeUnit(age.years.toString(), 'Years'),
                    Container(height: 30, width: 0.6, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    _buildAgeUnit(age.months.toString(), 'Months'),
                    Container(height: 30, width: 0.6, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    _buildAgeUnit(age.days.toString(), 'Days'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Next Birthday Card (Thin Minimalist)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFFEF3C7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.amber.withValues(alpha: 0.3) : Colors.amber.shade200,
                width: 0.6,
              ),
            ),
            child: Row(
              children: [
                const Text('🎂', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Birthday',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        age.nextBirthdayDays == 0
                            ? 'Today is your Birthday! 🎉 Happy Birthday!'
                            : 'In ${age.nextBirthdayDays} days on a ${age.nextBirthdayDayOfWeek}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

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
                        Text('Total Months', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${age.totalMonths}',
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w300),
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
                        Text('Total Days', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${age.totalDays}',
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w300),
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
          style: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w200,
            color: AppColors.cyan,
          ),
        ),
        Text(
          unit,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
