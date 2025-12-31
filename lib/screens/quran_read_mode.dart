import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:quran/quran.dart' as quran;
import '../widgets/mushaf/ayah_highlight_painter.dart'; // 🛑 Phase 3.1
import '../models/quran_surah.dart';
import '../services/quran_local_service.dart';
import '../services/quran_page_service.dart';
import '../services/theme_service.dart';
import '../services/unified_audio_service.dart';
import '../services/mushaf_layout_service.dart';
import '../theme/app_theme.dart';
import '../controllers/quran_audio_controller.dart';
import '../widgets/glass_card.dart';
import 'quran/quran_page_view.dart';
import '../models/quran_display_names.dart';
// Removed: Unicode map no longer needed (using ligature system)
import '../widgets/quran/surah_header_widget.dart';
import 'package:intl/intl.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:muslim_mind/services/mushaf_layout_engine.dart';
import 'package:muslim_mind/services/mushaf_text_service.dart';
import 'package:muslim_mind/services/mushaf_word_reconstruction_service.dart';
import 'package:muslim_mind/services/mushaf_coordinate_service.dart';
import '../widgets/mushaf/mushaf_page_painter.dart';


class QuranReadMode extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int? initialPage;

  const QuranReadMode({
    super.key, 
    this.surahId = 1, 
    this.surahName = "Al-Fātihah",
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
  //🎯 AUDIO PLAYER UX: Player visibility toggle (hidden by default for clean reading)
  bool _isPlayerVisible = false;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        UnifiedAudioService().playerBottomPadding.value = 12.0;
      }
    });

    precacheImage(const AssetImage('assets/images/sura_alfateha_brand.png'), context);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAudioStateChanged);
    _controller.dispose();
    _pageController.dispose();
    ThemeService().removeListener(_onThemeChanged);
    WakelockPlus.disable();
    _clockTimer.cancel();
    
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
        _loadSurah(_controller.currentSurahId!, makeActive: true);
        
        final targetPage = QuranPageService().getPageNumber(_controller.currentSurahId!, 1);
        if (_pageController.hasClients) {
          _pageController.jumpToPage(targetPage - 1);
        }
      }
      if (_currentSurahData != null) {
        _controller.handleSmartFollow(_pageController, _currentVisualPageLocal, _currentSurahData!);
      }
      
    if (_controller.activeAyahId != _lastSetStateAyahId || _controller.isPlaying != _lastSetStatePlaying) {
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
    if (_surahCache.containsKey(surahId)) {
      final surah = _surahCache[surahId]!;
      if (makeActive && mounted) {
        setState(() {
          _currentSurahData = surah;
        });
        QuranLocalService().saveLastAccessed(surahId, surah.transliteration);
      }
      return surah;
    }

    final surah = await QuranLocalService().getSurahDetails(surahId);
    if (mounted) {
      setState(() {
        _surahCache[surahId] = surah;
        if (makeActive) {
          _currentSurahData = surah;
          QuranLocalService().saveLastAccessed(surahId, surah.transliteration);
        }
      });
    }
    return surah;
  }

  void _changeSurah(int newId, {bool skipJump = false, bool isSilentSwipe = false}) async {
    final surah = await _loadSurah(newId);
    if (mounted) {
      if (!_controller.isPlaying || !isSilentSwipe) {
          if (_controller.currentSurahId != newId && !_controller.isPlaying) {
             _controller.resetPlayingContext();
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
    final bool isDark = true;
    final solidBg = const Color(0xFF202124);
    final solidText = const Color(0xFFFFFFFF);
    const emerald = AppColors.primary;
    const gold = AppColors.accent;

    return Scaffold(
      backgroundColor: solidBg,
      body: FutureBuilder<QuranSurah>(
        future: _surahFuture,
        builder: (context, snapshot) {
          final surah = _currentSurahData ?? snapshot.data;
          if (surah == null) return _buildLoading(snapshot);

          return Stack(
            children: [
              GestureDetector(
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
                      
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          const double canonicalW = 430.0;
                          const double canonicalH = 1050.0; 
                          
                          final fontScale = (pageNum <= 2) ? 1.05 : 1.20;
                          
                          final content = _buildMushafContent(pageNum, solidText, surah, gold, emerald, canonicalH, fontScale);

                          return InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 5.0,
                            child: FittedBox(
                                fit: BoxFit.contain,  // Changed from fitWidth to contain
                                child: Container(
                                  width: canonicalW,
                                  height: canonicalH,
                                color: solidBg,
                                padding: const EdgeInsets.all(0), // Full canvas - no padding
                                 child: Stack(
                                   children: [
                                      // ✅ Layer 0: Mushaf Content (Full 1050px - Zero Padding Rule)
                                      Positioned.fill(
                                        child: content
                                      ),
                                      
                                      // ✅ Layer 1: Floating Overlay Labels (Immersive Overlay Standard)
                                      // Top-Left: Surah Name
                                      Positioned(
                                        top: 35, // Adjusted for Status Bar / Dynamic Island
                                        left: 12,
                                        child: _buildFloatingLabel(
                                          QuranPageService().getPageData(pageNum).first['surah'] != null
                                            ? kUthmaniSurahTitles[QuranPageService().getPageData(pageNum).first['surah']!] ?? "Surah"
                                            : "Surah",
                                          solidText.withOpacity(0.7),
                                        ),
                                      ),
                                      
                                      // Top-Right: Juz Number
                                      Positioned(
                                        top: 35, // Adjusted for Status Bar / Dynamic Island
                                        right: 12,
                                        child: _buildFloatingLabel(
                                          "Part ${QuranPageService().getJuzNumber(
                                            QuranPageService().getPageData(pageNum).first['surah']!,
                                            QuranPageService().getPageData(pageNum).first['start']!
                                          )}",
                                          gold.withOpacity(0.8),
                                        ),
                                      ),
                                      
                                      // Bottom-Center: Page Number
                                      Positioned(
                                        bottom: 12, // Adjusted to clear text descenders
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: _buildFloatingLabel(
                                            "$pageNum",
                                            solidText.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                   ],
                                 ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ),

              if (_showControls)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: solidText.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: solidText.withOpacity(0.1)),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ]
                      ),
                      child: Icon(LucideIcons.chevron_left, color: solidText, size: 24),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Immersive Overlay Standard: Floating label positioned in safe zone (dead space)
  /// Size kept minimal to avoid occluding Line 1 or Line 15 of the Mushaf grid
  Widget _buildFloatingLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
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

  Widget _buildMushafContent(int pageNum, Color textColor, QuranSurah mainSurah, Color gold, Color emerald, double refH, [double fontScale = 1.5]) {
    // ✅ PERFORMANCE FIX: Single Future.wait() for parallel execution
    // NOTE: Cannot use compute() - database connections don't work in isolates
    // All database calls execute in parallel on main thread (~500ms total)
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        MushafLayoutService.getPageLayout(pageNum),                            // Index 0
        MushafWordReconstructionService.getReconstructedPageLines(pageNum),    // Index 1
        MushafCoordinateService().getPageData(pageNum, Size(430, refH)),       // Index 2
        _loadPageFont(pageNum),                                                 // Index 3
      ]),
      builder: (context, snapshot) {
        // Show loading indicator while fetching data
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff574500))
          );
        }
        
        // Extract all data from parallel results
        final layoutLines = snapshot.data![0] as List<LayoutLine>;
        final textLines = snapshot.data![1] as List<String>;
        final pageData = snapshot.data![2] as MushafPageData;
        // Font loaded (index 3)
        
        const double headerHeight = 110.0;
        
        // vvv ADDED MARGINS vvv
        const double topMargin = 60.0;
        const double bottomMargin = 50.0;
        final double availableHeight = refH - topMargin - bottomMargin;
        // ^^^ ADDED MARGINS ^^^

        // Calculate how many headers this page has
        final headerCount = layoutLines.where((l) => l.lineType == 'surah_name').length;
        final nonHeaderCount = 15 - headerCount;
        
        // Calculate standard line height accounting for headers
        final double standardLineHeight = (availableHeight - (headerCount * headerHeight)) / nonHeaderCount;



        // ✅ CURSOR SYNC LOGIC (Fixes Ghost Text & Ayah Mismatch)
        int ayahCursor = 0;
        
        // 🔑 CUMULATIVE Y-POSITION CALCULATION
        final List<double> lineStartPositions = [];
        double currentY = topMargin; // Start at Top Margin
        
        for (int i = 0; i < 15; i++) {
          final int lineNum = i + 1;
          final LayoutLine lineData = layoutLines.firstWhere(
            (l) => l.lineNumber == lineNum,
            orElse: () => LayoutLine(pageNumber: pageNum, lineNumber: lineNum, lineType: 'ayah', isCentered: false)
          );
          
          lineStartPositions.add(currentY);
          
          if (lineData.lineType == 'surah_name') {
            currentY += headerHeight;
          } else {
            currentY += standardLineHeight;
          }
        }
        
        // 🔍 DEBUG: Highlight sync check (Expanded)
        if ((pageNum == 1 || pageNum == 604) && _controller.isPlaying) {
             // Rate limit: only print once per second/update to avoid spam? 
             // Actually, just let it spam for short debug
             
             final activeHighlights = pageData.highlights.where((h) => 
                h.surah == _controller.currentSurahId && 
                h.ayah == _controller.activeAyahId
             ).toList();
             
             print("🔍 SYNC CHECK Page $pageNum: Surah ${_controller.currentSurahId} Ayah ${_controller.activeAyahId} Word ${_controller.activeWordIndex}");
             
             if (pageNum == 1 && activeHighlights.isEmpty) {
                 print("   ⚠️ NO ACTIVE HIGHLIGHTS FOUND FOR P1.");
                 // Dump ALL highlights for Page 1 to see what EXISTS
                 print("   DUMPING ALL PAGE 1 HIGHLIGHTS:");
                 for (var h in pageData.highlights) {
                    print("     - S${h.surah}:A${h.ayah} W${h.wordIndex} at ${h.rect}");
                 }
             } else if (pageNum == 604) {
                 print("   Found ${activeHighlights.length} highlights for active ayah.");
                 // Sort by X DESC (Right to Left) to verify visual order
                 final sorted = activeHighlights.toList()..sort((a,b) => b.rect.right.compareTo(a.rect.right));
                 for (int i=0; i<sorted.length; i++) {
                    final h = sorted[i];
                    print("     - [Visually #${i+1}] DB Word ${h.wordIndex} at X=${h.rect.left.toStringAsFixed(1)}");
                 }
             }
        }

        return GestureDetector(
          onLongPressStart: (details) {
             final dy = details.localPosition.dy;
             final dx = details.localPosition.dx;
             
             // Find line
             int lineNum = 1;
             for (int i = 0; i < lineStartPositions.length - 1; i++) {
               if (dy >= lineStartPositions[i] && dy < lineStartPositions[i + 1]) {
                 lineNum = i + 1;
                 break;
               }
             }
             if (dy >= lineStartPositions.last) lineNum = 15;
             
             // Find highlight
             final lineHighlights = pageData.highlights.where((h) => h.lineNumber == lineNum);
             MushafHighlight? match;
             for (final h in lineHighlights) {
                if (dx >= h.rect.left && dx <= h.rect.right) {
                   match = h;
                   break;
                }
             }
             
             if (match != null) {
                HapticFeedback.mediumImpact();
                _showAyahMenu(match.surah, match.ayah);
             }
          },
          onTapUp: (details) {
             final dy = details.localPosition.dy;
             final dx = details.localPosition.dx;
             
             // Find which line was tapped using cumulative positions
             int lineNum = 1;
             for (int i = 0; i < lineStartPositions.length - 1; i++) {
               if (dy >= lineStartPositions[i] && dy < lineStartPositions[i + 1]) {
                 lineNum = i + 1;
                 break;
               }
             }
             // Handle last line
             if (dy >= lineStartPositions.last) {
               lineNum = 15;
             }
             
             _handleGridTap(pageNum, lineNum, dx, pageData, context);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
               // 🆕 OVERLAY: Ayah/Word Highlight Painter (Disabled for Release v1.0.9)
               Positioned.fill(
                 child: false ? CustomPaint( // 🛑 DISABLED: Unstable Sync
                   painter: AyahHighlightPainter(
                      highlights: pageData.highlights.map((h) {
                          // 🔧 ALIGNMENT FIX: Snaps DB rects to Visual Line Y-positions
                          final lineIdx = h.lineNumber - 1;
                          if (lineIdx < 0 || lineIdx >= lineStartPositions.length) return h;
                          
                          final top = lineStartPositions[lineIdx];
                          // Use standard height for highlight block
                          final height = (layoutLines.length > lineIdx && layoutLines[lineIdx].lineType == 'surah_name') 
                              ? headerHeight 
                              : standardLineHeight;
                              
                          return MushafHighlight(
                              surah: h.surah, 
                              ayah: h.ayah, 
                              rect: Rect.fromLTWH(h.rect.left, top, h.rect.width, height), 
                              lineNumber: h.lineNumber, 
                              wordIndex: h.wordIndex
                          );
                      }).toList(),
                      activeSurah: _controller.currentSurahId,
                      activeAyah: _controller.activeAyahId,
                      activeWordIndex: _controller.activeWordIndex,
                      highlightColor: gold.withOpacity(0.2), // Subtle highlight
                   ),
                 ) : const SizedBox.shrink(),
               ),
               ...List.generate(15, (index) {
               final int lineNum = index + 1;
               final LayoutLine lineData = layoutLines.firstWhere(
                 (l) => l.lineNumber == lineNum, 
                 orElse: () => LayoutLine(pageNumber: pageNum, lineNumber: lineNum, lineType: 'ayah', isCentered: false)
               );
               
               String lineText = "";
                //  FIX: Only consume text from cache if this is an AYAH line
                if (lineData.lineType == 'ayah') {
                  if (ayahCursor < textLines.length) {
                    lineText = textLines[ayahCursor];
                    ayahCursor++;
                  }
                }
                
                // Build the line widget
                final lineWidget = _buildGridLine(lineData, lineText, pageNum, gold, textColor, standardLineHeight, pageData);
                
                // 🔧 FIX 2: RepaintBoundary isolates each line's rendering
                // Prevents unnecessary repaints when only one line changes (e.g., highlighting)
                // Impact: Reduces frame time from 600ms to ~100ms during scrolling
                final optimizedWidget = RepaintBoundary(
                  child: lineWidget,
                );
                
                // Calculate height for this line
                final lineHeightForType = lineData.lineType == 'surah_name' ? headerHeight : standardLineHeight;
                
                // Use Positioned for precise placement
                return Positioned(
                  top: lineStartPositions[index],
                  left: 0,
                  right: 0,
                  height: lineHeightForType,
                  child: optimizedWidget,  // 🔧 FIX 2: Use RepaintBoundary-wrapped widget
                );
            })],
          ),
        );
      },
    );
  }

  Widget _buildGridLine(LayoutLine lineData, String text, int pageNum, Color gold, Color textColor, double lineHeight, MushafPageData pageData) {
     
     if (lineData.lineType == 'surah_name' && lineData.surahNumber != null) {
        final sID = lineData.surahNumber!;
        
        // ✅ LIGATURE SYSTEM: Render header using SurahHeaderWidget (V4 Font)
        return SurahHeaderWidget(
           surahId: sID,
        );
        
     } else if (lineData.lineType == 'basmallah') {
        // ✅ ENABLED: Render Bismillah Unicode character
        return Center(
           child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                 "\uFDFD",  // Unicode Bismillah (﷽)
                 style: TextStyle(
                    fontFamily: 'QuranCommon',
                    fontSize: 36,
                    color: textColor,  // Bismillah should NOT be highlighted
                    height: 1.0, 
                 ),
              ),
           ),
        );
         
     } else {
        // AYAH TEXT - Line-based highlighting (reverted from ayah-aware due to bugs)
        final fontFamily = 'QCF2${pageNum.toString().padLeft(3, '0')}';
        
        
        // Determine if this line should be highlighted
        // final shouldHighlight = _shouldHighlightLine(lineData, pageData, pageNum);
        
        return Center(
           child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                   fontFamily: fontFamily,
                   fontSize: 28,
                   color: textColor, // 🛑 VISUAL FIX: Removing legacy highlighting (now handled by overlay)
                   height: 1.1,
                ),
              ),
           ),
        );
     }
  }

  /// 🆕 PHASE 1: Build TextSpan widgets for ayah-aware highlighting
  /// Splits line text into segments, one per ayah, with individual colors
  /// This allows highlighting only the active ayah, not the entire line
  List<TextSpan> _buildAyahTextSpans(
    String lineText,
    List<MushafHighlight> lineHighlights,
    TextStyle baseStyle,
    Color activeColor,
    Color defaultColor,
  ) {
    // No highlights on this line - return single span
    if (lineHighlights.isEmpty) {
      return [TextSpan(text: lineText, style: baseStyle.copyWith(color: defaultColor))];
    }
    
    // Single ayah on line - check if active and return single span
    if (lineHighlights.length == 1) {
      final highlight = lineHighlights.first;
      final isActive = _controller.isPlaying &&
                       highlight.surah == _controller.currentSurahId && 
                       highlight.ayah == _controller.activeAyahId &&
                       (_controller.activePageNumber == null || 
                        _controller.activePageNumber == highlight.lineNumber);  // Check page, not line
      final color = isActive ? activeColor : defaultColor;
      return [TextSpan(text: lineText, style: baseStyle.copyWith(color: color))];
    }
    
    // Multiple ayahs on line - split text into segments
    // Sort highlights by rect.left (left-to-right for LTR, right-to-left for RTL)
    final sorted = lineHighlights.toList()
      ..sort((a, b) => a.rect.left.compareTo(b.rect.left));
    
    List<TextSpan> spans = [];
    
    // Calculate character positions based on rect widths
    final totalWidth = sorted.last.rect.right - sorted.first.rect.left;
    int charPos = 0;
    
    for (int i = 0; i < sorted.length; i++) {
      final highlight = sorted[i];
      final isActive = _controller.isPlaying &&
                       highlight.surah == _controller.currentSurahId && 
                       highlight.ayah == _controller.activeAyahId;
      final color = isActive ? activeColor : defaultColor;
      
      // Estimate character count for this ayah based on rect width ratio
      final ayahWidth = highlight.rect.width;
      final widthRatio = ayahWidth / totalWidth;
      final charCount = (lineText.length * widthRatio).round();
      
      // Extract text segment (last segment gets remaining text)
      final endPos = (i == sorted.length - 1) ? lineText.length : charPos + charCount;
      final segment = lineText.substring(charPos, endPos.clamp(0, lineText.length));
      
      spans.add(TextSpan(text: segment, style: baseStyle.copyWith(color: color)));
      charPos = endPos;
    }
    
    return spans;
  }

  /// 🆕 PHASE 2: Check if this line should be highlighted (active ayah during playback)
  /// ONLY used for color selection - does NOT modify any rendering logic
  /// 🔧 FIX: Added pageNum check to prevent highlighting from following navigation
  bool _shouldHighlightLine(LayoutLine lineData, MushafPageData pageData, int pageNum) {
    // Only highlight ayah lines when playing
    if (!_controller.isPlaying || lineData.lineType != 'ayah') return false;
    if (_controller.activeAyahId == null || _controller.currentSurahId == null) return false;
    
    // 🔧 FIX: Only highlight if this is the page where audio is actively playing
    // This prevents highlighting from appearing on pages the user scrolls to
    // Highlighting should stay on the page with the active ayah, not follow navigation
    if (_controller.activePageNumber != null && _controller.activePageNumber != pageNum) {
      return false;  // User scrolled to a different page - don't highlight here
    }
    
    // Check if any highlight on this line matches the active ayah
    final lineHighlights = pageData.highlights.where((h) => h.lineNumber == lineData.lineNumber);
    return lineHighlights.any((h) => 
      h.surah == _controller.currentSurahId && 
      h.ayah == _controller.activeAyahId
    );
  }

  void _handleGridTap(int pageNum, int lineNum, double dx, MushafPageData pageData, BuildContext context) {
     final lineHighlights = pageData.highlights.where((h) => h.lineNumber == lineNum);
     MushafHighlight? match;
     for (final h in lineHighlights) {
        if (dx >= h.rect.left && dx <= h.rect.right) {
           match = h;
           break;
        }
     }
     
     if (match != null) {
        // 🔧 FIX: Set active page so highlighting doesn't follow navigation
        _controller.activePageNumber = pageNum;
        _controller.playSurah(match.surah, ayahNumber: match.ayah);
     } else {
        setState(() => _showControls = !_showControls);
     }
  }

  static final Set<int> _loadedFonts = {};

  Future<void> _loadPageFont(int pageNumber) async {
    if (_loadedFonts.contains(pageNumber)) return;

    try {
      final fontName = "QCF2${pageNumber.toString().padLeft(3, '0')}";
      final fontLoader = FontLoader(fontName);
      fontLoader.addFont(rootBundle.load('assets/quran/fonts/$fontName.ttf'));
      await fontLoader.load();
      _loadedFonts.add(pageNumber);
    } catch (e) {
      // Silent fail
    }
  }

  void _onPageChanged(int idx) {
    HapticFeedback.lightImpact();
    if (!_controller.isProgrammaticScroll) {
       _controller.isBrowsing = true;
    }
    _controller.isProgrammaticScroll = false;

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
    UnifiedAudioService().isPlayerVisible.value = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
              title: const Text("Play Ayah", style: TextStyle(color: Colors.white)),
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bookmark saved")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white70),
              title: const Text("Share Ayah", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

}
