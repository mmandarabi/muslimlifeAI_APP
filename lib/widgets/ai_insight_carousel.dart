import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';

class AIInsightCarousel extends StatefulWidget {
  const AIInsightCarousel({super.key});

  @override
  State<AIInsightCarousel> createState() => _AIInsightCarouselState();
}

class _AIInsightCarouselState extends State<AIInsightCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _insights = [
    {
      "title": "Missed Prayer Coaching",
      "text": "I noticed one of yesterday’s prayers still needs to be made up (qadāʾ). Would you like a gentle reminder today to pray it before the next same prayer?",
      "primaryButton": "Begin Plan",
      "secondaryButton": "Not Now",
      "icon": LucideIcons.clipboard_list,
    },
    {
      "title": "Quran Momentum",
      "text": "Masha'Allah, you’ve read Quran for 3 days in a row. Shall we build a 7-day momentum plan?",
      "primaryButton": "Build My Plan",
      "secondaryButton": "Dismiss",
      "icon": LucideIcons.book_open,
    },
    {
      "title": "Sunnah Fasting",
      "text": "Tomorrow is a Sunnah fasting day (Monday). Would you like reminders and helpful duʿā’?",
      "primaryButton": "Enable Reminder",
      "secondaryButton": "Dismiss",
      "icon": LucideIcons.moon,
    },
    {
      "title": "Weekly Growth",
      "text": "You improved your prayer consistency by 12% this week. Would you like goals for next week?",
      "primaryButton": "View Summary",
      "secondaryButton": "Dismiss",
      "icon": LucideIcons.trending_up,
    },
    {
      "title": "Recitation Progress",
      "text": "Beautiful progress! Your recitation accuracy improved by 17%. Ready for the next Surah?",
      "primaryButton": "Continue",
      "secondaryButton": "Not Now",
      "icon": LucideIcons.mic,
    },
  ];

  void _nextPage() {
    if (_currentPage < _insights.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 330, // Increased height to accommodate wrapped text comfortably
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _insights.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AIInsightCard(
                  insight: _insights[index],
                  onNext: index < _insights.length - 1 ? _nextPage : null,
                  onPrevious: index > 0 ? _previousPage : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_insights.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class AIInsightCard extends StatelessWidget {
  final Map<String, dynamic> insight;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onNext,
    this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      border: Border.all(
        color: AppColors.primary.withOpacity(0.5),
        width: 1.5,
      ),
      child: Stack(
        children: [
          // Layer 1: Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    const Icon(LucideIcons.sparkles,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "AI INSIGHT",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Icon(insight['icon'], color: Colors.white54, size: 18),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  insight['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Body Text
                Text(
                  insight['text'],
                  maxLines: 10,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                        fontSize: 14,
                      ),
                ),
                
                const Spacer(),
                
                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(insight['secondaryButton']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(insight['primaryButton']),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Layer 2: Left Arrow
          if (onPrevious != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(LucideIcons.chevron_left, color: Colors.white54),
                  onPressed: onPrevious,
                ),
              ),
            ),

          // Layer 3: Right Arrow
          if (onNext != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(LucideIcons.chevron_right, color: Colors.white54),
                  onPressed: onNext,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
