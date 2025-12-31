import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('FINAL FIX: All 604 Pages (Correct Approach)', () async {
    print('='*70);
    print('FINAL QURAN REPAIR - ALL 604 PAGES');
    print('Building Complete Ayahs from Word Database');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final glyphDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
    final hfsDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\Hfsdb\qpc-hafs-word-by-word.db';
    final textFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt';
    final outputFilePath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map_COMPLETE.txt';
    
    print('\nCreating backup...');
    await File(textFilePath).copy('$textFilePath.COMPLETE_BACKUP');
    print('✅ Backup saved\n');
    
    final glyphDb = await databaseFactory.openDatabase(glyphDbPath, options: OpenDatabaseOptions(readOnly: true));
    final hfsDb = await databaseFactory.openDatabase(hfsDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Load original file for page 2 only (special/ornamental)
    final originalLines = await File(textFilePath).readAsLines();
    final originalPage2Lines = originalLines.where((l) => l.trim().startsWith('2,')).toList();
    
    final repairedLines = <String>[];
    int pagesProcessed = 0;
    
    for (int pageNum = 1; pageNum <= 604; pageNum++) {
      if (pageNum % 50 == 0) print('Processing page $pageNum...');
      
      // SPECIAL CASE: Page 2 only (keep original - ornamental)
      if (pageNum == 2) {
        repairedLines.addAll(originalPage2Lines);
        pagesProcessed++;
        continue;
      }
      
      // Get ayahs on this page from glyph database
      // Group by line and ayah
      final ayahsResult = await glyphDb.rawQuery('''
        SELECT DISTINCT line_number, sura_number, ayah_number
        FROM glyphs
        WHERE page_number = ?
        ORDER BY line_number, sura_number, ayah_number
      ''', [pageNum]);
      
      if (ayahsResult.isEmpty) {
        print('⚠️  Page $pageNum: No ayahs');
        continue;
      }
      
      // Group ayahs by line
      final lineMap = <int, List<Map<String, dynamic>>>{};
      for (final row in ayahsResult) {
        final lineNum = row['line_number'] as int;
        lineMap.putIfAbsent(lineNum, () => []).add(row);
      }
      
      // Build each line
      final sortedLines = lineMap.keys.toList()..sort();
      final includedAyahs = <String>{}; // Track ayahs already included
      
      for (final lineNum in sortedLines) {
        final ayahsOnLine = lineMap[lineNum]!;
        final allWords = <String>[];
        
        // For each ayah on this line, get ALL its words (but only if not already included)
        for (final ayahInfo in ayahsOnLine) {
          final sura = ayahInfo['sura_number'] as int;
          final ayah = ayahInfo['ayah_number'] as int;
          final ayahKey = '$sura:$ayah';
          
          // Skip if we already included this ayah on a previous line
          if (includedAyahs.contains(ayahKey)) {
            continue;
          }
          
          // Get complete ayah from word database
          final wordsResult = await hfsDb.rawQuery('''
            SELECT text FROM words
            WHERE surah = ? AND ayah = ?
            ORDER BY word
          ''', [sura, ayah]);
          
          final words = wordsResult.map((r) => r['text'] as String).toList();
          allWords.addAll(words);
          includedAyahs.add(ayahKey); // Mark as included
        }
        
        if (allWords.isNotEmpty) {
          repairedLines.add('$pageNum,${allWords.join(' ')}');
        }
      }
      
      pagesProcessed++;
    }
    
    await glyphDb.close();
    await hfsDb.close();
    
    await File(outputFilePath).writeAsString(repairedLines.join('\n'));
    
    print('\n' + '='*70);
    print('REPAIR COMPLETE!');
    print('='*70);
    print('Pages processed: $pagesProcessed / 604');
    print('Output: $outputFilePath');
    print('\n✅ Now apply: Copy this to mushaf_v2_map.txt');
    print('='*70);
    
  }, timeout: const Timeout(Duration(minutes: 15)));
}
