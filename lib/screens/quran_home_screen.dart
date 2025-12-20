import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/models/quran_display_names.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/services/quran_local_service.dart';
import 'package:muslim_life_ai_demo/screens/hadith_screen.dart';
import 'package:muslim_life_ai_demo/screens/quran_read_mode.dart';
import 'package:muslim_life_ai_demo/screens/quran_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:muslim_life_ai_demo/services/quran_page_service.dart';
import 'package:quran/quran.dart' as quran;

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  int _selectedTabIndex = 0;
  bool _isJuzMode = false; 
  bool _isSearchMode = false; // New Library View state
  List<QuranSurah> _allSurahs = [];
  List<QuranSurah> _filteredSurahs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String? _ayahNavigationTarget; // e.g., "2:255"
  final UnifiedAudioService _audioService = UnifiedAudioService();
  
  // Fast Scroll State
  int? _hoveredJuz;
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final surahs = await QuranLocalService().loadSurahIndex();
      if (mounted) {
        setState(() {
          _allSurahs = surahs;
          _filteredSurahs = surahs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint("Error loading data: $e");
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    _filterSurahs(query);
  }

  // Estimates the Juz number based on Surah ID (Standard approximation for Demo)
  int _getJuzForSurah(int surahId) {
    if (surahId >= 1 && surahId <= 2) return 1;
    if (surahId == 3) return 3;
    if (surahId == 4) return 4;
    // ... simplified mapping for brevity ...
    if (surahId >= 5 && surahId <= 114) {
       return (surahId / 4).ceil(); 
    }
    return 1;
  }

  // Returns the range of Surah IDs [start, end] for a given Juz
  List<int> _getSurahRangeForJuz(int juz) {
     // Concise mapping for standard Juz starts. 
     // Note: This is an approximation where Surahs span Juz.
     // We map "Surahs predominantly in this Juz" or "Starts in this Juz".
     // User specifically requested 29 (67-77) and 30 (78-114).
     switch (juz) {
       case 1: return [1, 2];
       case 2: return [2, 2];
       case 3: return [2, 3];
       case 4: return [3, 4];
       case 5: return [4, 4];
       case 6: return [4, 5];
       case 7: return [5, 6];
       case 8: return [6, 7];
       case 9: return [7, 8];
       case 10: return [8, 9];
       case 11: return [9, 11];
       case 12: return [11, 12];
       case 13: return [12, 14];
       case 14: return [15, 16];
       case 15: return [17, 18];
       case 16: return [19, 20];
       case 17: return [21, 22];
       case 18: return [23, 25];
       case 19: return [25, 27];
       case 20: return [27, 29];
       case 21: return [29, 33];
       case 22: return [33, 36];
       case 23: return [36, 39];
       case 24: return [39, 41];
       case 25: return [41, 45];
       case 26: return [46, 51];
       case 27: return [51, 57];
       case 28: return [58, 66];
       case 29: return [67, 77]; // As requested
       case 30: return [78, 114]; // As requested
       default: return [1, 114]; // Fallback
     }
  }

  void _filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSurahs = _allSurahs;
        _ayahNavigationTarget = null;
      });
      return;
    }

    // Check for "Surah:Ayah" pattern (e.g., "2:255")
    final ayahRegex = RegExp(r'^(\d+):(\d+)$');
    final match = ayahRegex.firstMatch(query);
    if (match != null) {
      final surahNum = int.parse(match.group(1)!);
      final ayahNum = int.parse(match.group(2)!);
      
      final surah = _allSurahs.firstWhere(
        (s) => s.id == surahNum, 
        orElse: () => QuranSurah(id: -1, name: "", transliteration: "", type: "", totalVerses: 0, verses: [])
      );

      if (surah.id != -1) {
        setState(() {
          _filteredSurahs = [surah];
          _ayahNavigationTarget = "$surahNum:$ayahNum";
        });
        return;
      }
    }

    // Check for "Juz X" or just "X" (if X is a valid Juz number 1-30)
    // We treat "1" as Surah 1, but "Juz 1" as Juz 1 range.
    // If user types just "30", it could be Surah 30 or Juz 30. 
    // Usually "30" matches Surah 30 (Ar-Rum).
    // So distinct filtering for "juz" keyword is safer.
    
    int? juzQuery;
    if (query.startsWith("juz ")) {
      final parts = query.split(" ");
      if (parts.length > 1) {
        juzQuery = int.tryParse(parts[1]);
      }
    }

    if (juzQuery != null && juzQuery >= 1 && juzQuery <= 30) {
       final range = _getSurahRangeForJuz(juzQuery);
       final startId = range[0];
       final endId = range[1];
       setState(() {
         _ayahNavigationTarget = null;
         _filteredSurahs = _allSurahs.where((s) => s.id >= startId && s.id <= endId).toList();
       });
       return;
    }

    setState(() {
      _ayahNavigationTarget = null;
      _filteredSurahs = _allSurahs.where((surah) {
        final surahNum = surah.id.toString();
        final englishName = surah.transliteration.toLowerCase();
        final arabicName = surah.name; 
        // We can keep the old approximate filter as well or remove it in favor of specific Juz search
        final juzNum = _getJuzForSurah(surah.id);
        final juzString = "juz $juzNum";

        return surahNum.contains(query) ||
               englishName.contains(query) ||
               arabicName.contains(query) || 
               (query.startsWith("juz") && juzString.contains(query));
      }).toList();
    });
  }

  void _handleSurahTap(BuildContext context, int surahId, String surahName, {int? initialPage}) {
    // Phase 1.5: Direct Read Mode - No more interruption for elders
    _navigateToMode(context, true, surahId, surahName, initialPage: initialPage);
  }

  void _navigateToMode(BuildContext context, bool isReadMode, int surahId, String surahName, {int? initialPage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isReadMode 
          ? QuranReadMode(surahId: surahId, surahName: surahName, initialPage: initialPage) 
          : QuranScreen(surahId: surahId, surahName: surahName),
      ),
    );
  }

  void _showModeSelectionDialog(BuildContext context, int surahId, String surahName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0B0C0E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Mode",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Removed persistence
                        Navigator.pop(context);
                        _navigateToMode(context, true, surahId, surahName);
                      },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.15), // Gold Tint
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            children: [
                              const Icon(LucideIcons.book_open,
                                  color: Color(0xFFD4AF37), size: 32),
                              const SizedBox(height: 12),
                              Text(
                                "READ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: const Color(0xFFD4AF37),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Digital Mushaf",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Removed persistence
                        Navigator.pop(context);
                        _navigateToMode(context, false, surahId, surahName);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          children: [
                            const Icon(LucideIcons.mic,
                                color: AppColors.primary, size: 32),
                            const SizedBox(height: 12),
                            Text(
                              "PRACTICE",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Smart Tutor",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = AppColors.getBackgroundColor(context);
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Unified Sanctuary Gradient (Theme-Aware)
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
          SafeArea(
            child: Column(
              children: [
                // 1. CUSTOM APP BAR (LIBRARY / SEARCH)
                _buildLibraryAppBar(),

                // 2. FILTER TABS (SURAH | JUZ)
                _buildSegmentedFilters(),

                const SizedBox(height: 16),

                // 3. CONTENT AREA
                Expanded(
                  child: _selectedTabIndex == 1
                      ? const HadithScreen()
                      : _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _isJuzMode
                          ? _buildJuzList()
                          : _filteredSurahs.isEmpty
                            ? Center(
                                child: Text("No Surahs found matching your search.",
                                style: TextStyle(color: textColor.withValues(alpha: 0.5))))
                            : Stack(
                                children: [
                                    ListView.builder(
                                      controller: _listScrollController,
                                      padding: const EdgeInsets.only(left: 20, right: 56, top: 0, bottom: 20),
                                    itemCount: _filteredSurahs.length,
                                    itemBuilder: (context, index) {
                                      final surah = _filteredSurahs[index];
                                      final currentJuz = QuranPageService().getJuzNumber(surah.id, 1);
                                      
                                      bool showHeader = false;
                                      if (index == 0) {
                                        showHeader = true;
                                      } else {
                                        final prevSurah = _filteredSurahs[index - 1];
                                        final prevJuz = QuranPageService().getJuzNumber(prevSurah.id, 1);
                                        if (currentJuz != prevJuz) showHeader = true;
                                      }

                                      return Column(
                                        children: [
                                          if (showHeader) _buildJuzHeader(currentJuz),
                                          _buildRefinedSurahCard(context, surah),
                                          const SizedBox(height: 12),
                                        ],
                                      );
                                    },
                                  ),
                                  // Fast Scroll Strip (1-30) - PRESERVED & Adjusted
                                  Positioned(
                                    right: 8, 
                                    top: 20,
                                    bottom: 20,
                                    child: _buildFastScrollStrip(),
                                  ),
                                  // Hover Bubble
                                  if (_hoveredJuz != null)
                                    Center(
                                      child: _buildHoverBubble(),
                                    ),
                                ],
                              ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuzHeader(int juz) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32, bottom: 12, left: 16, right: 16),
      color: Colors.white.withValues(alpha: 0.02),
      child: Text(
        "JUZ $juz",
        style: GoogleFonts.outfit(
          color: AppColors.primary.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildFastScrollStrip() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final percent = (localPos.dy - 100) / (box.size.height - 200);
        final juz = (percent * 30).clamp(1, 30).toInt();
        
        if (juz != _hoveredJuz) {
          HapticFeedback.selectionClick();
        }
        setState(() => _hoveredJuz = juz);
        _scrollToJuz(juz);
      },
      onVerticalDragEnd: (_) => setState(() => _hoveredJuz = null),
      child: Container(
        width: 24,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(30, (i) => Text(
            "${i + 1}",
            style: GoogleFonts.outfit(
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildHoverBubble() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)],
      ),
      child: Text(
        "JUZ\n$_hoveredJuz",
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  void _scrollToJuz(int juz) {
    // Find index of first surah in this juz
    int targetIndex = -1;
    for (int i = 0; i < _filteredSurahs.length; i++) {
      if (QuranPageService().getJuzNumber(_filteredSurahs[i].id, 1) >= juz) {
        targetIndex = i;
        break;
      }
    }
    
    if (targetIndex != -1) {
      _listScrollController.animateTo(
        targetIndex * 60.0, // Approximation for dense items
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildRefinedSurahCard(BuildContext context, QuranSurah surah) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    // Dynamic Metadata
    final pageNum = quran.getPageNumber(surah.id, 1);
    final revelation = surah.type;
    final juzStart = quran.getJuzNumber(surah.id, 1);
    final juzEnd = quran.getJuzNumber(surah.id, surah.totalVerses);
    final juzRange = juzStart == juzEnd ? "Juz $juzStart" : "Juz $juzStart - $juzEnd";
    final displayHook = surah.verses.isNotEmpty ? surah.verses.first.text : "";

    return GlassCard(
      onTap: () {
        HapticFeedback.mediumImpact();
        int targetPage = pageNum;
        if (_ayahNavigationTarget != null && _ayahNavigationTarget!.startsWith("${surah.id}:")) {
          final ayahId = int.tryParse(_ayahNavigationTarget!.split(':').last);
          if (ayahId != null) {
            targetPage = quran.getPageNumber(surah.id, ayahId);
          }
        }
        _handleSurahTap(context, surah.id, surah.transliteration, initialPage: targetPage);
      },
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Background Index Number
          Positioned(
            left: -8,
            top: -5,
            child: Text(
              surah.id.toString().padLeft(2, '0'),
              style: GoogleFonts.outfit(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Arabic Name + revelation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    surah.id == 1 ? "ٱلْفَاتِحَة" : surah.name, // Proper diacritics
                    style: GoogleFonts.amiri(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary, // Emerald pop
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      revelation.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: secondaryTextColor.withValues(alpha: 0.5),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Surah Transliteration + Stats
              Row(
                children: [
                  Text(
                    surah.transliteration,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(color: secondaryTextColor.withValues(alpha: 0.3), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                    Text(
                      "${surah.totalVerses} Ayahs",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: secondaryTextColor.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom Row: Juz alignment + Page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.binary, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        juzRange,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: textColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Page $pageNum",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.chevron_right, size: 14, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Opening Hook Text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayHook,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildJuzList() {
    final query = _searchController.text.trim();
    final List<int> juzNumbers = List.generate(30, (i) => i + 1);
    final filteredJuz = query.isEmpty 
      ? juzNumbers 
      : juzNumbers.where((n) => n.toString().contains(query)).toList();

    final textColor = AppColors.getTextPrimary(context);
    if (filteredJuz.isEmpty) {
      return Center(child: Text("No Juz found.", style: TextStyle(color: textColor.withValues(alpha: 0.5))));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredJuz.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredJuz.length) return const SizedBox(height: 80);
        final juz = filteredJuz[index];
        return _buildRefinedJuzCard(context, juz);
      },
    );
  }

  Widget _buildRefinedJuzCard(BuildContext context, int juz) {
    // 1. Get Juz Details
    final juzData = _getJuzStartData(juz);
    final startSurahId = juzData['surah'] ?? 1;
    final startAyahId = juzData['ayah'] ?? 1;
    final surah = _allSurahs.firstWhere((s) => s.id == startSurahId, orElse: () => _allSurahs.first);
    final pageNum = quran.getPageNumber(startSurahId, startAyahId);

    // 2. Identify Surahs in this Juz (Composition)
    final composition = _getJuzComposition(juz);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    return GlassCard(
      onTap: () {
        HapticFeedback.mediumImpact();
        _handleSurahTap(context, startSurahId, surah.transliteration, initialPage: pageNum);
      },
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Juz Number + Page
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الجزء $juz".toUpperCase(),
                style: GoogleFonts.amiri(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "PAGE $pageNum",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Starts At Meta
          Row(
            children: [
              const Icon(LucideIcons.book_open, size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                "Starts at ${surah.transliteration} ($startAyahId)",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Composition Row (Surahs icons or labels)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: composition.map((sID) {
                final sName = _allSurahs.firstWhere((s) => s.id == sID, orElse: () => _allSurahs.first).transliteration;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textColor.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    sName,
                    style: GoogleFonts.inter(fontSize: 11, color: secondaryTextColor),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Juz Composition Bar (High-Fidelity)
          _buildJuzCompositionBar(composition),
        ],
      ),
    );
  }

  Widget _buildJuzCompositionBar(List<int> surahIds) {
    final textColor = AppColors.getTextPrimary(context);
    // Generate segments based on surahs present in the Juz
    // For the demo, if multiple surahs, we show a multi-color bar
    final segments = surahIds.map((_) => 1.0 / surahIds.length).toList();
    final colors = surahIds.asMap().entries.map((entry) {
        final opacity = 1.0 - (entry.key * 0.2).clamp(0.0, 0.7);
        return AppColors.primary.withOpacity(opacity);
    }).toList();
    
    String label = surahIds.length == 1 
        ? "Single Surah Juz" 
        : "${surahIds.length} Surahs Composition";

    if (surahIds.length > 3) {
        label = "${surahIds.length} Surahs";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("JUZ COMPOSITION", style: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.3), fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.3), fontSize: 9)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 4,
            child: Row(
              children: segments.asMap().entries.map((entry) {
                return Expanded(
                  flex: (entry.value * 100).toInt(),
                  child: Container(color: colors[entry.key]),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildReciterAvatar(BuildContext context, String name, String code, bool isSelected, Function(String) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(code),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              isValidIcon() ? LucideIcons.user : Icons.person, // Handle icon safely
              color: isSelected ? AppColors.primary : Colors.white54,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? AppColors.primary : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
            ),
        ],
      ),
    );
  }
  
  bool isValidIcon() => true;

  Widget _buildLibraryAppBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isSearchMode ? _buildSearchState() : _buildDefaultState(),
      ),
    );
  }

  Widget _buildDefaultState() {
    final textColor = AppColors.getTextPrimary(context);
    return Row(
      key: const ValueKey("default"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Library",
          style: GoogleFonts.outfit(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(LucideIcons.search, color: AppColors.primary),
          onPressed: () => setState(() => _isSearchMode = true),
        ),
      ],
    );
  }

  Widget _buildSearchState() {
    final textColor = AppColors.getTextPrimary(context);
    return Row(
      key: const ValueKey("search"),
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: textColor.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Search Surah, Juz...",
                hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isSearchMode = false;
              _searchController.clear();
              _filterSurahs("");
            });
            FocusScope.of(context).unfocus();
          },
          child: const Text("Cancel", style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildSegmentedFilters() {
    final textColor = AppColors.getTextPrimary(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildFilterTab("Surah", !_isJuzMode, () => setState(() => _isJuzMode = false))),
          Expanded(child: _buildFilterTab("Juz", _isJuzMode, () => setState(() => _isJuzMode = true))),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isActive, VoidCallback onTap) {
    final textColor = AppColors.getTextPrimary(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: isActive ? Colors.black : textColor.withValues(alpha: 0.4),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Map<String, int> _getJuzStartData(int juz) {
    const Map<int, List<int>> starts = {
      1: [1, 1], 2: [2, 142], 3: [2, 253], 4: [3, 93], 5: [4, 24],
      6: [4, 148], 7: [5, 82], 8: [6, 111], 9: [7, 88], 10: [8, 41],
      11: [9, 93], 12: [11, 6], 13: [12, 53], 14: [15, 1], 15: [17, 1],
      16: [18, 75], 17: [21, 1], 18: [23, 1], 19: [25, 21], 20: [27, 56],
      21: [29, 46], 22: [33, 31], 23: [36, 28], 24: [39, 32], 25: [41, 47],
      26: [46, 1], 27: [51, 31], 28: [58, 1], 29: [67, 1], 30: [78, 1],
    };
    final data = starts[juz] ?? [1, 1];
    return {
      'surah': data[0],
      'ayah': data[1],
    };
  }

  List<int> _getJuzComposition(int juz) {
    final List<int> composition = [];
    for (int i = 1; i <= 114; i++) {
        // Check if any part of the surah is in this juz
        final startJuz = quran.getJuzNumber(i, 1);
        final endJuz = quran.getJuzNumber(i, quran.getVerseCount(i));
        
        if (startJuz <= juz && endJuz >= juz) {
            composition.add(i);
        }
    }
    return composition;
  }
}

