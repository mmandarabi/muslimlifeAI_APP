import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_mind/services/ai_chat_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';

class AIInsightCarousel extends StatefulWidget {
  const AIInsightCarousel({super.key});

  @override
  State<AIInsightCarousel> createState() => _AIInsightCarouselState();
}

class _AIInsightCarouselState extends State<AIInsightCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;

  List<Map<String, dynamic>> _insights = [
    // Placeholder while loading
    {
      "title": "Loading Insight...",
      "text": "Consulting Horeen...",
      "primaryButton": "Please Wait",
      "secondaryButton": "...",
      "icon": LucideIcons.loader,
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialInsight();
  }

  Future<void> _loadInitialInsight() async {
    try {
      // Example event: Missed Prayer (Fajr) - could be dynamic based on user data
      final insightData = await AiService().generateInsight("missed_prayer", {
        "prayerName": "Fajr", 
        "daysMissed": 1
      });

      if (mounted) {
        setState(() {
          // If valid response, replace first mock card with dynamic Horeen card
          if (insightData["type"] == "insight") {
             _insights = [
               {
                 "title": insightData["title"] ?? "Insight",
                 "text": insightData["message"] ?? "No message",
                 "primaryButton": "Begin Plan",
                 "secondaryButton": "Dismiss",
                 "icon": LucideIcons.sparkles,
               },
               // Keep other static mocks for demo carousel effect
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
             ];
             _isLoading = false;
          } else {
             // Fallback if API returns error or unknown type
             // Throwing here will be caught by the catch block below, which sets up the fallback UI
             throw Exception("Invalid AI Response: ${insightData['message']}");
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
           // Fallback to static if offline/error
           _insights = [
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
              }
           ];
           _isLoading = false;
        });
      }
    }
  }

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
    // Lock text scaling to 1.0 for the carousel to prevent layout break on high system font settings
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 280,
              maxHeight: 400, // Safe range for locked scaling
            ),
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
                    isLoading: _isLoading && index == 0,
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
    ),
  );
}
}

class AIInsightCard extends StatelessWidget {
  final Map<String, dynamic> insight;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLoading;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onNext,
    this.onPrevious,
    this.isLoading = false,
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
            child: isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : Column(
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
                    Icon(insight['icon'] ?? LucideIcons.sparkles, color: Colors.white54, size: 18),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  insight['title'] ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Body Text (Scrollable to prevent overflow, restricted height for stability)
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      insight['text'] ?? "",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.5,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
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
                        child: Text(insight['secondaryButton'] ?? "Dismiss"),
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
                        child: Text(insight['primaryButton'] ?? "Action"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Layer 2: Left Arrow
          if (onPrevious != null && !isLoading)
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
          if (onNext != null && !isLoading)
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
