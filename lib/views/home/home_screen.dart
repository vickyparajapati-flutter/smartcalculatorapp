import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../calculator/calculator_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../financial/financial_screen.dart';
import '../utilities/utilities_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalculatorScreen(),
    const DashboardScreen(),
    const FinancialScreen(),
    const UtilitiesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          HapticService.selectionClick();
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        indicatorColor: isDark ? AppColors.primary.withValues(alpha: 0.18) : AppColors.primary.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate_rounded, color: isDark ? AppColors.primaryLight : AppColors.primary),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded, color: isDark ? AppColors.primaryLight : AppColors.primary),
            label: 'All Tools (18+)',
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance_rounded, color: isDark ? AppColors.primaryLight : AppColors.primary),
            label: 'Finance',
          ),
          NavigationDestination(
            icon: const Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets_rounded, color: isDark ? AppColors.primaryLight : AppColors.primary),
            label: 'Utilities',
          ),
        ],
      ),
    );
  }
}
