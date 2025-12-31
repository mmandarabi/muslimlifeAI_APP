import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../models/surah_header_ligature.dart';

/// Widget that displays the ornate calligraphic header for a Surah.
/// 
/// Uses the ligature-based QCF_SurahHeader font (surah-name-v4.ttf) to render
/// the decorative Thuluth script headers according to KFGQPC standards.
/// 
/// **Font Mechanism**:
/// - The font uses OpenType ligature features
/// - Input: Text like "surah001" produces ornate calligraphy artwork
/// - Each Surah's header is a single ligature glyph
/// 
/// **Example**:
/// ```dart
/// SurahHeaderWidget(surahId: 109) // Renders Al-Kafirun header
/// ```
class SurahHeaderWidget extends StatelessWidget {
  /// The Surah number (1-114)
  final int surahId;

  const SurahHeaderWidget({
    super.key,
    required this.surahId,
  });

  @override
  Widget build(BuildContext context) {
    // Validate Surah ID
    if (!isValidSurahId(surahId)) {
      // Fallback for invalid IDs
      return SizedBox(
        height: 110,
        child: Center(
          child: Text(
            '⚠️ Invalid Surah ID: $surahId',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    // Generate ligature code (e.g., "surah109")
    final String ligatureCode = getSurahLigatureCode(surahId);

    // SINGLE LAYER: Use only the Surah Name ligature (V4 font)
    // The V4 font likely contains the frame or aligns better without the legacy background
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          ligatureCode,
          style: TextStyle(
            fontFamily: 'QCF_SurahHeader', // Use the V4 font
            fontSize: 500, // Adjusted size since this is now the main element
            color: Color(0xFFD4AF37), // KFGQPC Gold (assuming V4 is color or needs tint)
            height: 1.0,
            fontFeatures: const [FontFeature.enable('liga')],
          ),
        ),
      ),
    );
  }
}