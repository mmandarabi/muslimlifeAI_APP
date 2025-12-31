import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CRITICAL WORD DISTRIBUTION TEST - Surah 112 on Page 604
/// 
/// This test verifies that the 2 ayah lines for Surah Al-Ikhlas
/// correctly distribute the words of all 4 verses.
void main() {
  group('CRITICAL: Word Distribution - Surah 112 (Al-Ikhlas)', () {
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
    
    test('CRITICAL: Surah 112 - Line 3 (First Ayah Line)', () async {
      print('\n' + '='*80);
      print('SURAH 112 (AL-IKHLAS) - LINE 3 VERIFICATION');
      print('='*80);
      
      // Get layout for Page 604, Line 3 (first ayah line for Surah 112)
      final line3Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, first_word_id, last_word_id
        FROM pages
        WHERE page_number = 604 AND line_number = 3
      ''');
      
      expect(line3Layout, hasLength(1), reason: 'Should have exactly 1 layout entry for Line 3');
      
      final firstWordId = line3Layout.first['first_word_id'] as int;
      final lastWordId = line3Layout.first['last_word_id'] as int;
      
      print('\nLayout DB:');
      print('  First word ID: $firstWordId');
      print('  Last word ID: $lastWordId');
      print('  Total words: ${lastWordId - firstWordId + 1}');
      
      // Get words from word database
      final words = await wordDb.rawQuery('''
        SELECT id, location, surah, ayah, word, text
        FROM words
        WHERE id >= ? AND id <= ?
        ORDER BY id
      ''', [firstWordId, lastWordId]);
      
      print('\nWord-by-Word from Database:');
      for (var w in words) {
        print('  ${w['location']}: ${w['text']}');
      }
      
      // Group by verse
      final verseGroups = <int, List<Map<String, dynamic>>>{};
      for (var w in words) {
        final ayah = w['ayah'] as int;
        verseGroups.putIfAbsent(ayah, () => []).add(w);
      }
      
      print('\nVerses on Line 3:');
      for (var ayah in verseGroups.keys.toList()..sort()) {
        final versWords = verseGroups[ayah]!;
        final wordRange = '${versWords.first['word']}-${versWords.last['word']}';
        final text = versWords.map((w) => w['text']).join(' ');
        print('  Verse 112:$ayah ($wordRange): ${versWords.length} words');
        print('    $text');
      }
      
      // Get source file line
      final page604Source = sourceByPage[604] ?? [];
      expect(page604Source.length, greaterThanOrEqualTo(1), reason: 'Page 604 must have source lines');
      
      // Line 3 should be the first ayah line (index 0 after headers/bismillah)
      final sourceLine3 = page604Source[0].split(',')[1];
      print('\nSource File Line 3:');
      print('  $sourceLine3');
      
      print('\n✅ Line 3 contains ${verseGroups.length} verse(s) with ${words.length} total words');
    });
    
    test('CRITICAL: Surah 112 - Line 4 (Second Ayah Line)', () async {
      print('\n' + '='*80);
      print('SURAH 112 (AL-IKHLAS) - LINE 4 VERIFICATION');
      print('='*80);
      
      // Get layout for Page 604, Line 4 (second ayah line for Surah 112)
      final line4Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, first_word_id, last_word_id
        FROM pages
        WHERE page_number = 604 AND line_number = 4
      ''');
      
      expect(line4Layout, hasLength(1), reason: 'Should have exactly 1 layout entry for Line 4');
      
      final firstWordId = line4Layout.first['first_word_id'] as int;
      final lastWordId = line4Layout.first['last_word_id'] as int;
      
      print('\nLayout DB:');
      print('  First word ID: $firstWordId');
      print('  Last word ID: $lastWordId');
      print('  Total words: ${lastWordId - firstWordId + 1}');
      
      // Get words from word database
      final words = await wordDb.rawQuery('''
        SELECT id, location, surah, ayah, word, text
        FROM words
        WHERE id >= ? AND id <= ?
        ORDER BY id
      ''', [firstWordId, lastWordId]);
      
      print('\nWord-by-Word from Database:');
      for (var w in words) {
        print('  ${w['location']}: ${w['text']}');
      }
      
      // Group by verse
      final verseGroups = <int, List<Map<String, dynamic>>>{};
      for (var w in words) {
        final ayah = w['ayah'] as int;
        verseGroups.putIfAbsent(ayah, () => []).add(w);
      }
      
      print('\nVerses on Line 4:');
      for (var ayah in verseGroups.keys.toList()..sort()) {
        final versWords = verseGroups[ayah]!;
        final wordRange = '${versWords.first['word']}-${versWords.last['word']}';
        final text = versWords.map((w) => w['text']).join(' ');
        print('  Verse 112:$ayah ($wordRange): ${versWords.length} words');
        print('    $text');
      }
      
      // Get source file line
      final page604Source = sourceByPage[604] ?? [];
      expect(page604Source.length, greaterThanOrEqualTo(2), reason: 'Page 604 must have at least 2 source lines');
      
      // Line 4 should be the second ayah line (index 1)
      final sourceLine4 = page604Source[1].split(',')[1];
      print('\nSource File Line 4:');
      print('  $sourceLine4');
      
      print('\n✅ Line 4 contains ${verseGroups.length} verse(s) with ${words.length} total words');
    });
    
    test('CRITICAL: Complete Surah 112 Verification', () async {
      print('\n' + '='*80);
      print('COMPLETE SURAH 112 (AL-IKHLAS) VERIFICATION');
      print('='*80);
      
      // Get all 4 verses of Surah 112
      for (int ayah = 1; ayah <= 4; ayah++) {
        final verseWords = await wordDb.rawQuery('''
          SELECT text FROM words
          WHERE surah = 112 AND ayah = ?
          ORDER BY word
        ''', [ayah]);
        
        final text = verseWords.map((w) => w['text']).join(' ');
        print('\nVerse 112:$ayah (${verseWords.length} words):');
        print('  $text');
      }
      
      // Verify that Lines 3-4 contain ALL of Surah 112
      final lines34 = await layoutDb.rawQuery('''
        SELECT first_word_id, last_word_id
        FROM pages
        WHERE page_number = 604 AND line_number IN (3, 4)
        ORDER BY line_number
      ''');
      
      expect(lines34, hasLength(2), reason: 'Lines 3-4 should exist');
      
      final totalFirstId = lines34.first['first_word_id'] as int;
      final totalLastId = lines34.last['last_word_id'] as int;
      
      final allWords = await wordDb.rawQuery('''
        SELECT DISTINCT surah, ayah FROM words
        WHERE id >= ? AND id <= ?
        ORDER BY surah, ayah
      ''', [totalFirstId, totalLastId]);
      
      print('\n✅ Lines 3-4 contain:');
      for (var verse in allWords) {
        print('  Verse ${verse['surah']}:${verse['ayah']}');
      }
      
      // Verify all are from Surah 112
      final surah112Only = allWords.every((v) => v['surah'] == 112);
      expect(surah112Only, isTrue, reason: 'Lines 3-4 should only contain Surah 112');
      
      // Verify all 4 verses present
      final verseCount = allWords.length;
      expect(verseCount, equals(4), reason: 'Lines 3-4 must contain all 4 verses of Surah 112');
      
      print('\n✅ PASSED: Lines 3-4 correctly contain all 4 verses of Surah Al-Ikhlas');
    });
  });
}
