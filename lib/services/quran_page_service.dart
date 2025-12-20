import 'package:quran/quran.dart' as quran;

class QuranPageService {
  // Singleton pattern
  static final QuranPageService _instance = QuranPageService._internal();
  factory QuranPageService() => _instance;
  QuranPageService._internal();

  /// Returns the page number (1-604) for a specific verse.
  int getPageNumber(int surahNumber, int verseNumber) {
    return quran.getPageNumber(surahNumber, verseNumber);
  }

  /// Safe version of getPageNumber that handles Bismillah (-786) and out-of-bounds IDs.
  int getSafePageNumber(int surahNumber, int verseNumber) {
    if (verseNumber <= 0) return quran.getPageNumber(surahNumber, 1);
    
    // Clamp to surah's verse count to avoid "Invalid verse number" exception
    final totalVerses = quran.getVerseCount(surahNumber);
    final clampedVerse = verseNumber > totalVerses ? totalVerses : verseNumber;
    
    return quran.getPageNumber(surahNumber, clampedVerse);
  }

  /// Returns the Juz number for a specific verse.
  int getJuzNumber(int surahNumber, int verseNumber) {
    return quran.getJuzNumber(surahNumber, verseNumber);
  }

  /// Returns total pages in the standard Mushaf (usually 604).
  int get totalPages => 604;

  /// Returns the data for a specific page:
  /// List of Maps: { 'surah': int, 'start': int, 'end': int }
  List<Map<String, int>> getPageData(int pageNumber) {
    final data = quran.getPageData(pageNumber);
    return List<Map<String, int>>.from(data.map((e) => Map<String, int>.from(e)));
  }
  
  /// Helper: Check if an ayah is the start of a page
  bool isPageStart(int surah, int ayah) {
     final page = getPageNumber(surah, ayah);
     // If previous ayah is on a different page (or it's 1:1)
     if (surah == 1 && ayah == 1) return true;
     
     // This is expensive to check sequentially.
     // Better: Get page data and check if this ayah matches 'start' of any entry.
     final data = getPageData(page);
     for (var entry in data) {
       if (entry['surah'] == surah && entry['start'] == ayah) return true;
     }
     return false;
  }

  /// Returns the last ayah ID for a given surah on a specific page.
  int? getLastAyahIdOnPage(int surahId, int pageNumber) {
    final data = getPageData(pageNumber);
    for (var entry in data) {
      if (entry['surah'] == surahId) return entry['end'];
    }
    return null;
  }
}
