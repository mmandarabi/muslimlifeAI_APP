import 'package:flutter_test/flutter_test.dart';
import '../lib/models/qcf_surah_header_unicode.dart';

void main() {
  test('Check Juz 30 surah unicode coverage', () {
    print('\n═══════════════════════════════════');
    print('JUZ 30 SURAH HEADER UNICODE CHECK');
    print('═══════════════════════════════════\n');
    
    // Juz 30 contains surahs 78-114
    final List<int> missingSurahs = [];
    final List<int> presentSurahs = [];
    
    for (int surah = 78; surah <= 114; surah++) {
      final unicode = kQCFSurahHeaderUnicode[surah];
      
      if (unicode == null || unicode.isEmpty) {
        missingSurahs.add(surah);
        print('❌ Surah $surah: MISSING or EMPTY');
      } else {
        presentSurahs.add(surah);
        // Show first few and last few
        if (surah <= 80 || surah >= 112) {
          print('✅ Surah $surah: ${unicode.codeUnits}');
        }
      }
    }
    
    if (missingSurahs.isNotEmpty && missingSurahs.length <= 10) {
      print('\n⚠️ Missing unicode for surahs: ${missingSurahs.join(", ")}');
    }
    
    print('\n📊 SUMMARY:');
    print('  Total surahs in Juz 30: 37 (78-114)');
    print('  Present: ${presentSurahs.length}');
    print('  Missing: ${missingSurahs.length}');
    print('  Coverage: ${(presentSurahs.length / 37 * 100).toStringAsFixed(1)}%');
    
    print('\n═══════════════════════════════════\n');
    
    // All Juz 30 surahs should have unicode
    expect(missingSurahs.length, equals(0), 
      reason: 'All Juz 30 surahs (78-114) should have unicode. Missing: $missingSurahs');
  });

  test('Check pages 1-3 surah unicode', () {
    print('\n═══════════════════════════════════');
    print('PAGES 1-3 SURAH HEADER CHECK');
    print('═══════════════════════════════════\n');
    
    // Page 1: Surah 1 (Al-Fatiha)
    // Page 2-3: Surah 2 (Al-Baqarah)
    
    for (int surah = 1; surah <= 2; surah++) {
      final unicode = kQCFSurahHeaderUnicode[surah];
      print('Surah $surah: ${unicode != null ? "✅ ${unicode.codeUnits}" : "❌ MISSING"}');
    }
    
    print('\n═══════════════════════════════════\n');
  });
}
