import 'package:quran/quran.dart' as quran;

void main() {
  print('=== Quran Package Debug ===');
  
  // Test specific Surahs that are appearing in the ghost text
  // 62 = Al-Jumu'ah, 112 = Al-Ikhlas
  
  print('\n-- Ghost Text Suspects --');
  print('Surah 62: ${quran.getSurahName(62)}');
  print('Surah 112: ${quran.getSurahName(112)}');

  print('\n-- Surahs on Page 604 (103, 104, 105) --');
  // Expected: Al-Asr, Al-Humazah, Al-Fil
  print('Surah 103: ${quran.getSurahName(103)}');
  print('Surah 104: ${quran.getSurahName(104)}');
  print('Surah 105: ${quran.getSurahName(105)}');
  
  print('\n-- Range Check --');
  for (int i = 1; i <= 5; i++) {
    print('Surah $i: ${quran.getSurahName(i)}');
  }
}
