import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/models/quran_display_names.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/models/quran_ayah.dart';
import 'package:muslim_life_ai_demo/services/quran_local_service.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:muslim_life_ai_demo/screens/quran_read_mode.dart';

class QuranScreen extends StatefulWidget {
  final int surahId;
  final String surahName;

  const QuranScreen({
    super.key,
    this.surahId = 1,
    this.surahName = "Al-Fātiḥah",
  });

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // Audio
  final UnifiedAudioService _audioService = UnifiedAudioService();
  StreamSubscription? _playerStateSubscription;
  bool _isPlaying = false;
  
  Future<QuranSurah>? _surahFuture;

  @override
  void initState() {
    super.initState();
    _surahFuture = QuranLocalService().getSurahDetails(widget.surahId);
    
    // Sync initial state
    _isPlaying = _audioService.isPlaying;
    
    // Listen for changes
    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioService.stop(); // Stop when leaving this screen
    super.dispose();
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

  int _getJuzForSurah(int surahId) {
    if (surahId >= 1 && surahId <= 2) return 1;
    if (surahId == 3) return 3;
    if (surahId == 4) return 4;
    // ... simplified mapping ...
    if (surahId >= 5 && surahId <= 114) {
       return (surahId / 4).ceil(); 
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

  void _togglePlayback() {
    if (_isPlaying) {
      _audioService.stop();
    } else {
      _audioService.playSurah(widget.surahId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Playing Recitation..."), duration: Duration(milliseconds: 500)),
      );
    }
  }

  String _getReciterName(String code) {
    switch (code.toLowerCase()) {
      case 'sudais': return "Sheikh Sudais (Makkah)";
      case 'saad': return "Saad al-Ghamdi";
      case 'mishary': return "Mishary Rashid Alafasy";
      case 'makkah': return "Sheikh Sudais (Makkah)"; // Fallback for old shared logic if needed
      default: return "Sheikh Sudais (Makkah)"; // Default
    }
  }

  void _showReciterSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Reciter", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 16),
            ...['sudais', 'saad', 'mishary'].map((code) {
              final isSelected = _audioService.currentQuranReciter == code;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppColors.primary : Colors.white54,
                ),
                title: Text(_getReciterName(code), style: const TextStyle(color: Colors.white)),
                onTap: () async {
                  await _audioService.setQuranReciter(code);
                  if (mounted) setState(() {}); // Refresh UI
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E), // Deep Black Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: _showReciterSelector,
          child: Column(
            children: [
              Text(
                "Smart Tutor",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getReciterName(_audioService.currentQuranReciter).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary, // Highlight clickable
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevron_down, size: 10, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuranReadMode(surahId: widget.surahId, surahName: widget.surahName)),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "READ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _isPlaying ? Colors.redAccent : AppColors.primary,
          borderRadius: BorderRadius.circular(16), // Rounded rect like Extended FAB
          boxShadow: [
            BoxShadow(
              color: (_isPlaying ? Colors.redAccent : AppColors.primary).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
               _togglePlayback();
            },
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Reciter"), duration: Duration(milliseconds: 500)));
              _showReciterSelector();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(_isPlaying ? LucideIcons.square : LucideIcons.play, color: Colors.white, size: 20),
                   const SizedBox(width: 12),
                   Text(
                      _isPlaying ? "Stop Audio" : "Play Recitation",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                   ),
                ],
              ),
            ),
          ),
        ),
      ).animate(target: _isPlaying ? 1 : 0).shimmer(duration: 2.seconds),
      body: Stack(
        children: [
          // Optional: Subtle Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    Color(0xFF0B0C0E), // Deep Black
                  ],
                  stops: [0.0, 0.6],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<QuranSurah>(
              future: _surahFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No Surah Data", style: TextStyle(color: Colors.white54)));
                }

                final surah = snapshot.data!;
                final juzNumber = _getJuzForSurah(surah.id);
                final arabicJuz = _getArabicJuzString(juzNumber);

                return Column(
                  children: [
                    // --- 1. Header Row (Juz & Surah Name in Arabic) ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Surah Name (Arabic)
                          Text(
                            "سُورَةُ ${kUthmaniSurahTitles[surah.id] ?? surah.name}",
                            style: const TextStyle(
                              fontFamily: 'KFGQPCUthmanic',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          // Right: Juz Number (Arabic)
                          Text(
                            arabicJuz,
                            style: GoogleFonts.amiri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- 2. Scrollable List (Title Box + Verses) ---
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100), // Extra bottom padding for FAB
                        itemCount: surah.verses.length + 1, // Title Box + Verses
                        itemBuilder: (context, index) {
                          // Item 0: Decorative Title Box
                          if (index == 0) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37), // Gold border
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "سُورَةُ ${kUthmaniSurahTitles[surah.id] ?? surah.name}",
                                  style: const TextStyle(
                                    fontFamily: 'KFGQPCUthmanic',
                                    fontSize: 32, // Match Read Mode size
                                    fontWeight: FontWeight.bold,
                                    height: 1.6,
                                    color: Color(0xFFD4AF37), // Keep Gold
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          // Verses (Index 1 to N)
                          final ayahIndex = index - 1;
                          final ayah = surah.verses[ayahIndex];
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Container(
                               width: double.infinity,
                               padding: const EdgeInsets.all(24),
                               decoration: BoxDecoration(
                                 color: Colors.white.withOpacity(0.05),
                                 borderRadius: BorderRadius.circular(20),
                                 border: Border.all(color: Colors.white10),
                               ),
                               child: Text.rich(
                                 TextSpan(
                                   children: [
                                     TextSpan(text: "${ayah.text} "),
                                     TextSpan(
                                       text: " ۝${_toArabicNumbers(ayah.id)}",
                                       style: GoogleFonts.amiri(
                                          color: const Color(0xFFD4AF37), // Gold for marker
                                          fontSize: 28,
                                       ),
                                     ),
                                   ],
                                 ),
                                 style: GoogleFonts.amiri(
                                   fontSize: 28,
                                   color: Colors.white,
                                   height: 2,
                                 ),
                                 textAlign: TextAlign.center,
                                 textDirection: TextDirection.rtl,
                               ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
