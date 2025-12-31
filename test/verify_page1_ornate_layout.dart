import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CRITICAL VERIFICATION - Page 1 (Surat al-Fatiha) 15-Line Ornate Layout
/// 
/// This test verifies the exact KFGQPC V2 (1421H) 15-line structure
/// with verses spanning multiple lines.
void main() {
  group('CRITICAL: Page 1 (Surat al-Fatiha) - 15-Line Ornate Layout', () {
    late Database layoutDb;
    late Database wordDb;
    late Map<int, List<String>> sourceByPage;
    
    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
      final wordDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2.db';
      final sourceFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
      
      layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
      wordDb = await databaseFactory.openDatabase(wordDbPath, options: OpenDatabaseOptions(readOnly: true));
      
      // Read source file
      final sourceContent = await File(sourceFilePath).readAsString();
      final sourceLines = sourceContent.replaceAll('\r\n', '\n').split('\n');
      
      sourceByPage = {};
      for (final line in sourceLines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        
        final parts = trimmed.split(',');
        if (parts.length >= 2) {
          final pageNum = int.tryParse(parts[0]);
          if (pageNum != null) {
            sourceByPage.putIfAbsent(pageNum, () => []).add(trimmed);
          }
        }
      }
    });
    
    tearDownAll(() async {
      await layoutDb.close();
      await wordDb.close();
    });
    
    test('CRITICAL: Page 1 has exactly 15 lines', () async {
      final page1Layout = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages WHERE page_number = 1
      ''');
      
      final lineCount = page1Layout.first['count'] as int;
      expect(lineCount, equals(15), reason: 'Page 1 must have exactly 15 lines (KFGQPC V2 standard)');
      
      print('✅ Page 1 has 15 lines (ornate layout)');
    });
    
    test('CRITICAL: Page 1 Complete Line-by-Line Verification', () async {
      print('\n' + '='*80);
      print('PAGE 1 (SURAT AL-FATIHA) - COMPLETE VERIFICATION');
      print('='*80);
      
      // Get all 15 lines for Page 1
      final page1Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, first_word_id, last_word_id
        FROM pages
        WHERE page_number = 1
        ORDER BY line_number
      ''');
      
      expect(page1Layout.length, equals(15), reason: 'Must have 15 lines');
      
      final page1Source = sourceByPage[1] ?? [];
      int ayahLineIndex = 0;
      
      for (var layoutLine in page1Layout) {
        final lineNum = layoutLine['line_number'];
        final lineType = layoutLine['line_type'];
        final firstWordId = layoutLine['first_word_id'];
        final lastWordId = layoutLine['last_word_id'];
        
        print('\nLine $lineNum: $lineType');
        
        if (lineType == 'surah_name') {
          print('  📖 HEADER - Surat al-Fatiha');
          print('  Source: No text (rendered via font)');
          
        } else if (lineType == 'ayah') {
          if (firstWordId != null && lastWordId != null) {
            // Get words for this line
            final words = await wordDb.rawQuery('''
              SELECT id, location, surah, ayah, word, text
              FROM words
              WHERE id >= ? AND id <= ?
              ORDER BY id
            ''', [firstWordId, lastWordId]);
            
            // Group by verse
            final verseGroups = <int, List<Map<String, dynamic>>>{};
            for (var w in words) {
              final ayah = w['ayah'] as int;
              verseGroups.putIfAbsent(ayah, () => []).add(w);
            }
            
            print('  Word count: ${words.length}');
            for (var ayah in verseGroups.keys.toList()..sort()) {
              final versWords = verseGroups[ayah]!;
              final wordRange = '${versWords.first['word']}-${versWords.last['word']}';
              final text = versWords.map((w) => w['text']).join(' ');
              print('  Verse 1:$ayah ($wordRange): $text');
            }
            
            // Get source line
            if (ayahLineIndex < page1Source.length) {
              final sourceLine = page1Source[ayahLineIndex].split(',')[1];
              print('  Source: $sourceLine');
              ayahLineIndex++;
            }
          }
        }
      }
      
      print('\n' + '='*80);
      print('SUMMARY');
      print('='*80);
      print('Total lines: 15');
      print('Ayah lines in source: ${page1Source.length}');
    });
    
    test('CRITICAL: Verify specific verse spanning', () async {
      print('\n' + '='*80);
      print('VERSE SPANNING VERIFICATION');
      print('='*80);
      
      // Get all words for each verse
      for (int ayah = 1; ayah <= 7; ayah++) {
        final verseWords = await wordDb.rawQuery('''
          SELECT id, word, text FROM words
          WHERE surah = 1 AND ayah = ?
          ORDER BY word
        ''', [ayah]);
        
        final text = verseWords.map((w) => w['text']).join(' ');
        final wordIds = verseWords.map((w) => w['id']).toList();
        
        print('\nVerse 1:$ayah (${verseWords.length} words):');
        print('  Text: $text');
        print('  Word IDs: ${wordIds.join(', ')}');
        
        // Check which lines contain this verse
        final linesContaining = await layoutDb.rawQuery('''
          SELECT line_number FROM pages
          WHERE page_number = 1 
            AND line_type = 'ayah'
            AND first_word_id <= ?
            AND last_word_id >= ?
          ORDER BY line_number
        ''', [wordIds.last, wordIds.first]);
        
        final lines = linesContaining.map((l) => l['line_number']).join(', ');
        print('  Appears on line(s): $lines');
        
        if (ayah == 5) {
          expect(linesContaining.length, greaterThan(1), 
            reason: 'Verse 1:5 should span multiple lines');
        }
        if (ayah == 6) {
          expect(linesContaining.length, greaterThan(1),
            reason: 'Verse 1:6 should span multiple lines');
        }
        if (ayah == 7) {
          expect(linesContaining.length, greaterThan(1),
            reason: 'Verse 1:7 should span multiple lines');
        }
      }
    });
    
    test('CRITICAL: Source file matches expected ayah count', () {
      final page1Source = sourceByPage[1] ?? [];
      
      // Page 1 should have 7 ayah lines in source
      expect(page1Source.length, equals(7),
        reason: 'Source file should have 7 ayah lines for Page 1 (one per verse)');
      
      print('\n✅ Page 1 source has 7 lines (one per complete verse)');
      print('✅ Layout DB has 15 lines (ornate layout with verse spanning)');
    });
  });
}
