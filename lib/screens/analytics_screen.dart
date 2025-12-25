import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/widgets/milestone_share_card.dart';
import 'package:muslim_mind/services/prayer_log_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logService = PrayerLogService();
    final streak = logService.getStreak();
    final todayCount = logService.getDailyCompletionCount(DateTime.now());
    final progressList = logService.getLastSevenDaysProgress();
    
    final days = ["M", "T", "W", "T", "F", "S", "S"];
    // Adjust days label to align with 'progressList' which is last 7 days ending today
    final labels = List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      return DateFormat('E').format(date).substring(0, 1);
    });

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
                              "$streak Days",
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Today: $todayCount / 5 prayers completed",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[400],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            streak > 0 ? "Keep it up! 🔥" : "Start your streak today! ✨",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
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
                    children: List.generate(7, (index) {
                      return _buildBar(
                        context, 
                        labels[index], 
                        progressList[index], 
                        isToday: index == 6
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Insight Card
            if (todayCount == 5)
            GlassCard(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
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
                        "Masha'Allah! You have completed all prayers today!",
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
            color: isToday ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
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
