import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify special pages structure', () async {
    print('='*70);
    print('VERIFYING SPECIAL PAGES STRUCTURE');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Check Pages: 1, 187, 596
    final pagesToCheck = [1, 187, 596];
    
    for (final pageNum in pagesToCheck) {
      final layoutResult = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number
        FROM pages 
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      print('\n${'='*70}');
      print('PAGE $pageNum');
      print('='*70);
      print('Total lines: ${layoutResult.length}\n');
      
      for (var row in layoutResult) {
        final lineNum = row['line_number'];
        final lineType = row['line_type'];
        final surahNum = row['surah_number'];
        
        String display = 'Line $lineNum: $lineType';
        if (lineType == 'surah_name' && surahNum != null) {
          display += ' (Surah $surahNum)';
        }
        print(display);
      }
      
      // Summary
      final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
      final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
      final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
      
      print('\nSummary:');
      print('  Headers: $headerCount');
      print('  Bismillah: $bismillahCount');
      print('  Ayah lines: $ayahCount');
      
      // Page-specific verification
      if (pageNum == 1) {
        print('\n✅ Page 1 should have:');
        print('   - 1 header (Al-Fatiha)');
        print('   - 0 or 1 bismillah (depends on whether Bismillah counts as separate line)');
        print('   - ~7-13 ayah lines (7 verses with large spacing)');
        print('   - Total: 8-15 lines');
      } else if (pageNum == 187) {
        print('\n✅ Page 187 should have:');
        print('   - 1 header (At-Tawbah, Surah 9)');
        print('   - 0 bismillah (At-Tawbah exception)');
        print('   - ~14 ayah lines');
        print('   - Actual: ${headerCount == 1 && bismillahCount == 0 ? "✅ CORRECT" : "❌ WRONG"}');
      } else if (pageNum == 596) {
        print('\n✅ Page 596 should have:');
        print('   - 3 headers (Al-Adiyat, Al-Qariah, At-Takathur)');
        print('   - 3 bismillah (one per surah)');
        print('   - Remaining lines for ayahs');
        print('   - Actual: ${headerCount == 3 && bismillahCount == 3 ? "✅ CORRECT" : "❌ WRONG"}');
      }
    }
    
    await layoutDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
