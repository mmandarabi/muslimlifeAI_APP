import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/models/quran_display_names.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/models/quran_ayah.dart';
import 'package:muslim_life_ai_demo/services/quran_local_service.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:muslim_life_ai_demo/screens/quran_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:muslim_life_ai_demo/data/reciter_manifest.dart';
import 'package:muslim_life_ai_demo/services/quran_page_service.dart';

// Precision Timing: Deterministic Sync

class QuranReadMode extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int? initialPage; // Added to support jump-to-page (Juz navigation)

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
  Future<QuranSurah>? _surahFuture;
  QuranSurah? _currentSurahData; // Cache for UI stability
  final UnifiedAudioService _audioService = UnifiedAudioService();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  
  // State for Accessibility
  late int _currentSurahId;
  late String _currentSurahName;
  bool _isPlaying = false;
  bool _isDownloading = false;
  bool _isLightMode = false;
  double _fontSize = 20.0;
  int? _activeAyahId;
  Duration _currentPosition = Duration.zero;
  
  // Phase 1.5: Throttled Scroll State
  bool _isScrolling = false;
  
  final ScrollController _scrollController = ScrollController();
  
  // Phase 3: Page View State
  bool _isPageView = true; // Default to Paged Mode
  late PageController _pageController;
  int _startPage = 0; // Absolute Quran Page (1-604)
  int _endPage = 0;
  int _currentVisualPageLocal = 0; // 0 to (End-Start)
  
  // Phase 3.5: Multi-Surah Support
  final Map<int, QuranSurah> _surahCache = {};
  
  // Sync Logic: Precision Timestamps
  List<AyahSegment> _ayahSegments = [];
  int _maxAyahIdSeen = -1000;

  @override
  void initState() {
    super.initState();
    _currentSurahId = widget.surahId;
    _currentSurahName = widget.surahName;
    _surahFuture = QuranLocalService().getSurahDetails(_currentSurahId).then((s) {
      _fetchTimestamps(_currentSurahId);
      // Calc Page Range
      _calculatePageRange(s);
      if (mounted) setState(() => _currentSurahData = s);
      return s;
    });
    _isPlaying = _audioService.isPlaying;

    // Phase 3: Init Global PageController
    final startPage = widget.initialPage ?? QuranPageService().getPageNumber(_currentSurahId, 1);
    _pageController = PageController(initialPage: startPage - 1);
    _currentVisualPageLocal = startPage - 1;

    // Phase 1.5: Keep Screen Awake
    WakelockPlus.enable();

    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
      // ISSUE A: Blink Guard
      if (mounted && !_audioService.isTransitioning) {
         setState(() => _isPlaying = state.playing);
      }
    });

    // Listen for background surah advance
    _audioService.surahChangedNotifier.addListener(_onSurahAutoChanged);
    _audioService.downloadingNotifier.addListener(_onDownloadStatusChanged);
    _audioService.transitioningNotifier.addListener(_onTransitionStatusChanged);

    // Audio Sync Listeners
    _positionSubscription = _audioService.onPositionChanged.listen((pos) {
      if (mounted && !_audioService.isTransitioning) {
        setState(() => _currentPosition = pos);
        _updateActiveAyah();
      }
    });
  }

  bool _initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _isLightMode = Theme.of(context).brightness == Brightness.light;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _audioService.surahChangedNotifier.removeListener(_onSurahAutoChanged);
    _audioService.downloadingNotifier.removeListener(_onDownloadStatusChanged);
    _audioService.transitioningNotifier.removeListener(_onTransitionStatusChanged);
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _scrollController.dispose();
    _pageController.dispose();
    
    // Disable Wakelock when leaving
    WakelockPlus.disable();
    
    _audioService.stop(); // Stop audio and ABORT downloads when leaving
    super.dispose();
  }

  void _calculatePageRange(QuranSurah surah) {
    if (surah.verses.isEmpty) return;
    
    final service = QuranPageService();
    _startPage = service.getPageNumber(surah.id, surah.verses.first.id);
    _endPage = service.getPageNumber(surah.id, surah.verses.last.id);
    
    // Logic: Do NOT re-create _pageController here. 
    // It is initialized in initState and stays stable.
    // Movement is handled by animateToPage in listeners to prevent "Stuck Page" bugs.
    
    if (mounted) setState(() {});
  }

  void _onSurahAutoChanged() async {
    final newId = _audioService.currentSurahId;
    debugPrint("TRACE: QuranReadMode._onSurahAutoChanged - NEW ID: $newId | MOUNTED: $mounted");
    if (newId == null || !mounted) return;

    // 🛑 CRITICAL: Capture current page index BEFORE any state updates 🛑
    // This prevents _updateActiveAyah from teleporting _currentVisualPageLocal 
    // before we can run the animation logic here.
    final int currentPageIndexSnapshot = _pageController.hasClients 
        ? (_pageController.page?.round() ?? _currentVisualPageLocal)
        : _currentVisualPageLocal;

    // 1. Force Page Turn Logic (Immediate UI Feedback)
    if (_pageController.hasClients) {
      final int newPageNumber = QuranPageService().getPageNumber(newId, 1);
      final int currentPageNumber = currentPageIndexSnapshot + 1;
      
      debugPrint("TRACE: QuranReadMode - Target Page: $newPageNumber | Current Page: $currentPageNumber");

      if (newPageNumber != currentPageNumber) {
        debugPrint("TRACE: QuranReadMode - IGNITING PAGE TURN to $newPageNumber");
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              newPageNumber - 1,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }

    if (newId != _currentSurahId) {
      try {
        // 2. Silent Pre-fetch
        final surah = await QuranLocalService().getSurahDetails(newId);
        if (!mounted) return;

        // 3. Refresh Cache Atomicly
        _surahCache[newId] = surah;

        // 4. Fetch Timestamps
        _fetchTimestamps(newId);
        
        // 5. Update State
        setState(() {
          _currentSurahId = newId;
          _currentSurahName = surah.transliteration;
          _currentSurahData = surah;
          _surahFuture = Future.value(surah);
          // We DO NOT clear _activeAyahId or _ayahSegments here.
          // _fetchTimestamps will replace _ayahSegments atomicly,
          // and _updateActiveAyah will update _activeAyahId on the next tick.
        });
        _calculatePageRange(surah);
      } catch (e) {
        debugPrint("Error syncing surah auto-change: $e");
      }
    }
  }

  // ... (Helpers) ...

  void _changeSurah(int newId, {bool skipJump = false}) async {
    try {
      final surah = await QuranLocalService().getSurahDetails(newId);
      if (mounted) {
        _fetchTimestamps(newId);
        
        // Only move controller if explicit jump (NOT swipe)
        if (!skipJump && _pageController.hasClients) {
          final int targetPage = QuranPageService().getPageNumber(newId, 1);
          _pageController.animateToPage(
            targetPage - 1,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
        
        setState(() {
          _currentSurahId = newId;
          _currentSurahName = surah.transliteration;
          _currentSurahData = surah;
          _surahFuture = Future.value(surah);
          _activeAyahId = null;
          _maxAyahIdSeen = -1000;
          _ayahSegments = [];
        });
        
        // Scroll to top (Guard against PageView mode)
        if (!_isPageView && _scrollController.hasClients && !skipJump) {
           _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
        
        // If it was playing, restart with new surah
        // Note: For swipe, we might want to auto-play if already playing? 
        // User didn't specify, but usually yes.
        if (_isPlaying) {
          _audioService.playSurah(newId);
        }
      }
    } catch (e) {
      debugPrint("Error changing surah: $e");
    }
  }

  static const int _bismillahId = -786;
  
  void _fetchTimestamps(int surahId) async {
    final segments = await _audioService.getAyahTimestamps(surahId);
    if (!mounted) return;

    List<AyahSegment> finalSegments = [];
    
    // Determine Bismillah Duration from Manifest
    int bismillahDuration = 0;
    if (surahId != 1 && surahId != 9) {
       bismillahDuration = ReciterManifest.getBismillahOffset(
          _audioService.currentQuranReciter, 
          surahId
       );
    }

    if (bismillahDuration > 0 && segments.isNotEmpty) {
      // 1. Prepend Bismillah
      finalSegments.add(AyahSegment(
        ayahNumber: _bismillahId,
        timestampFrom: 0,
        timestampTo: bismillahDuration,
      ));

      // 2. Shift ALL subsequent segments by the Bismillah duration
      for (var segment in segments) {
        finalSegments.add(AyahSegment(
          ayahNumber: segment.ayahNumber,
          timestampFrom: segment.timestampFrom + bismillahDuration,
          timestampTo: segment.timestampTo + bismillahDuration,
        ));
      }
    } else {
      finalSegments = List.from(segments);
    }

    setState(() {
      _ayahSegments = finalSegments;
      _maxAyahIdSeen = -1000; // Reset to allow Bismillah (-786) to be seen
      _updateActiveAyah();
    });
  }

  void _updateActiveAyah() async {
    // 1. Sanity Checks
    // 🛑 CRITICAL: If audio service is transitioning to a new Surah, 
    // ABORT page management here and let _onSurahAutoChanged handle it.
    if (_ayahSegments.isEmpty || _audioService.isTransitioning) return;
    final surah = await _surahFuture;
    if (surah == null) return;

    final currentMs = _currentPosition.inMilliseconds;
    int? foundAyahId;

    // 2. Deterministic Lookup with Fuzz Factor (Issue B)
    // Reduce currentMs slightly to avoid premature jumping at exact boundary
    final lookupMs = (currentMs > 200) ? currentMs - 200 : currentMs;
    
    for (var segment in _ayahSegments) {
      if (lookupMs >= segment.timestampFrom && lookupMs < segment.timestampTo) {
        try {
          final verse = surah.verses.firstWhere((v) => v.id == segment.ayahNumber);
          foundAyahId = verse.id;
        } catch (_) {
          foundAyahId = segment.ayahNumber;
        }
        break;
      }
    }

    // 3. STABILITY GUARD: Absolute Forward Lock
    if (foundAyahId != null && foundAyahId != _activeAyahId) {
      bool isHardRestart = _currentPosition.inMilliseconds < 800;
      bool isForward = foundAyahId! > _maxAyahIdSeen;

      if (_audioService.currentSurahId == _currentSurahId) {
        if (isForward || isHardRestart) {
          setState(() {
            _activeAyahId = foundAyahId;
            _maxAyahIdSeen = foundAyahId!;
          });
        }
      } else {
        if (_activeAyahId != null) setState(() => _activeAyahId = null);
      }
    }

    // 4. SYNC Logic (Scroll or Turn)
    if (_isPlaying) {
       final playingSurahId = _audioService.currentSurahId ?? _currentSurahId;
       final activeId = foundAyahId ?? _activeAyahId ?? 1;

       if (_isPageView) {
          // --- PAGE TURN LOGIC ---
          if (_pageController.hasClients) {
             final service = QuranPageService();
             final targetAbsPage = service.getSafePageNumber(playingSurahId, activeId);
             final targetIndex = targetAbsPage - 1; // 0-indexed Absolute Page
             
             // Sync PageView to Player's Current Location
           if (targetIndex != _currentVisualPageLocal && !_isScrolling) {
               _pageController.animateToPage(
                  targetIndex, 
                  duration: const Duration(milliseconds: 600), 
                  curve: Curves.easeInOut
               );
           }
             
             // Edge Trigger for Page Turn: If playback passes the last ayah's timestamp of the ENTIRE page
             final currentPage = _pageController.page?.round() ?? _currentVisualPageLocal;
             final currentAbsPage = currentPage + 1;
             
             final pageData = service.getPageData(currentAbsPage);
             if (pageData.isNotEmpty) {
                final lastEntry = pageData.last;
                final lastSurahOnPage = lastEntry['surah'];
                final lastAyahOnPage = lastEntry['end'];

                // If the player is finishing the very last verse of the page
                if (playingSurahId == lastSurahOnPage && activeId == lastAyahOnPage) {
                   final lastSegment = _ayahSegments.firstWhere(
                     (s) => s.ayahNumber == lastAyahOnPage,
                     orElse: () => AyahSegment(ayahNumber: -1, timestampFrom: 0, timestampTo: 99999999)
                   );
                   
                   if (lastSegment.ayahNumber != -1 && _currentPosition.inMilliseconds >= lastSegment.timestampTo - 100) {
                      final nextIndex = currentAbsPage; // index is absPage
                      if (nextIndex < 604 && nextIndex != _currentVisualPageLocal) {
                         _currentVisualPageLocal = nextIndex;
                         _pageController.animateToPage(
                            nextIndex,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut
                         );
                      }
                   }
                }
             }
          }
       } else {
          // --- SCROLL LOGIC (Legacy Continuous) ---
          if (_scrollController.hasClients && !_isScrolling) {
             try {
                // Get view width to simulate layout
                final double maxWidth = _scrollController.position.viewportDimension; 
                final double textWidth = MediaQuery.of(context).size.width - 48 - 40; 
                
                // 1. Build text ending BEFORE active ayah to find StartY
                final preActiveSpan = TextSpan(
                  children: surah.verses.where((v) => v.id < _activeAyahId!).map((v) {
                     return TextSpan(
                        text: "${v.text} ${_toArabicNumbers(v.id)} ", 
                        style: GoogleFonts.amiri(
                          fontSize: _fontSize, 
                          height: 2.2,
                        )
                     );
                  }).toList(),
                );

                final textPainter = TextPainter(
                  text: preActiveSpan,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                );
                
                textPainter.layout(maxWidth: textWidth);
                final double exactStartY = textPainter.height;

                // 2. Add Active Ayah to find EndY
                final activeAyah = surah.verses.firstWhere((v) => v.id == _activeAyahId!);
                final activeSpan = TextSpan(
                   text: "${activeAyah.text} ${_toArabicNumbers(activeAyah.id)} ", 
                   style: GoogleFonts.amiri(fontSize: _fontSize, height: 2.2),
                );
                
                final fullSpan = TextSpan(children: [preActiveSpan, activeSpan]);
                final fullPainter = TextPainter(
                   text: fullSpan,
                   textDirection: TextDirection.rtl,
                   textAlign: TextAlign.justify,
                );
                fullPainter.layout(maxWidth: textWidth);
                final double exactEndY = fullPainter.height;

                // 3. Trigger & Scroll Logic
                final double currentOffset = _scrollController.offset;
                final double viewportHeight = _scrollController.position.viewportDimension;
                
                final double visibleBottom = currentOffset + viewportHeight;
                final double safeZoneBottom = currentOffset + (viewportHeight * 0.85);
                
                double headerOffset = 20.0;
                if (surah.id != 1 && surah.id != 9) {
                   headerOffset += 70.0;
                }
                
                final double absoluteTopY = exactStartY + headerOffset;
                final double absoluteBottomY = exactEndY + headerOffset;

                bool needScroll = false;
                if (absoluteBottomY > safeZoneBottom) needScroll = true;
                if (absoluteTopY < currentOffset) needScroll = true;

                if (needScroll) {
                     _isScrolling = true;
                     double targetOffset = absoluteTopY - (viewportHeight * 0.15);
                     _scrollController.animateTo(
                        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                     ).then((_) => _isScrolling = false);
                }
             } catch (e) {
                debugPrint("Auto-scroll error: $e");
             }
          }
       }
    }
  }

  void _onDownloadStatusChanged() {
    if (mounted) {
      setState(() {
         _isDownloading = _audioService.downloadingNotifier.value;
      });
    }
  }

  void _onTransitionStatusChanged() {
    // If transitioning, we might want to show a subtle indicator or just lock logic
    if (mounted) setState(() {});
  }

  // --- Helper Logic ---

  // Converts English numbers to Arabic-Indic digits
  String _toArabicNumbers(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    
    String result = number.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }

  // Estimates the Juz number based on Surah ID (Standard approximation for Demo)
  int _getJuzForSurah(int surahId) {
    final service = QuranPageService();
    if (surahId >= 1 && surahId <= 2) return 1;
    if (surahId == 3) return 3;
    if (surahId == 4) return 4;
    // ... simplified mapping ...
     if (surahId >= 5 && surahId <= 114) {
        // Correcting Juz calculation: getJuzNumber(surah, verse)
        try {
          return service.getJuzNumber(surahId, 1);
        } catch (_) {
          return (surahId / 4).ceil(); // Fallback
        }
     }
    return 1;
  }

  String _getArabicJuzString(int juz) {
    switch (juz) {
      case 1: return "الجزء الأول";
      case 2: return "الجزء الثاني";
      case 3: return "الجزء الثالث";
      case 4: return "الجزء الرابع";
      case 5: return "الجزء الخامس";
      case 30: return "الجزء الثلاثون";
      default: return "الجزء ${_toArabicNumbers(juz)}";
    }
  }

  bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    final isDark = !_isLightMode;
    final backgroundColor = _isLightMode ? AppColors.backgroundLight : AppColors.background;
    final textColor = _isLightMode ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
    final secondaryTextColor = _isLightMode ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<QuranSurah>(
        future: _surahFuture,
        builder: (context, snapshot) {
          final surah = _currentSurahData ?? snapshot.data;
          
          if (surah == null) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: textColor)));
            } else {
              return Center(child: Text("No Surah Data", style: TextStyle(color: textColor)));
            }
          }

          final juzNumber = _getJuzForSurah(surah.id);
          final arabicJuz = _getArabicJuzString(juzNumber);

          return Stack(
            children: [
              // 0. LAYER: SANCTUARY BACKGROUND (Theme-Aware)
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
              // 1. LAYER: MAIN QURAN TEXT (PAGEVIEW)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _showControls = !_showControls);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.transparent,
                    child: _isPageView 
                        ? _buildPageView(surah, textColor)
                        : SingleChildScrollView(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 80,
                              bottom: 150,
                              left: 20,
                              right: 20,
                            ),
                            child: _buildQuranText(surah.verses, textColor, surah.id),
                          ),
                  ),
                ),
              ),

              // 2. LAYER: PERSISTENT HEADER (Surah & Juz)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _showControls ? MediaQuery.of(context).padding.top : -100,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withValues(alpha: 0.8),
                        backgroundColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(LucideIcons.arrow_left, color: textColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          Text(
                            "سورة ${surah.name}",
                            style: GoogleFonts.amiri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            arabicJuz,
                            style: GoogleFonts.amiri(
                              fontSize: 14,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(LucideIcons.settings_2, color: textColor),
                        onPressed: () => _showSettingsSheet(),
                      ),
                    ],
                  ),
                ),
              ),

              // 2.5 LAYER: IMMERSIVE OVERLAYS (Visible only when controls are HIDDEN)
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _showControls ? 0.0 : 0.6,
                  child: Stack(
                    children: [
                      // Top Center: Current Time
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 0,
                        right: 0,
                        child: StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            final now = DateTime.now();
                            final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                            return Center(
                              child: Text(
                                timeStr,
                                style: GoogleFonts.outfit(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                        ),
                      ),
                      // Top Left: Juz Context
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 24,
                        child: Text(
                          "الجزء $juzNumber".toUpperCase(),
                          style: GoogleFonts.outfit(color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Top Right: Surah Context
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 24,
                        child: Text(
                          surah.name.toUpperCase(),
                          style: GoogleFonts.outfit(color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Bottom Center: Page Number
                      Positioned(
                        bottom: MediaQuery.of(context).padding.bottom + 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "PAGE ${_currentVisualPageLocal + 1}",
                              style: GoogleFonts.outfit(color: textColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. LAYER: FLOATING AUDIO CARD & SCRUBBER
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: _showControls ? 0 : -200,
                left: 0,
                right: 0,
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFloatingAudioCard(surah, textColor, secondaryTextColor),
                      const SizedBox(height: 12),
                      _buildPageScrubber(secondaryTextColor),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingAudioCard(QuranSurah surah, Color textColor, Color secondaryTextColor) {
    final isDark = !_isLightMode;
    final tintColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: tintColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: isDark ? 0.05 : 0.03,
                    child: Image.asset(
                      'assets/images/islamic_pattern_bg.png',
                      repeat: ImageRepeat.repeat,
                      color: isDark ? null : Colors.black,
                      colorBlendMode: isDark ? null : BlendMode.srcIn,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Speed Button
                    _buildSmallControl(
                      text: "1x", 
                      onTap: () {
                        _triggerHaptic();
                      },
                      color: secondaryTextColor,
                    ),
                    
                    const Spacer(),

                    // Main Controls
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(LucideIcons.skip_back, color: textColor, size: 24),
                          onPressed: () {
                            _triggerHaptic();
                            if (surah.id > 1) _changeSurah(surah.id - 1);
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildMainPlayButton(),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(LucideIcons.skip_forward, color: textColor, size: 24),
                          onPressed: () {
                            _triggerHaptic();
                            if (surah.id < 114) _changeSurah(surah.id + 1);
                          },
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Reciter Button
                    GestureDetector(
                      onTap: () {
                        _triggerHaptic();
                        _showReciterSheet();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.mic, color: AppColors.primary, size: 20),
                          Text(
                            _audioService.currentQuranReciter.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Repeat/Loop Icon
                    IconButton(
                      icon: Icon(LucideIcons.repeat, color: secondaryTextColor, size: 20),
                      onPressed: () {
                        _triggerHaptic();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _triggerHaptic() {
    HapticFeedback.lightImpact();
  }

  Widget _buildMainPlayButton() {
    return GestureDetector(
      onTap: () {
        _triggerHaptic();
        if (_isDownloading) {
          _audioService.stop();
          return;
        }
        if (_isPlaying) {
          _audioService.pause();
        } else {
          // Explicitly call playSurah if no surah is active or it's a different one
          if (_audioService.currentSurahId == _currentSurahId) {
            _audioService.resume();
          } else {
            _audioService.playSurah(_currentSurahId);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: _isDownloading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Icon(_isPlaying ? LucideIcons.pause : LucideIcons.play, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildSmallControl({required String text, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(color: color, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPageScrubber(Color color) {
    if (!_pageController.hasClients) return const SizedBox.shrink();
    
    final currentPage = (_pageController.page?.round() ?? _currentVisualPageLocal) + 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Page $currentPage", style: GoogleFonts.outfit(color: color, fontSize: 11)),
              Text("604", style: GoogleFonts.outfit(color: color, fontSize: 11)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: color.withValues(alpha: 0.1),
              thumbColor: AppColors.primary,
            ),
            child: Slider(
              value: currentPage.toDouble(),
              min: 1,
              max: 604,
              onChanged: (val) {
                _pageController.jumpToPage(val.toInt() - 1);
                setState(() => _currentVisualPageLocal = val.toInt() - 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet() {
    _triggerHaptic();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetWrapper(
        title: "Text Settings",
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              // Theme Toggle
              _buildSettingRow(
                icon: _isLightMode ? LucideIcons.moon : LucideIcons.sun,
                label: "Visual Theme",
                trailing: Switch(
                  value: _isLightMode,
                  onChanged: (val) {
                    setState(() => _isLightMode = val);
                    setModalState(() {});
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              const Divider(color: Colors.white10),
              // Font Size
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Font Size: ${_fontSize.toInt()}pt", style: GoogleFonts.outfit(color: Colors.white70)),
                  ),
                  Slider(
                    value: _fontSize,
                    min: 15,
                    max: 80,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _fontSize = val);
                      setModalState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReciterSheet() {
    _triggerHaptic();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetWrapper(
        title: "Select Reciter",
        child: Column(
          children: [
            _buildReciterTile("Sudais", "sudais"),
            _buildReciterTile("Saad Al-Ghamdi", "saad"),
            _buildReciterTile("Mishary Alafasy", "mishary"),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterTile(String name, String value) {
    final isSelected = _audioService.currentQuranReciter == value;
    return ListTile(
      title: Text(name, style: GoogleFonts.outfit(color: isSelected ? AppColors.primary : Colors.white)),
      trailing: isSelected ? const Icon(LucideIcons.check, color: AppColors.primary) : null,
      onTap: () {
        _triggerHaptic();
        _audioService.setQuranReciter(value);
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  Widget _buildSettingRow({required IconData icon, required String label, required Widget trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label, style: GoogleFonts.outfit(color: Colors.white)),
      trailing: trailing,
    );
  }

  Widget _buildBottomSheetWrapper({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141518),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAccessibilityControls(Color textColor, Color secondaryTextColor, QuranSurah surah) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: _isLightMode ? Colors.white : const Color(0xFF141518),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Font Size Control
          Row(
            children: [
              Icon(LucideIcons.type, color: secondaryTextColor, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: secondaryTextColor.withValues(alpha: 0.2),
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: _fontSize,
                    min: 15,
                    max: 100,
                    onChanged: (val) => setState(() => _fontSize = val),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${_fontSize.toInt()}pt",
                style: GoogleFonts.outfit(
                  color: secondaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 2. Playback & Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous
              _buildNavButton(
                icon: LucideIcons.chevron_left,
                label: "Prev",
                onTap: surah.id > 1 ? () {
                   if (_isPageView) {
                      final targetSurahId = surah.id - 1;
                      // Get Start Page of Prev Surah
                      // We need to fetch it async or guess. 
                      // actually quran_page_service is synchronous for bounds if loaded? 
                      // It relies on quran package which is synchronous for metadata.
                      // Let's us use basic logic:
                      // If we trigger animateToPage, onPageChanged handles the rest.
                      // But we need the TARGET index.
                      
                      // Using a quick synchronous check if possible or fallback
                      // For now, simpler: Just jump to previous page? No, user wants PREV SURAH.
                      
                      // Let's fetch page 1 of (Surah-1)
                      // Since we don't have the object, we can't easily get verses.
                      // BUT QuranPageService.getPageNumber(surahId, 1) should work if implemented?
                      // The current service wraps 'quran' package which has 'getPageNumber(startAyah, surahId)'.
                      
                      // WORKAROUND: Just use _changeSurah(skipJump: false) for now.
                      // Animating 20 pages is risky if data not loaded.
                      _changeSurah(surah.id - 1); 
                   } else {
                      _changeSurah(surah.id - 1);
                   }
                } : null,
                secondaryTextColor: secondaryTextColor,
              ),
              
              // HUGE Play/Pause Button
              GestureDetector(
                onTap: () {
                  if (_isDownloading) {
                    _audioService.stop();
                    return; 
                  }
                  
                  if (_isPlaying) {
                     _audioService.pause();
                  } else {
                     if (_audioService.currentSurahId == _currentSurahId && _audioService.currentAsset != null) {
                        _audioService.resume();
                     } else {
                        Duration? startPos;
                        if (_activeAyahId != null && _ayahSegments.isNotEmpty) {
                           try {
                              final segment = _ayahSegments.firstWhere((s) => s.ayahNumber == _activeAyahId);
                              startPos = Duration(milliseconds: segment.timestampFrom);
                           } catch (_) {}
                        }
                        
                        _audioService.playSurah(_currentSurahId, fromPosition: startPos);
                     }
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isDownloading 
                    ? SizedBox(
                        width: 30, height: 30, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      )
                    : Icon(
                        _isPlaying ? LucideIcons.square : LucideIcons.play,
                        color: Colors.white,
                        size: 28,
                      ),
                ),
              ),
            ),

            // Next
            _buildNavButton(
              icon: LucideIcons.chevron_right,
              label: "Next",
              onTap: surah.id < 114 ? () {
                 if (_isPageView) {
                    // Try to animate to next surah start page
                    // We need to know where it starts.
                    // This is complex without async data.
                    // Fallback to standard change (which calls calculatePageRange and resets controller).
                    // This is robust.
                    _changeSurah(surah.id + 1);
                 } else {
                    _changeSurah(surah.id + 1);
                 }
              } : null,
              secondaryTextColor: secondaryTextColor,
            ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(QuranSurah surah, Color textColor) {
    // Global Quran: 604 Pages
    const totalPages = 604;

    return PageView.builder(
      controller: _pageController,
      itemCount: totalPages,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (idx) {
        HapticFeedback.lightImpact(); // Apple-style premium haptics
        final absPageNum = idx + 1; // 1-604
        setState(() {
          _currentVisualPageLocal = idx; 
        });
        
        // Detect Surah Change
        // For simplicity, we assume the surah changes if the current surah's page range is exceeded.
        // A better way is to ask: "What is the primary Surah on page X?"
        // We know that from the page data!
        
        // Let's get the PRIMARY surah on this page
        final pageData = QuranPageService().getPageData(absPageNum);
        if (pageData.isNotEmpty) {
           // Heuristic: The surah that takes up the most verses or starts here?
           // Simple Heuristic: The surah of the first verse on the page.
           final firstEntry = pageData.first;
           final sID = firstEntry['surah'];
           
           if (sID != null && sID != _currentSurahId) {
              // SWITCH SURAH (SILENTLY)
              _changeSurah(sID, skipJump: true);
           }
        }
      },
      itemBuilder: (context, index) {
        final absPageNum = index + 1;
        return _buildPage(absPageNum, textColor, surah);
      },
    );
  }

  Widget _buildPage(int absPageNum, Color textColor, QuranSurah mainSurah) {
    // 1. Get Data for this Page
    final pageData = QuranPageService().getPageData(absPageNum);
    
    // 2. Filter Verses & Handle Multi-Surah
    List<Widget> pageContent = [];
    
    for (var entry in pageData) {
       final sID = entry['surah'];
       final startAyah = entry['start'];
       final endAyah = entry['end'];
       
       // Resolve Surah Data (Main or Cache)
       QuranSurah? surahData;
       if (sID == _currentSurahId) {
         surahData = mainSurah;
       } else {
         surahData = _surahCache[sID];
         // Lazy Load if missing
         if (surahData == null) {
            QuranLocalService().getSurahDetails(sID!).then((s) {
               if (mounted) setState(() => _surahCache[sID] = s);
            });
         }
       }

       if (surahData != null) {
          // A. Add Surah Header if Start of Surah
          if (startAyah == 1) {
            final vocalizedName = kUthmaniSurahTitles[sID] ?? surahData.name;
            pageContent.add(_buildSurahHeader(vocalizedName, textColor));
          }

          // B. Add Basmala if start of surah (except 1 & 9)
           if (startAyah == 1 && sID != 1 && sID != 9) {
             pageContent.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 2),
                child: Text(
                  "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                  style: TextStyle(
                    fontFamily: 'KFGQPCUthmanic',
                    fontSize: _fontSize, 
                    color: _activeAyahId == -786 ? AppColors.primary : textColor,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
             );
          }
          
          // C. Add Verses
          try {
             final verses = surahData.verses.where((v) => v.id >= startAyah! && v.id <= endAyah!).toList();
             pageContent.add(_buildQuranText(verses, textColor, sID!));
          } catch (e) {
             // Verse not loaded
          }
       }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: _fontSize > 20 
              ? const BouncingScrollPhysics() 
              : const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60, 
            bottom: _showControls ? 140 : 80, // Less bottom padding in immersive mode
            left: 16,
            right: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - (MediaQuery.of(context).padding.top + (_showControls ? 200 : 140))),
            child: Column(
              mainAxisAlignment: (absPageNum == 1 || absPageNum == 2)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly, // Use spaceEvenly to fill the page naturally
              children: pageContent.isNotEmpty 
                ? pageContent 
                : [
                    const SizedBox(height: 50),
                    const CircularProgressIndicator(), 
                    const SizedBox(height: 20),
                    Text("Loading Surah Data...", style: TextStyle(color: textColor))
                  ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color secondaryTextColor,
  }) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: secondaryTextColor, size: 28),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSurahHeader(String surahName, Color textColor) {
    // High-Fidelity Mushaf Cartouche
    final accentColor = AppColors.primary; // Digital Sanctuary Green
    final frameColor = accentColor.withValues(alpha: 0.6);
    final bgColor = _isLightMode ? const Color(0xFFFDFBF7) : const Color(0xFF0B0C0E);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Base Outer Frame (The Patterned Band)
          ClipRect(
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.05),
                border: Border.symmetric(
                  horizontal: BorderSide(color: frameColor.withValues(alpha: 0.4), width: 1.5),
                ),
              ),
              child: Opacity(
                opacity: 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Text(
                    " ✿ ",
                    style: TextStyle(color: accentColor, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),

          // 2. Secondary Inner Frame (Double lines)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
             child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 0.8),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor.withValues(alpha: 0.15), width: 1.5),
                ),
              ),
            ),
          ),

          // 3. Side Ornaments
          Positioned(
            left: 8,
            child: Text("﴿", style: TextStyle(fontFamily: 'KFGQPCUthmanic', fontSize: 40, color: accentColor.withValues(alpha: 0.6))),
          ),
          Positioned(
            right: 8,
            child: Text("﴾", style: TextStyle(fontFamily: 'KFGQPCUthmanic', fontSize: 40, color: accentColor.withValues(alpha: 0.6))),
          ),

          // 4. Surah Title Text
          Text(
            "سُورَةُ $surahName",
            style: GoogleFonts.amiri( // Standardizing to Amiri for decorative titles
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: accentColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranText(List<QuranAyah> ayahs, Color textColor, int surahId) {
    if (ayahs.isEmpty) {
      return Text("No verses found", style: TextStyle(color: textColor));
    }

    List<InlineSpan> textSpans = [];

    // Use current playing surah for strict scoping
    final playingSurahId = _audioService.currentSurahId;

    for (var ayah in ayahs) {
      // SCoping Fix: Verify both Surah and Ayah match the current playback
      final isActive = (surahId == playingSurahId && ayah.id == _activeAyahId);
      // MARKER LOGIC: Using exact same index/id as text (User verified fix)
      final isActiveMarker = isActive; 
      
      final ayahColor = isActive ? AppColors.primary : textColor;
      
      // 1. Highlighted Verse Text + Marker (Unified Run)
      // We MUST use TextSpan (not WidgetSpan) for markers to prevent the BiDi reordering bug
      // where verses swap places in RTL centered layouts.
      textSpans.add(
        TextSpan(
          children: [
            TextSpan(
              text: " ${ayah.text} ",
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanic',
                fontSize: _fontSize, 
                height: 1.85,
                color: ayahColor,
                backgroundColor: isActive ? AppColors.primary.withOpacity(0.15) : null,
              ),
            ),
            TextSpan(
              // The \u06DD character (End of Ayah) naturally enwraps the following digits 
              // when using the KFGQPC Uthmanic font.
              text: " ${_toArabicNumbers(ayah.id)} ",
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanic',
                fontSize: _fontSize * 1.1, // slightly larger for visual clarity of the box
                color: isActiveMarker ? AppColors.primary : const Color(0xFFD4AF37),
                height: 1.0,
                letterSpacing: -0.5, // subtle squeeze to ensure ligature triggers correctly
              ),
            ),
          ],
        ),
      );
    }

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: TextAlign.center, // center for better vertical fit and alignment stability
      textDirection: TextDirection.rtl,
    );
  }
}
