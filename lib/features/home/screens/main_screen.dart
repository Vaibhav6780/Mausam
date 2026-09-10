import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'home_screen.dart';
import '../../forecast/screens/forecast_screen.dart';
import '../../explore/screens/explore_screen.dart';
import '../../alerts/screens/alerts_list_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ForecastScreen(),
    const ExploreScreen(),
    const AlertsListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Allows the body to scroll behind the floating nav bar
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95), // Slight translucency for glass effect
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, Icons.wb_sunny_outlined, Icons.wb_sunny, 'Home'),
                _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today, 'Forecast'),
                _buildNavItem(2, Icons.explore_outlined, Icons.explore, 'Explore'),
                _buildNavItem(3, Icons.notifications_none_outlined, Icons.notifications, 'Alerts'),
                _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : unselectedIcon,
            color: isSelected ? AppColors.primaryNavy : AppColors.secondaryText,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primaryNavy : AppColors.secondaryText,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
