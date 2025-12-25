import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/screens/home_tab.dart';
import 'package:muslim_mind/screens/quran_home_screen.dart';
import 'package:muslim_mind/screens/hadith_screen.dart';
import 'package:muslim_mind/screens/community_screen.dart';
import 'package:muslim_mind/screens/chat_screen.dart';
import 'package:muslim_mind/screens/prayer_times_screen.dart';
import 'package:muslim_mind/screens/qibla_screen.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/widgets/expandable_audio_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  /// The Hub Screens (indices match the Home Tab 6-tile grid)
  /// Index 0: Home Hub
  /// Index 1: Quran Library
  /// Indices 2-5: Sub-features handled via the Hub logic
  late final List<Widget> _screens = [
    HomeTab(onNavigate: (index) => _onItemTapped(index)), // 0: Home Hub
    QuranHomeScreen(onBack: () => _onItemTapped(0)),     // 1: Quran
    HadithScreen(onBack: () => _onItemTapped(0)),        // 2: Hadith
    CommunityScreen(onBack: () => _onItemTapped(0)),     // 3: Community
    ChatScreen(onBack: () => _onItemTapped(0)),          // 4: AI Tutor
    QiblaScreen(onBack: () => _onItemTapped(0)),         // 5: Qibla
    PrayerTimesScreen(onBack: () => _onItemTapped(0)),   // 6: Azan
  ];

  /// Core Navigation logic
  /// Note: Home tiles should use a callback or global state to trigger this
  /// to keep the Nav Pill persistent (UI Surgery Requirement).
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background, // Strictly Raisin Black #202124
      body: IndexedStack(
        // Keeps the hub active for sub-views to prevent breaking Nav persistence
        index: _selectedIndex, 
        children: _screens,
      ),
      bottomNavigationBar: null,
    );
  }


}
