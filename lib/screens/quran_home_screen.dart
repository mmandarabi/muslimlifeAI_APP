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

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  bool? _isReadModePreferred;
  int _selectedTabIndex = 0;
  List<QuranSurah> _allSurahs = [];
  List<QuranSurah> _filteredSurahs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String? _ayahNavigationTarget; // e.g., "2:255"
  final UnifiedAudioService _audioService = UnifiedAudioService();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
    _showModeSelectionDialog(context, surahId, surahName);
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
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
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
                            color: const Color(0xFFD4AF37).withOpacity(0.15), // Gold Tint
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
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
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
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
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ["Quran", "Hadith", "Favorites"][_selectedTabIndex],
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Opacity(
                  opacity: _selectedTabIndex == 0 ? 1.0 : 0.0,
                  child: IconButton(
                    onPressed: _selectedTabIndex == 0 ? () => _showReciterSelector(context) : null,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.mic, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTab(context, "Quran", 0),
                const SizedBox(width: 12),
                _buildTab(context, "Hadith", 1),
                const SizedBox(width: 12),
                _buildTab(context, "Favorites", 2),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Bar
          Visibility(
            visible: _selectedTabIndex == 0,
            maintainSize: true, 
            maintainAnimation: true,
            maintainState: true,
            child: Column(
              children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2), // reduced vertical padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: const Icon(LucideIcons.search, color: Colors.white38, size: 20),
                    hintText: "Search Surah, Juz (e.g. '1'), or Ayah...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    suffixIcon: _searchController.text.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _filterSurahs('');
                          },
                        )
                      : null,
                  ),
                ),
              ),
            ),
            
            // Special Ayah Navigation Hint
            if (_ayahNavigationTarget != null) 
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: GestureDetector(
                  onTap: () {
                     // TODO: Navigate to specific Ayah
                     // For now just navigate to the Surah
                     if (_filteredSurahs.isNotEmpty) {
                       _handleSurahTap(context, _filteredSurahs.first.id, _filteredSurahs.first.transliteration);
                     }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.corner_down_right, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                         Text(
                          "Go to $_ayahNavigationTarget",
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTabIndex == 1
                ? const HadithScreen()
                : _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredSurahs.isEmpty
                    ? const Center(
                        child: Text("No Surahs found matching your search.",
                        style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredSurahs.length + 1, 
                        itemBuilder: (context, index) {
                           if (index == _filteredSurahs.length) {
                             return const SizedBox(height: 80); 
                           }
                           final surah = _filteredSurahs[index];
                           return Column(
                             children: [
                               _buildSurahItem(
                                 context,
                                 surah: surah,
                               ),
                               const SizedBox(height: 12),
                             ],
                           );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white10,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildSurahItem(
    BuildContext context, {
    required QuranSurah surah,
  }) {
    return GestureDetector(
      onTap: () => _handleSurahTap(context, surah.id, surah.transliteration),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1), // Fixed: Match Green Theme
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Number + English Info
            Row(
              children: [
                // Surah Number (Faded, Large)
                Text(
                  surah.id.toString(),
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 20),
                
                // English Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.transliteration, // "Al-Fatiha"
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.type, // "Meccan" (Placeholder for meaning)
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 4),
                     // Progress Placeholder (Fixed: Removed "//")
                     Text(
                      "0/${surah.totalVerses}",
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: Colors.white38,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right Side: Arabic Name + Verses
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Arabic Name (Calligraphy)
                Text(
                  kUthmaniSurahTitles[surah.id] ?? surah.name,
                  style: const TextStyle(
                    fontFamily: 'KFGQPCUthmanic',
                    fontSize: 26,
                    height: 1.3,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
                 const SizedBox(height: 2),
                // Verses Count
                Text(
                  "${surah.totalVerses} Verses",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReciterSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0C0E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Reciter",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildReciterAvatar(
                        context, 
                        "Al-Sudais", 
                        "sudais", 
                        _audioService.currentQuranReciter == "sudais",
                        (val) {
                          _audioService.setQuranReciter(val);
                          setModalState(() {});
                          setState(() {}); // Update parent too
                        }
                      ),
                      const SizedBox(width: 20),
                      _buildReciterAvatar(
                        context, 
                        "Saad al-Ghamdi", 
                        "saad", 
                        _audioService.currentQuranReciter == "saad",
                         (val) {
                          _audioService.setQuranReciter(val);
                          setModalState(() {});
                          setState(() {});
                        }
                      ),
                      const SizedBox(width: 20),
                      _buildReciterAvatar(
                        context, 
                        "Mishary Alafasy", 
                        "mishary", 
                        _audioService.currentQuranReciter == "mishary",
                         (val) {
                          _audioService.setQuranReciter(val);
                          setModalState(() {});
                          setState(() {});
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }
      ),
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
              color: Colors.white.withOpacity(0.1),
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
  
  bool isValidIcon() => true; // Simplified for this snippet since we have LucideIcons imported
}

