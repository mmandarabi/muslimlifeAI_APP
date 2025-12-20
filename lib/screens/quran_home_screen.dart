import 'package:flutter/material.dart';
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

  void _handleSurahTap(BuildContext context, int surahId, String surahName) {
    // Phase 1.5: Direct Read Mode - No more interruption for elders
    _navigateToMode(context, true, surahId, surahName);
  }

  void _navigateToMode(BuildContext context, bool isReadMode, int surahId, String surahName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isReadMode 
          ? QuranReadMode(surahId: surahId, surahName: surahName) 
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                        ? const Center(
                            child: Text("No Surahs found matching your search.",
                            style: TextStyle(color: Colors.white54)))
                        : Stack(
                            children: [
                              ListView.builder(
                                controller: _listScrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              // Fast Scroll Strip (1-30) - PRESERVED
                              Positioned(
                                right: 4,
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
    );
  }

  Widget _buildJuzHeader(int juz) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
    final pageNum = QuranPageService().getPageNumber(surah.id, 1);
    final juzNum = quran.getJuzNumber(surah.id, 1);
    final lastJuz = quran.getJuzNumber(surah.id, surah.totalVerses);
    final juzRange = juzNum == lastJuz ? "Juz $juzNum" : "Juz $juzNum-$lastJuz";
    final revelation = quran.getPlaceOfRevelation(surah.id);
    final hook = surah.verses.isNotEmpty ? surah.verses.first.text : "";
    
    // Clean hook for display (remove end markers if present)
    final displayHook = hook.split('۝').first.trim();

    return GestureDetector(
      onTap: () => _handleSurahTap(context, surah.id, surah.transliteration),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
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
                  color: Colors.white.withOpacity(0.03),
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
                      kUthmaniSurahTitles[surah.id] ?? surah.name,
                      style: const TextStyle(
                        fontFamily: 'KFGQPCUthmanic',
                        fontSize: 28,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        revelation.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Meta Info
                Text(
                  "${surah.transliteration} • $juzRange • ${surah.totalVerses} Verses",
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Arabic Hook
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    displayHook,
                    style: const TextStyle(
                      fontFamily: 'KFGQPCUthmanic',
                      fontSize: 20,
                      color: AppColors.primary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildJuzList() {
    final query = _searchController.text.trim();
    final List<int> juzNumbers = List.generate(30, (i) => i + 1);
    final filteredJuz = query.isEmpty 
      ? juzNumbers 
      : juzNumbers.where((n) => n.toString().contains(query)).toList();

    if (filteredJuz.isEmpty) {
      return const Center(child: Text("No Juz found.", style: TextStyle(color: Colors.white38)));
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
    final startData = _getJuzStartData(juz);
    final startSurahId = startData[0];
    final startAyahId = startData[1];
    
    // Get Surah details for the hook
    final surah = _allSurahs.firstWhere((s) => s.id == startSurahId, orElse: () => _allSurahs.first);
    final ayah = surah.verses.firstWhere((v) => v.id == startAyahId, orElse: () => surah.verses.first);
    final hook = ayah.text.split('۝').first.trim();
    
    // Page metadata
    final pageNum = quran.getPageNumber(startSurahId, startAyahId);

    return GestureDetector(
      onTap: () => _handleSurahTap(context, startSurahId, surah.transliteration),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -8,
              top: -5,
              child: Text(
                juz.toString().padLeft(2, '0'),
                style: GoogleFonts.outfit(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Juz $juz",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Page $pageNum",
                      style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Starts at ${surah.transliteration} $startSurahId:$startAyahId",
                  style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    hook,
                    style: const TextStyle(
                      fontFamily: 'KFGQPCUthmanic',
                      fontSize: 20,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 16),
                _buildJuzCompositionBar(juz),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJuzCompositionBar(int juz) {
    // Standard approximation of surah counts per Juz for the demo UI
    // In a real app, this would be calculated from quran package metadata
    List<double> segments = [1.0];
    List<Color> colors = [AppColors.primary];
    String label = "";

    if (juz == 30) {
      segments = [0.1, 0.15, 0.1, 0.1, 0.1, 0.45];
      colors = [
        AppColors.primary,
        AppColors.primary.withOpacity(0.7),
        AppColors.primary.withValues(alpha: 0.5),
        AppColors.primary.withOpacity(0.3),
        AppColors.primary.withOpacity(0.2),
        Colors.white10
      ];
      label = "37 Surahs (An-Naba - An-Nas)";
    } else if (juz == 1) {
      segments = [0.05, 0.95];
      colors = [AppColors.primary, AppColors.primary.withOpacity(0.4)];
      label = "2 Surahs (Al-Fatihah, Al-Baqarah)";
    } else {
      segments = [0.7, 0.3];
      colors = [AppColors.primary, Colors.white10];
      label = "Mult-Surah Composition";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("JUZ COMPOSITION", style: GoogleFonts.outfit(color: Colors.white24, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.outfit(color: Colors.white24, fontSize: 9)),
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
    return Row(
      key: const ValueKey("default"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Library",
          style: GoogleFonts.outfit(
            color: Colors.white,
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
    return Row(
      key: const ValueKey("search"),
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search Surah, Juz...",
                hintStyle: TextStyle(color: Colors.white38),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
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
            color: isActive ? Colors.black : Colors.white38,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  List<int> _getJuzStartData(int juz) {
    const Map<int, List<int>> starts = {
      1: [1, 1], 2: [2, 142], 3: [2, 253], 4: [3, 93], 5: [4, 24],
      6: [4, 148], 7: [5, 82], 8: [6, 111], 9: [7, 88], 10: [8, 41],
      11: [9, 93], 12: [11, 6], 13: [12, 53], 14: [15, 1], 15: [17, 1],
      16: [18, 75], 17: [21, 1], 18: [23, 1], 19: [25, 21], 20: [27, 56],
      21: [29, 46], 22: [33, 31], 23: [36, 28], 24: [39, 32], 25: [41, 47],
      26: [46, 1], 27: [51, 31], 28: [58, 1], 29: [67, 1], 30: [78, 1],
    };
    return starts[juz] ?? [1, 1];
  }
}

