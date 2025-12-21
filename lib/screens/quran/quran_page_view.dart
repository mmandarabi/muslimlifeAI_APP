import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/quran_surah.dart';
import '../../models/quran_ayah.dart';
import '../../models/quran_display_names.dart';
import '../../theme/app_theme.dart';

class QuranPageView extends StatelessWidget {
  final List<QuranAyah> verses;
  final double fontSize;
  final int? activeAyahId;
  final Color textColor;
  final int surahId;
  final int? playingSurahId;
  final TextAlign align;
  final Function(int surahId, int ayahId) onAyahDoubleTap;

  const QuranPageView({
    super.key,
    required this.verses,
    required this.fontSize,
    required this.activeAyahId,
    required this.textColor,
    required this.surahId,
    required this.playingSurahId,
    required this.onAyahDoubleTap,
    this.align = TextAlign.justify,
  });

  @override
  Widget build(BuildContext context) {
    if (verses.isEmpty) {
      return Text("No verses found", style: TextStyle(color: textColor));
    }

    List<InlineSpan> textSpans = [];

    for (var ayah in verses) {
      final isActive = (surahId == playingSurahId && ayah.id == activeAyahId);
      final ayahColor = isActive ? AppColors.primary : textColor;
      
      textSpans.add(
        TextSpan(
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              debugPrint("QuranPageView: LongPress detected on Ayah ${ayah.id}");
              onAyahDoubleTap(surahId, ayah.id);
            },
          children: [
            TextSpan(
              text: " ${ayah.text} ",
              recognizer: DoubleTapGestureRecognizer()
                ..onDoubleTap = () {
                  debugPrint("QuranPageView: DoubleTap detected on Ayah ${ayah.id}");
                  onAyahDoubleTap(surahId, ayah.id);
                },
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanic',
                fontSize: fontSize, 
                height: 2.1,
                color: ayahColor,
                backgroundColor: isActive ? AppColors.primary.withValues(alpha: 0.15) : null,
              ),
            ),
            TextSpan(
              text: " ${_toArabicNumbers(ayah.id)} ",
              recognizer: DoubleTapGestureRecognizer()
                ..onDoubleTap = () => onAyahDoubleTap(surahId, ayah.id),
              style: TextStyle(
                fontFamily: 'KFGQPCUthmanic',
                fontSize: fontSize * 1.1,
                color: isActive ? AppColors.primary : const Color(0xFFD4AF37),
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      );
    }

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: align,
      textDirection: TextDirection.rtl,
    );
  }

  String _toArabicNumbers(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    
    String result = number.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}

class SurahHeaderCartouche extends StatelessWidget {
  final String surahName;
  final Color textColor;

  const SurahHeaderCartouche({
    super.key,
    required this.surahName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primary;
    final frameColor = accentColor.withValues(alpha: 0.6);
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRect(
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.05),
                border: Border.symmetric(
                  horizontal: BorderSide(color: frameColor.withValues(alpha: 0.4), width: 1.5),
                ),
              ),
              child: Opacity(
                opacity: 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => const Text(
                    " ✿ ",
                    style: TextStyle(color: AppColors.primary, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 0.8),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor.withValues(alpha: 0.15), width: 1.5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            child: Text("﴿", style: TextStyle(fontFamily: 'KFGQPCUthmanic', fontSize: 40, color: accentColor.withValues(alpha: 0.6))),
          ),
          Positioned(
            right: 8,
            child: Text("﴾", style: TextStyle(fontFamily: 'KFGQPCUthmanic', fontSize: 40, color: accentColor.withValues(alpha: 0.6))),
          ),
          Text(
            "سُورَةُ $surahName",
            style: GoogleFonts.amiri(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: accentColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
