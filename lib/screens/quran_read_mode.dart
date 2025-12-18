import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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

class QuranReadMode extends StatefulWidget {
  final int surahId;
  final String surahName;

  const QuranReadMode({
    super.key, 
    this.surahId = 1, 
    this.surahName = "Al-Fātiḥah",
  });

  @override
  State<QuranReadMode> createState() => _QuranReadModeState();
}

class _QuranReadModeState extends State<QuranReadMode> {
  Future<QuranSurah>? _surahFuture;
  final UnifiedAudioService _audioService = UnifiedAudioService();
  StreamSubscription? _playerStateSubscription;
  bool _isPlaying = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _surahFuture = QuranLocalService().getSurahDetails(widget.surahId);
    _isPlaying = _audioService.isPlaying;
    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioService.downloadingNotifier.addListener(_onDownloadStatusChanged);
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioService.downloadingNotifier.removeListener(_onDownloadStatusChanged);
    _audioService.stop(); // Stop audio and ABORT downloads when leaving
    super.dispose();
  }

  void _onDownloadStatusChanged() {
    if (mounted) {
      setState(() {
         _isDownloading = _audioService.downloadingNotifier.value;
      });
    }
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
    // ... simplified mapping ...
    if (surahId >= 5 && surahId <= 114) {
       return (surahId / 4).ceil(); // Fallback for demo speed
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

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0B0C0E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.surahName,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
             Text(
              "Surah ${widget.surahId}",
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          if (_isDownloading) 
             const Padding(
               padding: EdgeInsets.all(12.0),
               child: SizedBox(
                 width: 24, 
                 height: 24, 
                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
               ),
             )
          else 
            IconButton(
              icon: Icon(_isPlaying ? LucideIcons.square : LucideIcons.play, color: Colors.white),
              onPressed: () {
                 if (_isPlaying) {
                   _audioService.stop();
                 } else {
                   _audioService.playSurah(widget.surahId);
                 }
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuranScreen(surahId: widget.surahId, surahName: widget.surahName)),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "PRACTICE",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<QuranSurah>(
          future: _surahFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No Surah Data"));
            }

            final surah = snapshot.data!;
            final juzNumber = _getJuzForSurah(surah.id);
            final arabicJuz = _getArabicJuzString(juzNumber);

            return Column(
              children: [
                // --- 1. Header Bar (Juz & Surah Name) ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // English/Arabic Surah Name Left
                      Text(
                        "سورة ${surah.name}", // Arabic name from JSON
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Juz Right
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

                // --- 2. Main Page Content (Title Box + Verses) ---
                // --- 2. Main Page Content (Title Box + Verses) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    // Inner padding for the 'page' content
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    // Decorative Double Border (Green/Gold)
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05), // Dark Glass Fill
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), // Dark Green Outer Border
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3), // Gold Inner Border
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8), // Space between border and text
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            // Decorative Title Box
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24, top: 16),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05), // Darker fill
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
                                    fontSize: 32,
                                    height: 1.6,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD4AF37), // Gold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            // Basmala Header Logic
                            if (surah.id != 1 && surah.id != 9)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                  style: GoogleFonts.amiri(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Text Rendering
                            _buildQuranText(surah.verses),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --- 3. Fixed Bottom Navigation Bar ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0C0E),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Surah Button
                      if (surah.id > 1)
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final prevId = surah.id - 1;
                              try {
                                final prevSurah = await QuranLocalService().getSurahDetails(prevId);
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuranReadMode(
                                        surahId: prevId,
                                        surahName: prevSurah.transliteration,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint("Error navigating to previous surah: $e");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(LucideIcons.chevron_left, color: Colors.white70, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Previous",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        const Spacer(), // Placeholder to keep spacing alignment if needed

                      // Spacing between buttons
                      if (surah.id > 1 && surah.id < 114)
                         const SizedBox(width: 16),

                      // Next Surah Button
                      if (surah.id < 114)
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final nextId = surah.id + 1;
                              try {
                                final nextSurah = await QuranLocalService().getSurahDetails(nextId);
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuranReadMode(
                                        surahId: nextId,
                                        surahName: nextSurah.transliteration,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint("Error navigating to next surah: $e");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next Surah",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(LucideIcons.chevron_right, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                         const Spacer(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuranText(List<QuranAyah> ayahs) {
     if (ayahs.isEmpty) {
       return const Text("No verses found");
     }

     List<InlineSpan> textSpans = [];

     for (var ayah in ayahs) {
       // Verse Text
       textSpans.add(
         TextSpan(
           text: "${ayah.text} ",
           style: GoogleFonts.amiri(
             color: Colors.white,
             fontSize: 28, // Large readable font
             height: 2.2, // Generous line height
           ),
         ),
       );

       // End of Ayah Marker
       textSpans.add(
         TextSpan(
           text: " ۝${_toArabicNumbers(ayah.id)} ",
           style: GoogleFonts.amiri(
             color: const Color(0xFFD4AF37), 
             fontSize: 28,
             fontWeight: FontWeight.bold,
           ),
         ),
       );
     }

     return SelectableText.rich(
       TextSpan(children: textSpans),
       textAlign: TextAlign.justify, // Block text Look
       textDirection: TextDirection.rtl, // Right-to-Left
     );
  }
}
