/// QCF Surah Header Ligature System
/// 
/// This file provides ligature code generation for the QCF_SurahHeader font.
/// Unlike traditional fonts that use Unicode characters, this font uses a 
/// ligature-based system where each Surah's ornate calligraphy is mapped to
/// a semantic text string.
/// 
/// **CRITICAL: Font Mechanism**
/// - The font file `surah-name-v4.ttf` uses OpenType ligature features
/// - Input: Text string like "surah001", "surah109"
/// - Output: Complete ornate calligraphic artwork as a single glyph
/// 
/// **Source**: 
/// - Font: surah-name-v4.ttf from Quranic Universal Library (Tarteel AI)
/// - Standard: KFGQPC (King Fahd Glorious Quran Printing Complex)
/// - Reference: Quran.com, Tarteel AI implementation
/// 
/// **Example Usage**:
/// ```dart
/// final ligatureCode = getSurahLigatureCode(109); // Returns "surah109"
/// Text(
///   ligatureCode,
///   style: TextStyle(
///     fontFamily: 'QCF_SurahHeader',
///     fontSize: 48,
///     fontFeatures: [FontFeature.enable('liga')],
///   ),
/// )
/// ```

/// Generates the ligature code for a given Surah ID.
/// 
/// The ligature format is: `surah${number}` where number is zero-padded to 3 digits.
/// 
/// **Parameters**:
/// - [surahId]: The Surah number (1-114)
/// 
/// **Returns**: 
/// - Ligature string in format "surah001", "surah002", ..., "surah114"
/// 
/// **Throws**:
/// - [ArgumentError] if surahId is not in valid range (1-114)
/// 
/// **Examples**:
/// - `getSurahLigatureCode(1)` → `"surah001"` (Al-Fatiha)
/// - `getSurahLigatureCode(109)` → `"surah109"` (Al-Kafirun)
/// - `getSurahLigatureCode(114)` → `"surah114"` (An-Nas)
String getSurahLigatureCode(int surahId) {
  // Validate input range
  if (surahId < 1 || surahId > 114) {
    throw ArgumentError(
      'Invalid Surah ID: $surahId. Must be between 1 and 114.',
      'surahId',
    );
  }

  // Format: surah + zero-padded 3-digit number
  // Example: 1 → "001", 109 → "109"
  final paddedNumber = surahId.toString().padLeft(3, '0');
  
  return 'surah$paddedNumber';
}

/// Validates if a Surah ID is within the valid range (1-114).
/// 
/// **Parameters**:
/// - [surahId]: The Surah number to validate
/// 
/// **Returns**: 
/// - `true` if valid (1-114), `false` otherwise
bool isValidSurahId(int surahId) {
  return surahId >= 1 && surahId <= 114;
}
