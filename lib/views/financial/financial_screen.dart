import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'gst_view.dart';
import 'emi_view.dart';
import 'sip_view.dart';
import 'discount_view.dart';

class FinancialScreen extends StatelessWidget {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance Hub'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: [
              Tab(icon: Icon(Icons.receipt_rounded), text: 'GST Tax'),
              Tab(icon: Icon(Icons.account_balance_rounded), text: 'Loan EMI'),
              Tab(icon: Icon(Icons.trending_up_rounded), text: 'SIP Wealth'),
              Tab(icon: Icon(Icons.local_offer_rounded), text: 'Discount'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GstView(),
            EmiView(),
            SipView(),
            DiscountView(),
          ],
        ),
      ),
    );
  }
}
