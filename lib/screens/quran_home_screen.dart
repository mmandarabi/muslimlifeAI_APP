import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/models/quran_display_names.dart';
import 'package:muslim_mind/models/quran_surah.dart';
import 'package:muslim_mind/services/quran_local_service.dart';
import 'package:muslim_mind/screens/hadith_screen.dart';
import 'package:muslim_mind/screens/quran_read_mode.dart';
import 'package:muslim_mind/screens/surah_intro_screen.dart'; // NEW
import 'package:muslim_mind/screens/quran_screen.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/quran_page_service.dart';
import 'package:muslim_mind/services/theme_service.dart';
import 'package:muslim_mind/services/quran_favorite_service.dart';
import 'package:quran/quran.dart' as quran;

class QuranHomeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const QuranHomeScreen({super.key, this.onBack});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  int _selectedTabIndex = 0; // 0: Surah, 1: Juz, 2: Favorites
  List<QuranSurah> _allSurahs = [];
  List<QuranSurah> _filteredSurahs = [];
  List<int> _favoriteIds = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final UnifiedAudioService _audioService = UnifiedAudioService();
  final QuranFavoriteService _favoriteService = QuranFavoriteService();
  
  // Fast Scroller Keys
  final Map<int, GlobalKey> _surahKeys = {}; // Map<SurahID, Key>
  final Map<int, GlobalKey> _juzKeys = {}; // Map<JuzNum, Key>
  bool _isSearching = false;
  int _activeJuzScrollIndex = -1; // To highlight the number being tapped/dragged

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
      final favorites = await _favoriteService.getFavorites();
      if (mounted) {
        setState(() {
          _allSurahs = surahs;
          _filteredSurahs = surahs;
           _favoriteIds = favorites;
           _isLoading = false;
           // Generate Keys for all Surahs
           for (var s in surahs) {
             _surahKeys[s.id] = GlobalKey();
           }
           // Generate Keys for Juz cards (1-30)
           for (int i = 1; i <= 30; i++) {
             _juzKeys[i] = GlobalKey();
           }
         });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Error loading data: $e");
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    _filterSurahs(query);
  }

  void _filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() => _filteredSurahs = _allSurahs);
      return;
    }
    setState(() {
      _filteredSurahs = _allSurahs.where((s) {
        return s.transliteration.toLowerCase().contains(query) ||
               s.name.contains(query) ||
               s.id.toString() == query;
      }).toList();
    });
  }
  
  // Estimates the Juz number based on Surah ID (Standard approximation for Demo)
  int _getJuzForSurah(int surahId) {
    if (surahId >= 1 && surahId <= 2) return 1;
    if (surahId == 3) return 3;
    if (surahId == 4) return 4;
    if (surahId >= 5 && surahId <= 114) {
       return (surahId / 4).ceil(); 
    }
    return 1;
  }

  // Returns the range of Surah IDs [start, end] for a given Juz
  List<int> _getSurahRangeForJuz(int juz) {
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
       // ... simplified
       case 29: return [67, 77];
       case 30: return [78, 114];
       default: return [1, 114];
     }
  }

  void _scrollToJuz(int juz) {
    // 1. Handle JUZ TAB Scrolling
    if (_selectedTabIndex == 1) {
       final key = _juzKeys[juz];
       if (key != null && key.currentContext != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            alignment: 0.1,
          );
          HapticFeedback.selectionClick();
       }
       return;
    }
  
    // 2. Handle SURAH TAB Scrolling (Default)
    if (_selectedTabIndex != 0) {
      setState(() => _selectedTabIndex = 0); // Redirect to Surah tab if on Favorites
    }
    
    // Find the starting Surah for this Juz
    final range = _getSurahRangeForJuz(juz);
    final int startSurahId = range[0];
    
    // Find the key
    final key = _surahKeys[startSurahId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.1, // Offset slightly from top
      );
      HapticFeedback.selectionClick();
    }
  }

  
  void _handleSurahTap(BuildContext context, int surahId, String surahName, {int? initialPage}) {
      // 🛑 Synchronize the global audio player before navigating
      _audioService.prepareSurah(surahId, surahName);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuranReadMode(
            surahId: surahId,
            surahName: surahName,
            initialPage: initialPage,
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
      body: SingleChildScrollView(
        // Match HomeTab's specific padding and bottom clearance
        padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER SLOT (Sync with Home's Streak/Settings Row)
            _buildLibraryHeader(),

            const SizedBox(height: 24), // Match Home's Header -> Title spacer

            // 2. TITLE SLOT
            SizedBox(
              height: 40,
              child: Text(
                "Library",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 32), // Match Home's Title -> Hero spacer

            // 3. HERO AREA
            _buildCinematicHero(),

            const SizedBox(height: 48), // Match Home's Hero -> List spacer

            // 4. TAB SELECTOR (Surah, Juz, Favorites)
            _buildTabSelector(),

            const SizedBox(height: 32),

            // 5. LIST AREA WITH RAIL
            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. FAST SCROLLER RAIL (Visible on Surah AND Juz Tabs)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: (_selectedTabIndex == 0 || _selectedTabIndex == 1) && !_isSearching ? 1.0 : 0.0, 
                      child: IgnorePointer(
                        ignoring: (_selectedTabIndex != 0 && _selectedTabIndex != 1) || _isSearching,
                        child: _buildJuzRail(accentColor),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // B. MAIN CONTENT
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildActiveTabContent(textColor),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 48), // Indent to align with content past the rail
      child: Row(
        children: [
          _tabButton("Surah", 0),
          const SizedBox(width: 24),
          _tabButton("Juz", 1),
          const SizedBox(width: 24),
          _tabButton("Favorites", 2),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 2) {
          final favorites = await _favoriteService.getFavorites();
          setState(() => _favoriteIds = favorites);
        }
        setState(() => _selectedTabIndex = index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.3),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 12,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(Color textColor) {
    if (_selectedTabIndex == 0) return _buildSurahListContent(textColor);
    if (_selectedTabIndex == 1) return _buildJuzListContent(textColor);
    return _buildFavoritesListContent(textColor);
  }

  Widget _buildJuzListContent(Color textColor) {
    return Column(
      children: List.generate(30, (index) {
        final juz = index + 1;
        // Mocking juz metadata for the card
        final startSurahId = _getSurahRangeForJuz(juz)[0];
        final surah = _allSurahs.firstWhere((s) => s.id == startSurahId, orElse: () => _allSurahs.first);
        
        return Column(
          children: [
            _buildJuzCard(juz, surah, key: _juzKeys[juz]), // 🛑 Assign Key
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }

  Widget _buildJuzCard(int juz, QuranSurah startSurah, {Key? key}) { // 🛑 Accept Key
    return GestureDetector(
      key: key, // 🛑 Assign Key
      onTap: () => _handleSurahTap(context, startSurah.id, startSurah.transliteration),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        opacity: 0.15,
        border: Border.all(color: Colors.white.withOpacity(0.04)),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                juz.toString(),
                style: GoogleFonts.firaCode(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Juz $juz",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "STARTS AT ${startSurah.transliteration.toUpperCase()}",
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: AppColors.textPrimaryDark.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "الجزء",
              style: GoogleFonts.amiri(
                fontSize: 24,
                color: AppColors.textPrimaryDark.withOpacity(0.1),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesListContent(Color textColor) {
    final favorites = _allSurahs.where((s) => _favoriteIds.contains(s.id)).toList();
    if (favorites.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text("NO FAVORITES YET", style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.2), letterSpacing: 2, fontSize: 12)),
      ));
    }
    return Column(
      children: favorites.map((surah) => Column(
        children: [
          _buildRefinedSurahCard(context, surah),
          const SizedBox(height: 12),
        ],
      )).toList(),
    );
  }

  Widget _buildLibraryHeader() {
    return SizedBox(
      height: 48, // Slight increase for TextField click target
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (or Close Search)
          GestureDetector(
            onTap: () {
               if (_isSearching) {
                 // Close Search Mode
                 setState(() {
                   _isSearching = false;
                   _searchController.clear();
                   _filteredSurahs = _allSurahs; // Reset list
                 });
               } else {
                 widget.onBack?.call();
               }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(
                _isSearching ? LucideIcons.x : LucideIcons.chevron_left, 
                color: AppColors.textPrimaryDark.withOpacity(0.6), 
                size: 24
              ),
            ),
          ),
          
          if (_isSearching)
            Expanded(
              child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontSize: 18),
                    decoration: InputDecoration(
                       hintText: "Search Surah Name, ID...",
                       hintStyle: GoogleFonts.outfit(color: AppColors.textPrimaryDark.withOpacity(0.3)),
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.zero,
                    ),
                 ),
              ),
            )
          else 
            const Spacer(),
          
          // Search Icon (Transition to Search Mode)
          if (!_isSearching)
          GestureDetector(
            onTap: () {
              setState(() => _isSearching = true);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(LucideIcons.search, color: AppColors.textPrimaryDark.withOpacity(0.4), size: 18),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSurahListContent(Color textColor) {
    if (_filteredSurahs.isEmpty) {
       return Center(
          child: Text("No Surahs found matching your search.",
          style: TextStyle(color: textColor.withValues(alpha: 0.5))));
    }
    
    return Column(
      children: _filteredSurahs.map((surah) => Column(
        children: [
          _buildRefinedSurahCard(context, surah, key: _surahKeys[surah.id]),
          const SizedBox(height: 12),
        ],
      )).toList(),
    );
  }

  Widget _buildCinematicHero() {
    return Padding(
      padding: EdgeInsets.zero, // Removed bottom padding, using Column's SizedBox
      child: GestureDetector(
        onTap: () {
           // Synchronize the global audio player
           _audioService.prepareSurah(2, "Al-Baqarah");
           // Direct to Al-Baqarah (Surah 2) Read Mode
           Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranReadMode(surahId: 2, surahName: "Al-Baqarah")));
        },
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF202124), // Base Layer: Raisin Black
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Stack(
              children: [
                // 1. Pattern Layer
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.9, // 🛑 Show off the art
                    child: Image.asset(
                        'assets/images/quran_hero_bg.png', // 🛑 NEW GENERATED ASSET
                        fit: BoxFit.cover,
                      ),
                  ),
                ),
                
                // 2. Elevation Surface (Subtle #35363A for depth)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF35363A).withOpacity(0.1), // Subtle depth
                    ),
                  ),
                ),

                // 3. Overlay Layer: Gradient Black/80% (Bottom) to Transparent (Top)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // 4. Typography & Content
                Positioned(
                  bottom: 24, 
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // English Side (Balanced)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Al Quran",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFF1F3F4), // Anti-Flash White
                                fontSize: 28, 
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "PREMIUM RECITATION",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF10B981).withOpacity(0.8), // Sanctuary Emerald
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Arabic Side (Aged Gold Calligraphy - Balanced)
                      Flexible(
                        child: Text(
                          "ٱلْقُرْآن ٱلْكَرِيم",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFD4AF37), // Aged Gold
                            fontSize: 44, // Restored to a balanced scale
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildJuzRail(Color accentColor) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Calculate which index is being touched based on Y position
        // Assuming each item is roughly ~22-24px height (10 fontSize + 8 vertical padding + 4 spacing)
        // Better: Use layout builder or fixed height logic.
        // Let's assume total height / 30.
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localOffset = box.globalToLocal(details.globalPosition);
        
        // We know the rail starts at a certain Y relative to the screen, 
        // but 'details.localPosition' in this gesture detector gives local coordinates.
        // BUT: The gesture is on the Column/Container.
        
        // Approximate height per item: 
        // Font 10 + Padding 8 (4*2) = 18px per item? No, let's verify text height.
        // Let's use a fixed height container for each item to be safe.
        
        // Actually, we can just use the local Y position divided by the height of one item.
        const double itemHeight = 22.0; // 10px text + 8px padding + 4px margin roughly
        int index = (details.localPosition.dy / itemHeight).floor() + 1;
        
        if (index < 1) index = 1;
        if (index > 30) index = 30;
        
        if (_activeJuzScrollIndex != index) {
          setState(() => _activeJuzScrollIndex = index);
          _scrollToJuz(index);
        }
      },
      onVerticalDragEnd: (_) {
         Future.delayed(const Duration(milliseconds: 500), () {
           if (mounted) setState(() => _activeJuzScrollIndex = -1);
         });
      },
      child: Container(
        width: 32,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: List.generate(30, (index) {
            final juz = index + 1;
            final isActive = _activeJuzScrollIndex == juz;
            return GestureDetector(
              onTapDown: (_) {
                setState(() => _activeJuzScrollIndex = juz);
                _scrollToJuz(juz);
              },
              onTapUp: (_) {
                 Future.delayed(const Duration(milliseconds: 500), () {
                   if (mounted) setState(() => _activeJuzScrollIndex = -1);
                 });
              },
              child: Container(
                height: 22, // Fixed height for reliable drag math
                alignment: Alignment.center,
                child: Text(
                  juz.toString(),
                  style: GoogleFonts.firaCode(
                    fontSize: isActive ? 14 : 10, // Scale up on active
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.accent : AppColors.primary, // Highlight color
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRefinedSurahCard(BuildContext context, QuranSurah surah, {Key? key}) { // 🛑 Accept Key
    return GestureDetector(
      key: key, // 🛑 Assign Key
      onTap: () {
        HapticFeedback.mediumImpact();
        _handleSurahTap(context, surah.id, surah.transliteration);
      },
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        showPattern: false, // Clean table look
        opacity: 0.15,
        border: Border.all(color: Colors.white.withOpacity(0.04)),
        child: Row(
          children: [
            // 1. Mono ID
            SizedBox(
              width: 32,
              child: Text(
                surah.id.toString(),
                style: GoogleFonts.firaCode(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 2. Name & Verses
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.transliteration,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${surah.totalVerses} AYAHS",
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: AppColors.textPrimaryDark.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            // 3. Arabic Typography
            Text(
              surah.name,
              style: GoogleFonts.amiri(
                fontSize: 24,
                color: AppColors.textPrimaryDark.withOpacity(0.2),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
