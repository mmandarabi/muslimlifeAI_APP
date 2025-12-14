import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim_life_ai_demo/models/prayer_times.dart';
import 'package:muslim_life_ai_demo/services/prayer_service.dart';
import 'package:muslim_life_ai_demo/screens/login_screen.dart';
import 'package:muslim_life_ai_demo/screens/mission_screen.dart';
import 'package:muslim_life_ai_demo/screens/prayer_times_screen.dart';
import 'package:muslim_life_ai_demo/screens/qibla_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/ai_insight_carousel.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final data = await PrayerService().fetchPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Unavailable";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "As-salamu alaykum",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Yama",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.shield_check, color: AppColors.primary),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(LucideIcons.log_out, color: Colors.white54),
                    tooltip: "Log Out",
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logging out...")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Dual Header Row (Now vs Next)
          Row(
            children: [
              // BOX 1: CURRENT TIME
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Now",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('h:mm a').format(DateTime.now()),
                            style: GoogleFonts.poppins(
                              fontSize: 24, // Adjusted for fit
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12), // Spacing

              // BOX 2: NEXT PRAYER
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrayerTimesScreen()),
                    );
                  },
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _isLoading
                        ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Next: ${_prayerTimes?.nextPrayer ?? '--'}",
                                style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatTo12Hour(_prayerTimes?.nextPrayerTime),
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // AI Insight Widget
          const AIInsightCarousel(),
          
          const SizedBox(height: 40),
          
          // Mission Button (Temporary access)
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MissionScreen()),
                );
              },
              icon: const Icon(LucideIcons.info, size: 16),
              label: const Text("View Mission Briefing"),
              style: TextButton.styleFrom(foregroundColor: Colors.white54),
            ),
          ),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  String _getArabicName(String englishName) {
    switch (englishName.toLowerCase()) {
      case 'fajr': return 'الفجر';
      case 'dhuhr': return 'الظهر';
      case 'asr': return 'العصر';
      case 'maghrib': return 'المغرب';
      case 'isha': return 'العشاء';
      default: return '';
    }
  }

  String _formatTo12Hour(String? time) {
    if (time == null) return "--:--";
    try {
      // Expecting "HH:mm"
      final date = DateFormat.Hm().parse(time); 
      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return time;
    }
  }
}

