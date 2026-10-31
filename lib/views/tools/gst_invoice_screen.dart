import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';

class GstInvoiceScreen extends StatefulWidget {
  const GstInvoiceScreen({super.key});

  @override
  State<GstInvoiceScreen> createState() => _GstInvoiceScreenState();
}

class _GstInvoiceScreenState extends State<GstInvoiceScreen> {
  final _shopController = TextEditingController(text: 'My Business / Shop');
  final _customerController = TextEditingController(text: 'Valued Customer');
  final _itemController = TextEditingController(text: 'Products / Services');
  double _price = 2000.0;
  int _qty = 1;
  double _gstRate = 18.0;

  double get subtotal => _price * _qty;
  double get cgst => (subtotal * (_gstRate / 2)) / 100;
  double get sgst => (subtotal * (_gstRate / 2)) / 100;
  double get totalTax => cgst + sgst;
  double get grandTotal => subtotal + totalTax;

  final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Invoice Bill Maker'),
        actions: [
          IconButton(
            tooltip: 'Share Invoice',
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareInvoice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview Bill Receipt Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCard
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _shopController.text.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.8),
                    ),
                  ),
                  const Center(
                    child: Text('TAX INVOICE RECEIPT', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer: ${_customerController.text}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(DateFormat('dd/MM/yyyy').format(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_itemController.text} (x$_qty)'),
                      Text(currencyFormatter.format(subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CGST (${(_gstRate / 2).toStringAsFixed(1)}%)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(currencyFormatter.format(cgst), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SGST (${(_gstRate / 2).toStringAsFixed(1)}%)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(currencyFormatter.format(sgst), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        currencyFormatter.format(grandTotal),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Fields Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _shopController,
                      decoration: const InputDecoration(labelText: 'Shop / Seller Name'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customerController,
                      decoration: const InputDecoration(labelText: 'Customer Name'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(labelText: 'Item / Service Description'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _price.toStringAsFixed(0),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Unit Price (₹)'),
                            onChanged: (v) => setState(() => _price = double.tryParse(v) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: _qty.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Quantity'),
                            onChanged: (v) => setState(() => _qty = int.tryParse(v) ?? 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [3.0, 5.0, 12.0, 18.0, 28.0].map((rate) {
                        final isSelected = _gstRate == rate;
                        return ChoiceChip(
                          label: Text('${rate.toStringAsFixed(0)}%'),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _gstRate = rate);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Share Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                icon: const Icon(Icons.share_rounded),
                label: const Text('Share Invoice via WhatsApp', style: TextStyle(fontSize: 16)),
                onPressed: _shareInvoice,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareInvoice() {
    HapticService.mediumClick();
    final buffer = StringBuffer();
    buffer.writeln('🧾 *TAX INVOICE / BILL*');
    buffer.writeln('--------------------------------');
    buffer.writeln('From: ${_shopController.text}');
    buffer.writeln('To: ${_customerController.text}');
    buffer.writeln('Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}');
    buffer.writeln('--------------------------------');
    buffer.writeln('Item: ${_itemController.text}');
    buffer.writeln('Qty: $_qty x ${currencyFormatter.format(_price)}');
    buffer.writeln('Subtotal: ${currencyFormatter.format(subtotal)}');
    buffer.writeln('CGST (${(_gstRate / 2).toStringAsFixed(1)}%): ${currencyFormatter.format(cgst)}');
    buffer.writeln('SGST (${(_gstRate / 2).toStringAsFixed(1)}%): ${currencyFormatter.format(sgst)}');
    buffer.writeln('--------------------------------');
    buffer.writeln('*GRAND TOTAL: ${currencyFormatter.format(grandTotal)}*');
    buffer.writeln('--------------------------------');
    buffer.writeln('Generated with Smart Calculator App');

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Tax Invoice from ${_shopController.text}',
      ),
    );
  }
}

