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
        backgroundColor: AppColors.darkBackground,
        indicatorColor: AppColors.primary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined, color: Color(0xFF94A3B8)),
            selectedIcon: Icon(Icons.calculate_rounded, color: Colors.white),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined, color: Color(0xFF94A3B8)),
            selectedIcon: Icon(Icons.grid_view_rounded, color: Colors.white),
            label: 'All Tools (18+)',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined, color: Color(0xFF94A3B8)),
            selectedIcon: Icon(Icons.account_balance_rounded, color: Colors.white),
            label: 'Finance',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined, color: Color(0xFF94A3B8)),
            selectedIcon: Icon(Icons.widgets_rounded, color: Colors.white),
            label: 'Utilities',
          ),
        ],
      ),
    );
  }
}
