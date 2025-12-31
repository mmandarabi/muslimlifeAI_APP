import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CRITICAL TEST SUITE for Mushaf Text Cleaning Script
/// 
/// This test MUST pass before accepting the cleaned output.
/// Tests all critical pages and validates special cases.
void main() {
  group('CRITICAL: Mushaf Cleaning Verification', () {
    late Database layoutDb;
    late String cleanedFilePath;
    late Map<int, List<String>> cleanedPages;
    
    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
      cleanedFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map_CLEANED_RECONSTRUCTED.txt';
      
      // Open layout DB
      layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
      
      // Read cleaned file
      final fileContent = await File(cleanedFilePath).readAsString();
      final lines = fileContent.replaceAll('\r\n', '\n').split('\n');
      
      // Parse into page map
      cleanedPages = {};
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        
        final parts = trimmed.split(',');
        if (parts.length >= 2) {
          final pageNum = int.tryParse(parts[0]);
          if (pageNum != null) {
            cleanedPages.putIfAbsent(pageNum, () => []).add(trimmed);
          }
        }
      }
    });
    
    tearDownAll(() async {
      await layoutDb.close();
    });
    
    test('CRITICAL: All 604 pages must be present', () {
      expect(cleanedPages.length, equals(604), 
        reason: 'Cleaned file must contain all 604 pages');
      
      for (int i = 1; i <= 604; i++) {
        expect(cleanedPages.containsKey(i), isTrue,
          reason: 'Page $i is missing from cleaned file');
      }
    });
    
    test('CRITICAL: Page 1 (Al-Fatiha) - 7 ayah lines', () async {
      final layoutResult = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 1 AND line_type = 'ayah'
      ''');
      
      final expectedCount = layoutResult.first['count'] as int;
      final actualCount = cleanedPages[1]?.length ?? 0;
      
      expect(actualCount, equals(expectedCount),
        reason: 'Page 1 should have $expectedCount ayah lines (Al-Fatiha)');
      expect(actualCount, equals(7),
        reason: 'Page 1 should have exactly 7 ayah lines');
    });
    
    test('CRITICAL: Page 2 (Ornamental) - 6 ayah lines', () async {
      final layoutResult = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 2 AND line_type = 'ayah'
      ''');
      
      final expectedCount = layoutResult.first['count'] as int;
      final actualCount = cleanedPages[2]?.length ?? 0;
      
      expect(actualCount, equals(expectedCount),
        reason: 'Page 2 should have $expectedCount ayah lines');
      expect(actualCount, equals(6),
        reason: 'Page 2 ornamental page should have 6 ayah lines');
    });
    
    test('CRITICAL: Page 187 (At-Tawbah) - 14 ayah lines, NO bismillah', () async {
      // Check layout DB confirms no bismillah
      final bismillahCheck = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 187 AND line_type = 'basmallah'
      ''');
      
      final bismillahCount = bismillahCheck.first['count'] as int;
      expect(bismillahCount, equals(0),
        reason: 'Page 187 (Surah At-Tawbah) should have NO bismillah');
      
      // Check ayah lines
      final ayahResult = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 187 AND line_type = 'ayah'
      ''');
      
      final expectedCount = ayahResult.first['count'] as int;
      final actualCount = cleanedPages[187]?.length ?? 0;
      
      expect(actualCount, equals(expectedCount),
        reason: 'Page 187 should have $expectedCount ayah lines');
      expect(actualCount, equals(14),
        reason: 'Page 187 should have 14 ayah lines');
    });
    
    test('CRITICAL: Page 596 - 11 ayah lines (3 surahs)', () async {
      final ayahResult = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 596 AND line_type = 'ayah'
      ''');
      
      final expectedCount = ayahResult.first['count'] as int;
      final actualCount = cleanedPages[596]?.length ?? 0;
      
      expect(actualCount, equals(expectedCount),
        reason: 'Page 596 should have $expectedCount ayah lines');
      expect(actualCount, equals(11),
        reason: 'Page 596 should have 11 ayah lines');
    });
    
    test('CRITICAL: Page 604 (Last page) - 9 ayah lines (3 surahs)', () async {
      final ayahResult = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 604 AND line_type = 'ayah'
      ''');
      
      final expectedCount = ayahResult.first['count'] as int;
      final actualCount = cleanedPages[604]?.length ?? 0;
      
      expect(actualCount, equals(expectedCount),
        reason: 'Page 604 should have $expectedCount ayah lines');
      expect(actualCount, equals(9),
        reason: 'Page 604 should have 9 ayah lines (Al-Ikhlas, Al-Falaq, An-Nas)');
    });
    
    test('CRITICAL: All pages match expected ayah line counts', () async {
      for (int pageNum = 1; pageNum <= 604; pageNum++) {
        final ayahResult = await layoutDb.rawQuery('''
          SELECT COUNT(*) as count FROM pages 
          WHERE page_number = ? AND line_type = 'ayah'
        ''', [pageNum]);
        
        final expectedCount = ayahResult.first['count'] as int;
        final actualCount = cleanedPages[pageNum]?.length ?? 0;
        
        expect(actualCount, equals(expectedCount),
          reason: 'Page $pageNum: expected $expectedCount ayah lines, got $actualCount');
      }
    });
    
    test('CRITICAL: Special markers preserved (Sajdah ۩)', () {
      // Check for sajdah markers in cleaned file
      final fileContent = File(cleanedFilePath).readAsStringSync();
      final sajdahCount = '۩'.allMatches(fileContent).length;
      
      expect(sajdahCount, equals(15),
        reason: 'Cleaned file must contain all 15 Sajdah markers (۩)');
    });
    
    test('CRITICAL: Special markers preserved (Saktah ۜ)', () {
      // Check for saktah markers in cleaned file
      final fileContent = File(cleanedFilePath).readAsStringSync();
      final saktahCount = 'ۜ'.allMatches(fileContent).length;
      
      expect(saktahCount, greaterThanOrEqualTo(4),
        reason: 'Cleaned file must contain at least 4 Saktah markers (ۜ)');
    });
    
    test('CRITICAL: No headers or bismillah in cleaned file', () {
      final fileContent = File(cleanedFilePath).readAsStringSync();
      
      // Check that bismillah Unicode (﷽) is NOT in file
      // (It should be rendered separately, not in text)
      final bismillahInText = '﷽'.allMatches(fileContent).length;
      expect(bismillahInText, equals(0),
        reason: 'Cleaned file should NOT contain Bismillah Unicode - rendered separately');
    });
    
    test('CRITICAL: File size is reasonable', () {
      final fileSize = File(cleanedFilePath).lengthSync();
      final fileSizeKB = fileSize / 1024;
      
      // Should be ~1200-1400 KB based on previous analysis
      expect(fileSizeKB, greaterThan(1000),
        reason: 'File too small - likely missing data');
      expect(fileSizeKB, lessThan(2000),
        reason: 'File too large - may contain extra data');
    });
    
    test('CRITICAL: Total line count is reasonable', () {
      // Should be ~4900-5000 lines (604 pages × ~8 ayah lines average)
      final totalLines = cleanedPages.values.fold<int>(
        0, (sum, pageLines) => sum + pageLines.length
      );
      
      expect(totalLines, greaterThan(4500),
        reason: 'Too few lines - data may be missing');
      expect(totalLines, lessThan(5500),
        reason: 'Too many lines - may contain duplicate data');
    });
  });
}
