import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/calculator_provider.dart';
import '../../../models/calculation_history.dart';

class HistorySheet extends StatelessWidget {
  const HistorySheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calcProvider = context.watch<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final history = calcProvider.history;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                    const SizedBox(width: 10),
                    const Text(
                      'Smart Tape & History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (history.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${history.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (history.isNotEmpty)
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Share All as Statement',
                        icon: const Icon(Icons.share_rounded, size: 20),
                        onPressed: () => calcProvider.shareAllHistory(),
                      ),
                      IconButton(
                        tooltip: 'Clear History',
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.danger),
                        onPressed: () => _confirmClear(context, calcProvider),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // History list
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No calculations yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Perform a calculation to save & add notes',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: history.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return _HistoryCard(
                        item: item,
                        onUseResult: () {
                          calcProvider.reuseCalculation(item);
                          Navigator.pop(context);
                        },
                        onShare: () => calcProvider.shareHistoryReceipt(item),
                        onEditLabel: () => _showEditLabelDialog(context, calcProvider, item),
                        onDelete: () => calcProvider.deleteHistoryItem(item.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, CalculatorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This will delete all saved calculations and notes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showEditLabelDialog(
      BuildContext context, CalculatorProvider provider, CalculationHistory item) {
    final controller = TextEditingController(text: item.label ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note / Label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.expression} = ${item.result}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Rent, Groceries, Electricity bill...',
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              provider.updateHistoryLabel(item.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final CalculationHistory item;
  final VoidCallback onUseResult;
  final VoidCallback onShare;
  final VoidCallback onEditLabel;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.item,
    required this.onUseResult,
    required this.onShare,
    required this.onEditLabel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.6,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top note row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onEditLabel,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.label != null && item.label!.isNotEmpty
                            ? Icons.label_rounded
                            : Icons.add_circle_outline_rounded,
                        size: 14,
                        color: item.label != null ? AppColors.accent : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.label != null && item.label!.isNotEmpty
                            ? item.label!
                            : 'Add note / label',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: item.label != null ? AppColors.accent : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                _formatTime(item.timestamp),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Expression
          Text(
            item.expression,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),

          // Result & Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '= ${item.result}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Use in Calculator',
                    icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                    onPressed: onUseResult,
                  ),
                  IconButton(
                    tooltip: 'Share Receipt',
                    icon: const Icon(Icons.share_outlined, size: 18),
                    onPressed: onShare,
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

