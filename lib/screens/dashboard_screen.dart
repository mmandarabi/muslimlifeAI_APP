import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/screens/analytics_screen.dart';
import 'package:muslim_life_ai_demo/screens/community_screen.dart';
import 'package:muslim_life_ai_demo/screens/home_tab.dart';
import 'package:muslim_life_ai_demo/screens/prayer_times_screen.dart';
import 'package:muslim_life_ai_demo/screens/qibla_screen.dart';
import 'package:muslim_life_ai_demo/screens/quran_home_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:muslim_life_ai_demo/widgets/grid_painter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    QuranHomeScreen(),
    CommunityScreen(),
    AnalyticsScreen(),
    QiblaScreen(),
    PrayerTimesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient (Subtle)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.5, -0.5),
                  radius: 1.2,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    AppColors.background,
                  ],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ),
          
          // Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(opacity: 0.03, spacing: 60),
            ),
          ),
          
          // Main Content
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(LucideIcons.house, 0),
              _buildNavItem(LucideIcons.book_open, 1),
              _buildNavItem(LucideIcons.users, 2),
              _buildNavItem(LucideIcons.trending_up, 3),
              _buildNavItem(LucideIcons.compass, 4),
              _buildNavItem(LucideIcons.calendar_clock, 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.white54,
          size: 24,
        ),
      ),
    );
  }
}

