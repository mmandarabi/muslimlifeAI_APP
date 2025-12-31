import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_mind/models/prayer_times.dart';
import 'package:muslim_mind/services/prayer_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/widgets/settings_bottom_sheet.dart';
import 'package:muslim_mind/screens/chat_screen.dart';
import 'package:muslim_mind/services/quran_local_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeTab({super.key, required this.onNavigate});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  
  // Dynamic State for Hero Card
  String _nextPrayerName = "--";
  String _nextPrayerTime = "--:--";
  String _timeSuffix = ""; // AM/PM

  @override
  void initState() {
    super.initState();
    // 1. Instant Cache Load (Offline First)
    _loadCache();
    _loadReadHistory(); // 🛑 RESUME LOGIC
    // 2. Background Network Fetch
    _refreshData();
  }

  Future<void> _loadCache() async {
    final cached = await PrayerService().loadCachedData();
    if (cached != null && mounted) {
      setState(() {
        _prayerTimes = cached;
        _isLoading = false; // Show content immediately
        _calculateNextPrayer(cached);
      });
    }
  }

  // 🛑 HISTORY: Last Read Surah
  String _lastReadSurah = "AL-BAQARAH"; // Default fallback
  bool _hasReadHistory = false;

  Future<void> _loadReadHistory() async {
    final history = await QuranLocalService().getLastAccessed();
    if (history != null && mounted) {
      setState(() {
        _lastReadSurah = history['name'];
        _hasReadHistory = true;
      });
    }
  }

  Future<void> _refreshData() async {
    try {
      final data = await PrayerService().fetchPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = data;
          _isLoading = false;
          _calculateNextPrayer(data);
        });
      }
    } catch (e) {
      if (mounted && _prayerTimes == null) {
         // Only stop loading if we have NO data at all
         setState(() => _isLoading = false);
      }
    }
  }

  void _calculateNextPrayer(PrayerTimes data) {
    final now = DateTime.now();
    
    // Parse all times
    DateTime? parse(String t) {
      try {
        final d = DateFormat("HH:mm").parse(t.split(" ")[0]); // Handle "13:00" or "01:00 PM" robustly
        return DateTime(now.year, now.month, now.day, d.hour, d.minute);
      } catch (_) {
         try {
           final d = DateFormat("h:mm a").parse(t);
           return DateTime(now.year, now.month, now.day, d.hour, d.minute);
         } catch(e) { return null; }
      }
    }

    final slots = [
      MapEntry("Fajr", parse(data.fajr)),
      MapEntry("Dhuhr", parse(data.dhuhr)),
      MapEntry("Asr", parse(data.asr)),
      MapEntry("Maghrib", parse(data.maghrib)),
      MapEntry("Isha", parse(data.isha)),
    ];

    String nextName = "Fajr";
    DateTime? nextTime = parse(data.fajr)?.add(const Duration(days: 1)); // Default to tomorrow Fajr

    for (var slot in slots) {
      if (slot.value != null && slot.value!.isAfter(now)) {
        nextName = slot.key;
        nextTime = slot.value;
        break;
      }
    }

    if (nextTime != null) {
      final formatted = DateFormat("h:mm").format(nextTime);
      final suffix = DateFormat("a").format(nextTime);
      
      setState(() {
        _nextPrayerName = nextName;
        _nextPrayerTime = formatted;
        _timeSuffix = suffix;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inherit Raisin Black from Dashboard via transparency to fix "Box within Box"
    final textColor = AppColors.textPrimaryDark;
    final secondaryTextColor = AppColors.textSecondaryDark;
    final accentColor = AppColors.primary; // Sanctuary Emerald

    return Container(
      color: Colors.transparent, 
      child: SingleChildScrollView(
        // padding to account for the floating Nav Pill and Mini Player
        // Compact padding: Reduced bottom from 200 to 120 (Just enough for player)
        padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 12, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER: 12-DAY STREAK + SETTINGS
            _buildHeader(secondaryTextColor, textColor),
            
            const SizedBox(height: 32), // Increased from 20 to push down
            GestureDetector(
              onTap: () {
                 // Open Immersive Chat
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => ChatScreen(),
                     fullscreenDialog: true, // Animates up like a sheet/modal
                   ),
                 );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: textColor.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.sparkles, size: 18, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      "Assalamu Alaikum, ask me...",
                      style: GoogleFonts.outfit(
                         fontSize: 16,
                         color: textColor.withOpacity(0.6),
                         fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                         color: AppColors.primary.withOpacity(0.1),
                         shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.arrow_right, size: 14, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32), // Increased from 24

            // 2. HERO: Next Prayer Card (Lighter Surface Elevation)
            _buildPrayerHero(textColor, secondaryTextColor, accentColor),

            const SizedBox(height: 48), // Increased from 32
            
            // 3. THE LIST HUB: Compact 2-Column Grid (No Scrolling)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16, // Increased spacing
              mainAxisSpacing: 16,
              childAspectRatio: 1.3, // Taller items (was 1.35) to fill more space
              padding: EdgeInsets.zero,
              children: [
                _hubGridItem("The Holy Quran", _hasReadHistory ? "RESUME $_lastReadSurah" : "START READING", LucideIcons.book_open, 1),
                _hubGridItem("Hadith Collection", "COMING SOON", LucideIcons.scroll_text, 2, isEnabled: false),
                _hubGridItem("Prayer Times", "AZAN SCHEDULE", LucideIcons.clock, 6), // 🛑 SWAP: Pos 3
                _hubGridItem("Qibla Finder", "MECCA DIRECTION", LucideIcons.compass, 5),
                _hubGridItem("Community", "COMING SOON", LucideIcons.users, 3, isEnabled: false), // 🛑 SWAP: Pos 6
              ],
            ),
            
            const SizedBox(height: 16), // Minimal bottom spacer
          ],
        ),
      ),
    );
  }

  /// Header with Collapsible Nav and Streak
  Widget _buildHeader(Color secondaryTextColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // 🛑 LAYOUT FIX: Align top for vertical expansion
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 🛑 LAYOUT FIX: Align top
          children: [
            // Streak Section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Icon(LucideIcons.activity, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            _buildStreakView(),
          ],
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const SettingsBottomSheet(),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(LucideIcons.settings, color: textColor.withOpacity(0.4), size: 18),
          ),
        ),
      ],
    );
  }

  /// Prayer Hero with Progress Bar
  Widget _buildPrayerHero(Color textColor, Color secondaryTextColor, Color accentColor) {
    return AspectRatio(
      aspectRatio: 20 / 9, // Slightly taller than 21/9 for better presence
      child: GlassCard(
        borderRadius: 40,
        padding: EdgeInsets.zero, // Controlled iç dolgu
        showPattern: false, // Solid minimalist look per request
        opacity: 0.2, // Stronger solid elevation 
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      child: Stack(
        children: [
          // 🛑 0. BACKGROUND IMAGE LAYER
          Positioned.fill(
             child: Opacity(
               opacity: 0.6,
               child: Image.asset(
                 'assets/images/home_hero_bg.png',
                 fit: BoxFit.cover,
                 alignment: Alignment.center, // Focus on center for wide aspect
               ),
             ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduced vertical padding to FIX OVERFLOW
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NEXT PRAYER",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                            color: accentColor, // 🛑 CHANGED: Aged Gold
                          ),
                        ),
                        _isLoading 
                        ? Shimmer.fromColors(
                            baseColor: Colors.white.withOpacity(0.05),
                            highlightColor: Colors.white.withOpacity(0.1),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              width: 120, 
                              height: 38, 
                              decoration: BoxDecoration(
                                color: Colors.black, // Color actually ignored by shimmer but needed for shape
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
                          )
                        : Text(
                          _nextPrayerName,
                          style: GoogleFonts.outfit(
                            fontSize: 32, // Restored size
                            fontWeight: FontWeight.w300,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(LucideIcons.map_pin, size: 10, color: accentColor),
                        const SizedBox(width: 4),
                        Text(
                          _prayerTimes?.locationName.toUpperCase() ?? "LOCATING...", // 🛑 CHANGED: Dynamic
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                            color: accentColor, // 🛑 CHANGED: Aged Gold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Reduced from 12
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.05),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          width: 180, 
                          height: 60, 
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)
                          )
                        ),
                      )
                    : Text(
                      _nextPrayerTime,
                      style: GoogleFonts.outfit(
                        fontSize: 46, // Restored size
                        fontWeight: FontWeight.w200,
                        color: textColor,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (!_isLoading)
                    Text(
                      _timeSuffix,
                      style: GoogleFonts.inter(
                        fontSize: 14, // Slightly larger for AM/PM
                        letterSpacing: 3,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Reduced from 8
              ],
            ),
          ),
          // Bottom Progress Bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _isLoading 
            ? const SizedBox.shrink()
            : Container(
              height: 4,
              color: Colors.white.withOpacity(0.02),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.65, // Static for now, can be dynamic later if needed
                child: Container(
                  color: accentColor.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  /// Streak View with Ticks
  Widget _buildStreakView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "12 DAY STREAK",
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) {
            final bool isActive = index < 6;
            return Container(
              width: 5,
              height: 14,
              margin: const EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Compact Grid Item (Vertical Stack)
  Widget _hubGridItem(String title, String subtitle, IconData icon, int targetIndex, {bool isAccent = false, bool isEnabled = true}) {
    return GestureDetector(
      onTap: isEnabled ? () => widget.onNavigate(targetIndex) : null,
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        sigma: 0,
        showPattern: false,
        opacity: isEnabled ? 0.15 : 0.05,
        border: Border.all(color: Colors.white.withOpacity(isEnabled ? 0.04 : 0.02)),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 42, // Restored size
                height: 42, 
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(
                  icon, 
                  color: isAccent ? AppColors.accent : AppColors.textPrimaryDark.withOpacity(0.8), 
                  size: 20 // Restored size
                ),
              ),
              const SizedBox(height: 12), // Restored spacing
              // Title
              Expanded( // Use expanded to prevent overflow
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14, // Reduced from 16
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced from 4
                  // Subtitle
                  Text(
                    subtitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 7, // Reduced from 8
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondaryDark.withOpacity(0.3),
                    ),
                  ),
                ],
               ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

