import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:quran/quran.dart' as quran;
import '../models/quran_surah.dart';
import '../services/quran_local_service.dart';
import '../services/quran_page_service.dart';
import '../services/theme_service.dart';
import '../services/unified_audio_service.dart';
import '../theme/app_theme.dart';
import '../controllers/quran_audio_controller.dart';
import '../widgets/glass_card.dart';
import 'quran/quran_page_view.dart';
import '../models/quran_display_names.dart';
import '../widgets/quran/surah_header_widget.dart';
import 'package:intl/intl.dart';

class QuranReadMode extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int? initialPage;

  const QuranReadMode({
    super.key, 
    this.surahId = 1, 
    this.surahName = "Al-Fātiḥah",
    this.initialPage,
  });

  @override
  State<QuranReadMode> createState() => _QuranReadModeState();
}

class _QuranReadModeState extends State<QuranReadMode> {
  late final QuranAudioController _controller;
  late final PageController _pageController;
  final Map<int, QuranSurah> _surahCache = {};
  
  Future<QuranSurah>? _surahFuture;
  QuranSurah? _currentSurahData;
  int _currentVisualPageLocal = 0;
  bool _showControls = true;
  double _fontSize = 20.0;
  double _baseFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = QuranAudioController()..init(widget.surahId);
    
    final startPage = widget.initialPage ?? QuranPageService().getPageNumber(widget.surahId, 1);
    _pageController = PageController(initialPage: startPage - 1);
    _currentVisualPageLocal = startPage - 1;

    // Initial load - MUST be active
    _surahFuture = _loadSurah(widget.surahId, makeActive: true);
    
    WakelockPlus.enable();
    ThemeService().addListener(_onThemeChanged);
    _controller.addListener(_onAudioStateChanged);

