import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/screens/analytics_screen.dart';
import 'package:muslim_life_ai_demo/screens/chat_screen.dart';
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
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = AppColors.getBackgroundColor(context);
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);
    final iconColorUnselected = isDark ? Colors.white54 : Colors.black38;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient (Subtle & Theme-Aware)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.2, -0.6),
                  radius: 1.5,
                  colors: [
                    accentColor,
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          
          // Grid Background (Brightness-Aware)
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                opacity: isDark ? 0.03 : 0.015, 
                spacing: 60,
                color: isDark ? Colors.white : Colors.black,
              ),
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
          sigma: 20,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(LucideIcons.house, 0, iconColorUnselected),
              _buildNavItem(LucideIcons.book_open, 1, iconColorUnselected),
              _buildNavItem(LucideIcons.users, 2, iconColorUnselected),
              // Special Chat Button
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.message_circle, color: AppColors.primary, size: 24),
                ),
              ),
              _buildNavItem(LucideIcons.trending_up, 3, iconColorUnselected),
              _buildNavItem(LucideIcons.compass, 4, iconColorUnselected),
              _buildNavItem(LucideIcons.calendar_clock, 5, iconColorUnselected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color unselectedColor) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : unselectedColor,
          size: 24,
        ),
      ),
    );
  }
}

