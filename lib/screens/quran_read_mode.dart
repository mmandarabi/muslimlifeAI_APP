import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/models/quran_display_names.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/models/quran_ayah.dart';
import 'package:muslim_life_ai_demo/services/quran_local_service.dart';
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: [
                            // Decorative Title Box
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24, top: 16), // Added top spacing
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
                const SizedBox(height: 16),
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