    // Setup periodic timer for header clock
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  late final Timer _clockTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🛑 UI FIX: Lower the global player since we have no BottomNavBar here
    // Safe to use MediaQuery here, but must defer update to avoid build collisions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 🛑 UI FIX: Standardized 12px margin. System safe area is now handled by the player widget.
        UnifiedAudioService().playerBottomPadding.value = 12.0;
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onAudioStateChanged);
    _controller.dispose();
    _pageController.dispose();
    ThemeService().removeListener(_onThemeChanged);
    WakelockPlus.disable();
    _clockTimer.cancel();
    
    // Reset player position for Dashboard
    // 🛑 STABILITY FIX: Updating a ValueNotifier during dispose needs to be deferred
    // to avoid "framework is locked" assertion.
    Future.microtask(() {
      UnifiedAudioService().playerBottomPadding.value = 12.0;
    });
    
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }
  
  int? _lastSetStateAyahId;
  bool? _lastSetStatePlaying;

  void _onAudioStateChanged() {
    if (mounted) {
      if (_controller.currentSurahId != null && 
          _controller.currentSurahId != _currentSurahData?.id && 
          !_controller.isBrowsing) {
        // 🛑 SYNC FIX: When audio changes Surah, we must forcefully update the View
        // Here we DO want to make it active because the Audio is the Source of Truth
        _loadSurah(_controller.currentSurahId!, makeActive: true);
        
        // Jump to the new Surah's start page so content matches the Audio
        final targetPage = QuranPageService().getPageNumber(_controller.currentSurahId!, 1);
        if (_pageController.hasClients) {
          _pageController.jumpToPage(targetPage - 1);
        }
      }
      if (_currentSurahData != null) {
        _controller.handleSmartFollow(_pageController, _currentVisualPageLocal, _currentSurahData!);
      }
      
      // 🛑 OPTIMIZATION: Only rebuild the whole page if the active ayah or play state changed.
    // The progress slider and other small elements will use granular builders.
    if (_controller.activeAyahId != _lastSetStateAyahId || _controller.isPlaying != _lastSetStatePlaying) {
      // 🛑 FIX: Prevent "setState() called during build" error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _lastSetStateAyahId = _controller.activeAyahId;
          _lastSetStatePlaying = _controller.isPlaying;
          setState(() {});
        }
      });
    }
    }
  }

  Future<QuranSurah> _loadSurah(int surahId, {bool makeActive = true}) async {
    // 1. Check cache first
    if (_surahCache.containsKey(surahId)) {
      final surah = _surahCache[surahId]!;
      if (makeActive && mounted) {
        setState(() {
          _currentSurahData = surah;
        });
      }
      return surah;
    }

    // 2. Fetch if missing
    final surah = await QuranLocalService().getSurahDetails(surahId);
    if (mounted) {
      setState(() {
        _surahCache[surahId] = surah;
        if (makeActive) {
          _currentSurahData = surah;
        }
      });
    }
    return surah;
  }

  void _changeSurah(int newId, {bool skipJump = false, bool isSilentSwipe = false}) async {
    final surah = await _loadSurah(newId);
    if (mounted) {
      // 🛑 STABILITY FIX: Only update the controller context if it's a hard button click 
      // OR if we aren't playing anything. If audio is active, we preserve its context.
      if (!_controller.isPlaying || !isSilentSwipe) {
          if (_controller.currentSurahId != newId && !_controller.isPlaying) {
             _controller.resetPlayingContext(); // Reset position/ayah for the new context
             _controller.currentSurahId = newId; 
             _controller.fetchTimestamps(newId);
          }
      }
      
      if (!skipJump && _pageController.hasClients) {
        final targetPage = QuranPageService().getPageNumber(newId, 1);
        _pageController.animateToPage(targetPage - 1, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
      setState(() {
        _currentVisualPageLocal = _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Palette (Gold Case / Sanctuary Light)
    final backgroundColor = AppColors.getBackgroundColor(context);
    final surfaceColor = AppColors.getSurfaceColor(context);
    final textColor = AppColors.getTextPrimary(context);
    const emerald = AppColors.primary;
    const gold = AppColors.accent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<QuranSurah>(
        future: _surahFuture,
        builder: (context, snapshot) {
          final surah = _currentSurahData ?? snapshot.data;
          if (surah == null) return _buildLoading(snapshot);

          return Column(
            children: [
              // 1. Compact Page-State Header (Left: Surah, Mid: Time, Right: Juz/Page)
              _buildCompactPageHeader(gold, textColor),

              // 2. Full-Bleed Mushaf Content
              Expanded(
                child: GestureDetector(
                  onTap: () { 
                    HapticFeedback.selectionClick(); 
                    setState(() => _showControls = !_showControls); 
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 604,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final pageNum = index + 1;
                      
                      // 🛑 UI FIX: Slightly reduced font size for Al-Fatiha (Page 1) to prevent border overlap
                      // due to the heavy padding required for the decorative frame.
                      final fontScale = (pageNum == 1) ? 1.15 : 1.5;
                      
                      final content = _buildMushafContent(pageNum, textColor, surah, gold, emerald, fontScale);

                      // 🛑 UI FIX: Al-Fatiha and first page of Al-Baqara remain scrollable as per traditional layout
                      if (pageNum <= 2) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 200),
                          child: content,
                        );
                      }

                      // 🛑 UI FIX: All other pages shrink to fit the screen (no scroll required)
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 90), // Optimized margin for global player
                          child: FittedBox(
                            fit: BoxFit.contain, // Scale up or down to fill available space
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: content,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompactPageHeader(Color gold, Color textColor) {
    final int pageNumber = _currentVisualPageLocal + 1;
    final pageData = QuranPageService().getPageData(pageNumber);
    final int juz = QuranPageService().getJuzNumber(pageData.first['surah']!, pageData.first['start']!);
    final String firstSurahName = kUthmaniSurahTitles[pageData.first['surah']] ?? "Surah";
    final String timeStr = DateFormat('HH:mm').format(DateTime.now());

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundColor(context).withOpacity(0.8),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back button + First Surah Name
          Row(
            children: [
              _buildMiniNavButton(LucideIcons.chevron_left, () => Navigator.pop(context), textColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sūrat $firstSurahName",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    "Page $pageNumber",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: textColor.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Middle: Current Time
          Text(
            timeStr,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: gold.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),

          // Right: Juz Number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Juz' $juz",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(String text, Color color) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        color: color,
      ),
    );
  }

  Widget _buildMushafContent(int pageNum, Color textColor, QuranSurah mainSurah, Color gold, Color emerald, [double fontScale = 1.5]) {
    final pageData = QuranPageService().getPageData(pageNum);
    List<Widget> content = [];
    
    for (var entry in pageData) {
      final sID = entry['surah']!;
      final surahData = (sID == _currentSurahData?.id) ? mainSurah : _surahCache[sID];
      
      if (surahData == null) { 
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadSurah(sID, makeActive: false)); 
        content.add(const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())));
        continue; 
      }

      // 🛑 UI OVERHAUL: Inject decorative Surah Header at the start of each Surah
      if (entry['start'] == 1) {
        content.add(
          SurahHeaderWidget(
            surahId: sID,
            surahNameArabic: "سُورَةُ ${kUthmaniSurahTitles[sID] ?? surahData.name}",
            surahNameEnglish: surahData.transliteration,
          ),
        );
      }
      
      // Bismillah logic
      if (entry['start'] == 1 && sID != 1 && sID != 9) {
         content.add(
           Padding(
             padding: const EdgeInsets.only(bottom: 24),
             child: Text(
               "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
               style: GoogleFonts.amiri(fontSize: 28, color: textColor.withOpacity(0.9)),
               textAlign: TextAlign.center,
             ),
           )
         );
      }
      
      Widget surahView = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // 🛑 FEATURE RESTORED: Pinch-to-Zoom
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.0,
          child: QuranPageView(
            verses: surahData.verses.where((v) => v.id >= entry['start']! && v.id <= entry['end']!).toList(),
            fontSize: _fontSize * fontScale, 
            activeAyahId: _controller.activeAyahId,
            textColor: textColor,
            surahId: sID,
            playingSurahId: _controller.currentSurahId,
            onAyahDoubleTap: (s, a) {
              HapticFeedback.mediumImpact();
              _controller.isBrowsing = false; 
              _controller.playSurah(s, ayahNumber: a);
            },
            onAyahLongPress: (s, a) {
              HapticFeedback.heavyImpact();
              _showAyahMenu(s, a); // 🛑 RESTORED: Context Menu
            },
            align: TextAlign.justify,
          ),
        ),
      );

      // 🛑 UI FIX: Final Polish - Applying custom background for Al-Fatiha
      if (sID == 1) {
        surahView = Container(
          width: double.infinity,
          // Force height to fill most of the screen so background reaches bottom
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          alignment: Alignment.center,
          // 🛑 UI FIX: Significant inset to ensure text floats strictly inside the golden border
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80), 
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sura_alfateha.gif'),
              fit: BoxFit.fill,
              opacity: 0.5, // Balanced visibility
            ),
          ),
          child: surahView,
        );
      }
      
      content.add(surahView);
    }
    return Column(children: content);
  }


  Widget _buildMiniNavButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
       child: Container(
         width: 40, height: 40,
         decoration: BoxDecoration(
           color: color.withValues(alpha: 0.05),
           shape: BoxShape.circle,
           border: Border.all(color: color.withValues(alpha: 0.05))
         ),
         child: Icon(icon, color: color.withValues(alpha: 0.6), size: 20),
       ),
    );
  }

  void _onPageChanged(int idx) {
    HapticFeedback.lightImpact();
    // 🛑 UX FIX: Only set isBrowsing if this was NOT triggered by an auto-turn.
    if (!_controller.isProgrammaticScroll) {
       _controller.isBrowsing = true;
    }
    _controller.isProgrammaticScroll = false; // Reset flag

    setState(() => _currentVisualPageLocal = idx);
    final pageData = QuranPageService().getPageData(idx + 1);
    if (pageData.isNotEmpty) {
      final sID = pageData.first['surah'];
      if (sID != null && sID != _currentSurahData?.id) _changeSurah(sID, skipJump: true, isSilentSwipe: true);
    }
  }



  Widget _buildLoading(AsyncSnapshot snapshot) {
    if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
    return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
  }

  void _showAyahMenu(int surahId, int ayahId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Use transparency for floating look
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
           color: AppColors.cardDark,
           borderRadius: BorderRadius.circular(24),
           border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
           boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40, height: 4, 
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0),
               child: Text("Ayah $ayahId", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const Divider(color: Colors.white10),
            ListTile(
              leading: const Icon(Icons.play_circle_outline, color: AppColors.primary),
              title: const Text("Play Verse", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _controller.playSurah(surahId, ayahNumber: ayahId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: Colors.white70),
              title: const Text("Bookmark", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Bookmark logic
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bookmark saved")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white70),
              title: const Text("Share Verse", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Share logic
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
