import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:muslim_life_ai_demo/widgets/milestone_share_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Progress",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),

            // Streak Card
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Prayer Streak",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MilestoneShareCard(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Text(
                              "12 Days",
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Today: 3 / 5 prayers completed",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[400],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Longest streak: 47 days 🔥",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.flame,
                            color: AppColors.primary, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Bar Chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(context, "M", 0.8),
                      _buildBar(context, "T", 0.9),
                      _buildBar(context, "W", 1.0),
                      _buildBar(context, "T", 1.0),
                      _buildBar(context, "F", 1.0),
                      _buildBar(context, "S", 1.0),
                      _buildBar(context, "S", 1.0, isToday: true),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Insight Card
            GlassCard(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(LucideIcons.trophy, color: Color(0xFFFFD700), size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Masha'Allah! You have prayed all 5 prayers on time this week!",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, String label, double heightFactor, {bool isToday = false}) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : AppColors.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isToday ? Colors.white : Colors.white38,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
