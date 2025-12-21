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
import '../theme/app_theme.dart';
import '../controllers/quran_audio_controller.dart';
import 'quran/quran_page_view.dart';
import '../models/quran_display_names.dart';

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

    _surahFuture = _loadSurah(widget.surahId);
    
    WakelockPlus.enable();
    ThemeService().addListener(_onThemeChanged);
    _controller.addListener(_onAudioStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAudioStateChanged);
    _controller.dispose();
    _pageController.dispose();
    ThemeService().removeListener(_onThemeChanged);
    WakelockPlus.disable();
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }
  
  int? _lastSetStateAyahId;
  bool? _lastSetStatePlaying;

  void _onAudioStateChanged() {
    if (mounted) {
      if (_controller.currentSurahId != null && _controller.currentSurahId != _currentSurahData?.id) {
        _loadSurah(_controller.currentSurahId!);
      }
      if (_currentSurahData != null) {
        _controller.handleSmartFollow(_pageController, _currentVisualPageLocal, _currentSurahData!);
      }
      
      // 🛑 OPTIMIZATION: Only rebuild the whole page if the active ayah or play state changed.
      // The progress slider and other small elements will use granular builders.
      if (_controller.activeAyahId != _lastSetStateAyahId || _controller.isPlaying != _lastSetStatePlaying) {
        _lastSetStateAyahId = _controller.activeAyahId;
        _lastSetStatePlaying = _controller.isPlaying;
        setState(() {});
      }
    }
  }

  Future<QuranSurah> _loadSurah(int surahId) async {
    final surah = await QuranLocalService().getSurahDetails(surahId);
    if (mounted) {
      setState(() {
        _currentSurahData = surah;
        _surahCache[surahId] = surah;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.background : AppColors.backgroundLight;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<QuranSurah>(
        future: _surahFuture,
        builder: (context, snapshot) {
          final surah = _currentSurahData ?? snapshot.data;
          if (surah == null) return _buildLoading(snapshot);

          return GestureDetector(
            onScaleStart: (d) => _baseFontSize = _fontSize,
            onScaleUpdate: (d) => setState(() => _fontSize = (_baseFontSize * d.scale).clamp(15.0, 70.0)),
            child: Stack(
              children: [
                _buildBackground(accentColor, backgroundColor),
                _buildPageViewContent(surah, textColor),
                _buildHeader(surah, textColor, backgroundColor),
                _buildImmersiveOverlays(surah, textColor, isDark),
                _buildFloatingControls(surah, textColor, isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading(AsyncSnapshot snapshot) {
    if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildBackground(Color accent, Color bg) => Positioned.fill(
    child: Container(decoration: BoxDecoration(gradient: RadialGradient(center: const Alignment(-0.2, -0.6), radius: 1.5, colors: [accent, bg], stops: const [0.0, 0.7]))),
  );

  Widget _buildPageViewContent(QuranSurah surah, Color textColor) => Positioned.fill(
    child: GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); setState(() => _showControls = !_showControls); },
      behavior: HitTestBehavior.translucent,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 604,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) => _buildMushafPage(index + 1, textColor, surah),
      ),
    ),
  );

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

  void _showSeekConfirmation(int surahId, int ayahId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Play from this Verse?", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text("Would you like to start the recitation from Surah ${quran.getSurahName(surahId)}, Verse $ayahId?", style: GoogleFonts.outfit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _controller.isBrowsing = false; // Reset browsing intent on manual seek
              _controller.playSurah(surahId, ayahNumber: ayahId);
            },
            child: Text("Play", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMushafPage(int pageNum, Color textColor, QuranSurah mainSurah) {
    final pageData = QuranPageService().getPageData(pageNum);
    List<Widget> content = [];
    for (var entry in pageData) {
      final sID = entry['surah']!;
      final surahData = (sID == _currentSurahData?.id) ? mainSurah : _surahCache[sID];
      if (surahData == null) { _loadSurah(sID); continue; }
      
      if (entry['start'] == 1) content.add(SurahHeaderCartouche(surahName: kUthmaniSurahTitles[sID] ?? surahData.name, textColor: textColor));
      if (entry['start'] == 1 && sID != 1 && sID != 9) {
        content.add(Padding(padding: const EdgeInsets.only(bottom: 6, top: 2), child: Text("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", style: TextStyle(fontFamily: 'KFGQPCUthmanic', fontSize: _fontSize, color: _controller.activeAyahId == -786 ? AppColors.primary : textColor, height: 1.3), textAlign: TextAlign.center)));
      }
      content.add(QuranPageView(verses: surahData.verses.where((v) => v.id >= entry['start']! && v.id <= entry['end']!).toList(), fontSize: _fontSize, activeAyahId: _controller.activeAyahId, textColor: textColor, surahId: sID, playingSurahId: _controller.currentSurahId, onAyahDoubleTap: (s, a) => _showSeekConfirmation(s, a), align: pageNum <= 2 ? TextAlign.center : TextAlign.justify));
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60, bottom: _showControls ? 200 : 100, left: 16, right: 16),
      child: Column(children: content),
    );
  }

  Widget _buildHeader(QuranSurah surah, Color textColor, Color bgColor) => AnimatedPositioned(
    duration: const Duration(milliseconds: 300),
    top: _showControls ? MediaQuery.of(context).padding.top : -100, left: 0, right: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [bgColor.withValues(alpha: 0.8), bgColor.withValues(alpha: 0.0)])),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(icon: Icon(LucideIcons.arrow_left, color: textColor), onPressed: () => Navigator.pop(context)),
        Text("سورة ${surah.name}", style: GoogleFonts.amiri(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        IconButton(icon: Icon(LucideIcons.settings_2, color: textColor), onPressed: () {}), // Logic simplified for brevity
      ]),
    ),
  );

  Widget _buildImmersiveOverlays(QuranSurah surah, Color textColor, bool isDark) => IgnorePointer(
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 400), opacity: _showControls ? 0.0 : 0.6,
      child: Stack(children: [
        Positioned(bottom: MediaQuery.of(context).padding.bottom + 20, left: 0, right: 0, child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)), child: Text("PAGE ${_currentVisualPageLocal + 1}", style: GoogleFonts.outfit(color: textColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1))))),
      ]),
    ),
  );

  Widget _buildFloatingControls(QuranSurah surah, Color textColor, bool isDark) => AnimatedPositioned(
    duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic,
    bottom: _showControls ? 0 : -350, left: 0, right: 0,
    child: SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
       ListenableBuilder(
         listenable: _controller,
         builder: (context, _) => _buildAudioCard(surah, textColor, isDark),
       ),
       const SizedBox(height: 12),
    ])),
  );

  Widget _buildAudioCard(QuranSurah surah, Color textColor, bool isDark) {
    final progress = (_controller.totalDuration.inMilliseconds > 0) ? (_controller.currentPosition.inMilliseconds / _controller.totalDuration.inMilliseconds).clamp(0.0, 1.0) : 0.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: const Offset(0, 12))]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(LucideIcons.cast, color: AppColors.primary, size: 24),
          Text("${surah.transliteration}: ${surah.id}", style: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.6))),
          IconButton(icon: Icon(LucideIcons.x, size: 18), onPressed: () => _controller.stop()),
        ]),
        Slider(value: progress, onChanged: (v) => _controller.seek(Duration(milliseconds: (v * _controller.totalDuration.inMilliseconds).toInt()))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: const Icon(Icons.fast_rewind_rounded, size: 32), 
            onPressed: () {
              if (surah.id > 1) _changeSurah(surah.id - 1);
            },
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () {
              if (_controller.isPlaying) {
                _controller.pause();
              } else {
                _controller.isBrowsing = false; 
                // If user swiped to a new surah while paused, start THAT surah.
                if (_controller.currentSurahId != _currentSurahData?.id) {
                   _controller.playSurah(_currentSurahData!.id);
                } else {
                   _controller.resume();
                }
              }
            },
            child: SizedBox(
              width: 56,
              height: 56,
              child: (_controller.isDownloading || _controller.isTransitioning) && !_controller.isPlaying
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
                    )
                  : Icon(
                      _controller.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 56,
                      color: AppColors.primary,
                    ),
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(Icons.fast_forward_rounded, size: 32), 
            onPressed: () {
              if (surah.id < 114) _changeSurah(surah.id + 1);
            },
          ),
        ]),
      ]),
    );
  }
}
