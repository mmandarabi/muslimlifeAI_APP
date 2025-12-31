import 'package:flutter_test/flutter_test.dart';
import '../lib/models/qcf_surah_header_unicode.dart';

void main() {
  test('Check if Surahs 109, 110, 111 have unicode', () {
    print('\n=== CHECKING SURAHS 109-111 ===');
    
    for (int surah = 109; surah <= 111; surah++) {
      final unicode = kQCFSurahHeaderUnicode[surah];
      print('Surah $surah: ${unicode != null ? "✅ ${unicode.codeUnits}" : "❌ MISSING"}');
    }
    
    print('\nCheck Surahs 112-114 (Page 604):');
    for (int surah = 112; surah <= 114; surah++) {
      final unicode = kQCFSurahHeaderUnicode[surah];
      print('Surah $surah: ${unicode != null ? "✅ ${unicode.codeUnits}" : "❌ MISSING"}');
    }
    
    print('================================\n');
    
    expect(kQCFSurahHeaderUnicode[109], isNotNull);
    expect(kQCFSurahHeaderUnicode[110], isNotNull);
    expect(kQCFSurahHeaderUnicode[111], isNotNull);
    expect(kQCFSurahHeaderUnicode[112], isNotNull);
    expect(kQCFSurahHeaderUnicode[113], isNotNull);
    expect(kQCFSurahHeaderUnicode[114], isNotNull);
  });
}
