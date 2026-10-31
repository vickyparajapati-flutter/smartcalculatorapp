import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/tools_provider.dart';

class DateScreen extends StatelessWidget {
  const DateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = context.watch<ToolsProvider>();
    final df = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Date & Days Difference')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Days Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Difference', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    '${tools.totalDaysBetween} Days',
                    style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${tools.totalWeeksBetween} Weeks ${tools.remainingDaysAfterWeeks > 0 ? "and ${tools.remainingDaysAfterWeeks} Days" : ""}',
                    style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Pickers
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('From Date', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      subtitle: Text(df.format(tools.dateFrom),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.calendar_today_rounded),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tools.dateFrom,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          tools.updateDateRange(picked, tools.dateTo);
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('To Date', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      subtitle: Text(df.format(tools.dateTo),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.calendar_month_rounded),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tools.dateTo,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          tools.updateDateRange(tools.dateFrom, picked);
                        }
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

