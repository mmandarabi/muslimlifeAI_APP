import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/screens/chat_screen.dart';
import 'package:muslim_life_ai_demo/screens/mission_screen.dart';
import 'package:muslim_life_ai_demo/screens/prayer_times_screen.dart';
import 'package:muslim_life_ai_demo/screens/qibla_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/ai_insight_carousel.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
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
              const Icon(LucideIcons.shield_check, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 30),

          // Hero Card (Prayer Time)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrayerTimesScreen()),
              );
            },
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Maghrib   مغرب",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(LucideIcons.map_pin,
                                  size: 16, color: Colors.white54),
                              const SizedBox(width: 4),
                              Text(
                                "Belmont, VA",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const QiblaScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.moon,
                              color: AppColors.primary, size: 32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Time countdown or similar could go here
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.white10,
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "-24m until Isha",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
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
          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
    );
  }
}
