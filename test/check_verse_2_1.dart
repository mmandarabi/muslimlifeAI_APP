import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Check what verse 2:1 actually is', () async {
    print('='*70);
    print('VERSE 2:1 VERIFICATION');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
    final wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Get all words for verse 2:1
    print('\n📖 Verse 2:1 words:');
    final words = await wordDb.rawQuery('''
      SELECT id, location, text FROM words 
      WHERE surah = 2 AND ayah = 1
      ORDER BY word
    ''');
    
    print('   Total words: ${words.length}');
    print('   Word IDs: ${words.map((w) => w['id']).join(', ')}');
    print('   Text: ${words.map((w) => w['text']).join(' ')}');
    
    // Check: Is verse 2:1 the Bismillah or actual Quran text?
    print('\n🔍 What is Surah 2, Ayah 1?');
    print('   In the Quran, Surah Al-Baqarah starts with:');
    print('   - Bismillah (not counted as an ayah)');
    print('   - Ayah 1: الم (Alif Lam Meem)');
    print('');
    print('   If ayah 1 text shows "ﱁ ﱂ" this is likely:');
    print('   ﱁ = Alif (ا)');
    print('   ﱂ = Lam (ل)'); 
    print('   ("م" Meem might be missing or on next position)');
    
    // Get verse 2:2 to compare
    print('\n📖 Verse 2:2 words for comparison:');
    final words2 = await wordDb.rawQuery('''
      SELECT id, location, text FROM words 
      WHERE surah = 2 AND ayah = 2
      ORDER BY word
      LIMIT 10
    ''');
    
    print('   First 10 words: ${words2.map((w) => w['text']).join(' ')}');
    
    await wordDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
