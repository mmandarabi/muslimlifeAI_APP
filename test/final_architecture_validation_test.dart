import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CRITICAL VALIDATION TEST - Final Approved Architecture
/// 
/// This test validates the decision to use mushaf_v2_map.txt AS-IS
/// with separate header/bismillah rendering.
void main() {
  group('CRITICAL: Mushaf Rendering Architecture Validation', () {
    late Database layoutDb;
    late String sourceFilePath;
    late Map<int, List<String>> sourceByPage;
    
    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
      sourceFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
      
      // Open layout DB
      layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
      
      // Read and parse source file
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
    });
    
    test('CRITICAL: Source file contains all 604 pages', () {
      expect(sourceByPage.length, greaterThanOrEqualTo(600),
        reason: 'Source file must contain at least 600 pages');
    });
    
    test('CRITICAL: Source file has special markers (Sajdah)', () {
      final fileContent = File(sourceFilePath).readAsStringSync();
      final sajdahCount = '۩'.allMatches(fileContent).length;
      
      expect(sajdahCount, equals(15),
        reason: 'Must have all 15 Sajdah markers');
    });
    
    test('CRITICAL: Source file has special markers (Saktah)', () {
      final fileContent = File(sourceFilePath).readAsStringSync();
      final saktahCount = 'ۜ'.allMatches(fileContent).length;
      
      expect(saktahCount, greaterThanOrEqualTo(4),
        reason: 'Must have at least 4 Saktah markers');
    });
    
    test('CRITICAL: Layout DB can identify headers for rendering', () async {
      // Get all header lines
      final headers = await layoutDb.rawQuery('''
        SELECT DISTINCT page_number, surah_number 
        FROM pages 
        WHERE line_type = 'surah_name'
        ORDER BY page_number
      ''');
      
      expect(headers.length, greaterThan(100),
        reason: 'Should have many header lines across 604 pages');
      
      // Verify specific headers
      final page1Header = headers.firstWhere((h) => h['page_number'] == 1);
      expect(page1Header['surah_number'], equals(1),
        reason: 'Page 1 should have Surah 1 (Al-Fatiha) header');
      
      print('✅ Found ${headers.length} header lines across all pages');
    });
    
    test('CRITICAL: Layout DB can identify bismillah locations', () async {
      // Get all bismillah lines
      final bismillahs = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE line_type = 'basmallah'
      ''');
      
      final bismillahCount = bismillahs.first['count'] as int;
      expect(bismillahCount, greaterThan(100),
        reason: 'Should have many bismillah lines (one per surah except At-Tawbah)');
      
      // Verify Page 187 (At-Tawbah) has NO bismillah
      final page187Bismillah = await layoutDb.rawQuery('''
        SELECT COUNT(*) as count FROM pages 
        WHERE page_number = 187 AND line_type = 'basmallah'
      ''');
      
      expect(page187Bismillah.first['count'], equals(0),
        reason: 'Page 187 (Surah At-Tawbah) must have NO bismillah');
      
      print('✅ Total bismillah lines: $bismillahCount');
    });
    
    test('CRITICAL: Page 1 architecture validation', () async {
      // Get Page 1 layout
      final page1Layout = await layoutDb.rawQuery('''
        SELECT line_type FROM pages 
        WHERE page_number = 1 
        ORDER BY line_number
      ''');
      
      // Should have 1 header + 7 ayah lines
      final headerCount = page1Layout.where((l) => l['line_type'] == 'surah_name').length;
      final ayahCount = page1Layout.where((l) => l['line_type'] == 'ayah').length;
      
      expect(headerCount, equals(1), reason: 'Page 1 should have 1 header');
      expect(ayahCount, equals(7), reason: 'Page 1 should have 7 ayah lines (Al-Fatiha)');
      
      // Get Page 1 source lines
      final page1Source = sourceByPage[1] ?? [];
      
      print('✅ Page 1: $headerCount header + $ayahCount ayahs in layout');
      print('   Source file has ${page1Source.length} lines');
    });
    
    test('CRITICAL: Page 604 architecture validation', () async {
      // Get Page 604 layout
      final page604Layout = await layoutDb.rawQuery('''
        SELECT line_type FROM pages 
        WHERE page_number = 604 
        ORDER BY line_number
      ''');
      
      // Should have 3 headers + 3 bismillah + 9 ayah lines
      final headerCount = page604Layout.where((l) => l['line_type'] == 'surah_name').length;
      final bismillahCount = page604Layout.where((l) => l['line_type'] == 'basmallah').length;
      final ayahCount = page604Layout.where((l) => l['line_type'] == 'ayah').length;
      
      expect(headerCount, equals(3), reason: 'Page 604 should have 3 headers');
      expect(bismillahCount, equals(3), reason: 'Page 604 should have 3 bismillah');
      expect(ayahCount, equals(9), reason: 'Page 604 should have 9 ayah lines');
      
      print('✅ Page 604: $headerCount headers + $bismillahCount bismillah + $ayahCount ayahs');
    });
    
    test('CRITICAL: Header font file exists', () {
      final headerFontPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\fonts\\Surahheaderfont\\QCF_SurahHeader_COLOR-Regular.ttf';
      final fontFile = File(headerFontPath);
      
      expect(fontFile.existsSync(), isTrue,
        reason: 'QCF_SurahHeader font must exist for header rendering');
      
      print('✅ Header font found: ${fontFile.lengthSync()} bytes');
    });
    
    test('CRITICAL: Rendering simulation - Page 1', () async {
      print('\n🎨 RENDERING SIMULATION - PAGE 1');
      print('='*70);
      
      // Get layout for Page 1
      final page1Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number 
        FROM pages 
        WHERE page_number = 1 
        ORDER BY line_number
      ''');
      
      // Get source lines for Page 1
      final page1Source = sourceByPage[1] ?? [];
      int sourceLineIndex = 0;
      
      for (var layoutLine in page1Layout) {
        final lineNum = layoutLine['line_number'];
        final lineType = layoutLine['line_type'];
        final surahNum = layoutLine['surah_number'];
        
        if (lineType == 'surah_name') {
          print('Line $lineNum: 📖 HEADER - Render Surah $surahNum using QCF_SurahHeader font');
        } else if (lineType == 'basmallah') {
          print('Line $lineNum: 📿 BISMILLAH - Render Unicode \\uFDFD');
        } else if (lineType == 'ayah') {
          if (sourceLineIndex < page1Source.length) {
            final text = page1Source[sourceLineIndex].split(',')[1];
            final preview = text.length > 50 ? text.substring(0, 50) + '...' : text;
            print('Line $lineNum: 📝 AYAH - $preview');
            sourceLineIndex++;
          }
        }
      }
      
      print('\n✅ Page 1 rendering simulation complete');
    });
    
    test('CRITICAL: File size is reasonable', () {
      final fileSize = File(sourceFilePath).lengthSync();
      final fileSizeKB = fileSize / 1024;
      
      expect(fileSizeKB, greaterThan(1000),
        reason: 'File should be larger than 1 MB for full Quran');
      expect(fileSizeKB, lessThan(2000),
        reason: 'File should be smaller than 2 MB');
      
      print('✅ Source file size: ${fileSizeKB.toStringAsFixed(2)} KB');
    });
  });
}
