import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/models/quran_display_names.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/models/quran_ayah.dart';
import 'package:muslim_life_ai_demo/services/quran_local_service.dart';
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
  bool _isListening = false;
  bool _showFeedback = false;
  Future<QuranSurah>? _surahFuture;

  @override
  void initState() {
    super.initState();
    _surahFuture = QuranLocalService().getSurahDetails(widget.surahId);
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
    if (surahId >= 1 && surahId <= 2) return 1;
    if (surahId == 3) return 3;
    if (surahId == 4) return 4;
    // ... simplified mapping for brevity ...
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

  void _toggleListening() async {
    if (_isListening) return;

    setState(() {
      _isListening = true;
    });

    // Simulate listening delay
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isListening = false;
      });
      _showFeedbackBottomSheet();
    }
  }

  void _showFeedbackBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recitation Analysis",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    "92% Accurate",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Correction:",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "You missed the Ghunnah on the last verse.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.check, size: 18),
                label: const Text("Got it"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
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
        title: Column(
          children: [
            Text(
              "Smart Tutor",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "MISHARY RASHID ALAFASY",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleListening,
        backgroundColor: _isListening ? Colors.red : AppColors.primary,
        icon: Icon(_isListening ? LucideIcons.timer : LucideIcons.mic, color: Colors.white),
        label: Text(
          _isListening ? "Listening..." : "Tap to Recite",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ).animate(target: _isListening ? 1 : 0).shake(hz: 2),
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
