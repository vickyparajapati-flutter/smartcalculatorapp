import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'gst_view.dart';
import 'emi_view.dart';
import 'sip_view.dart';
import 'discount_view.dart';

class FinancialScreen extends StatelessWidget {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Finance Hub',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primaryLight,
            indicatorWeight: 2,
            dividerColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            labelColor: isDark ? AppColors.primaryLight : AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
            tabs: const [
              Tab(text: 'GST Tax'),
              Tab(text: 'Loan EMI'),
              Tab(text: 'SIP Wealth'),
              Tab(text: 'Discount & Sale'),
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
