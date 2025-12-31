import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Detailed rendering simulation for Pages 187 and 604
void main() {
  group('Detailed Rendering Simulation - Critical Pages', () {
    late Database layoutDb;
    late Map<int, List<String>> sourceByPage;
    
    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v2-15-lines.db';
      final sourceFilePath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
      
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
    
    test('RENDERING SIMULATION - Page 187 (Surah At-Tawbah)', () async {
      print('\n' + '='*80);
      print('🎨 RENDERING SIMULATION - PAGE 187 (SURAH AT-TAWBAH)');
      print('='*80);
      print('Special: NO Bismillah for this Surah\n');
      
      // Get layout for Page 187
      final page187Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number 
        FROM pages 
        WHERE page_number = 187 
        ORDER BY line_number
      ''');
      
      // Get source lines for Page 187
      final page187Source = sourceByPage[187] ?? [];
      int sourceLineIndex = 0;
      
      int headerCount = 0;
      int bismillahCount = 0;
      int ayahCount = 0;
      
      for (var layoutLine in page187Layout) {
        final lineNum = layoutLine['line_number'];
        final lineType = layoutLine['line_type'];
        final surahNum = layoutLine['surah_number'];
        
        if (lineType == 'surah_name') {
          headerCount++;
          print('Line $lineNum: 📖 HEADER - Render Surah $surahNum (At-Tawbah) using QCF_SurahHeader font');
          print('           Font: QCF_SurahHeader_COLOR-Regular.ttf');
          print('');
        } else if (lineType == 'basmallah') {
          bismillahCount++;
          print('Line $lineNum: 📿 BISMILLAH - Render Unicode \\uFDFD (﷽)');
          print('');
        } else if (lineType == 'ayah') {
          ayahCount++;
          if (sourceLineIndex < page187Source.length) {
            final fullLine = page187Source[sourceLineIndex];
            final text = fullLine.split(',').length > 1 ? fullLine.split(',')[1] : '';
            final preview = text.length > 70 ? text.substring(0, 70) + '...' : text;
            
            print('Line $lineNum: 📝 AYAH ${ayahCount}');
            print('           Text: $preview');
            print('           Font: p187-v2');
            print('');
            
            sourceLineIndex++;
          }
        }
      }
      
      print('-'*80);
      print('SUMMARY:');
      print('  Headers: $headerCount');
      print('  Bismillah: $bismillahCount ✅ (ZERO - correct for At-Tawbah!)');
      print('  Ayah lines: $ayahCount');
      print('  Source lines available: ${page187Source.length}');
      print('='*80);
      
      expect(bismillahCount, equals(0), reason: 'At-Tawbah must have NO bismillah');
      expect(ayahCount, equals(14), reason: 'Page 187 should have 14 ayah lines');
    });
    
    test('RENDERING SIMULATION - Page 604 (Last Page)', () async {
      print('\n' + '='*80);
      print('🎨 RENDERING SIMULATION - PAGE 604 (LAST PAGE OF QURAN)');
      print('='*80);
      print('Contains: Surah 112 (Al-Ikhlas), 113 (Al-Falaq), 114 (An-Nas)\n');
      
      // Get layout for Page 604
      final page604Layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number 
        FROM pages 
        WHERE page_number = 604 
        ORDER BY line_number
      ''');
      
      // Get source lines for Page 604
      final page604Source = sourceByPage[604] ?? [];
      int sourceLineIndex = 0;
      
      int headerCount = 0;
      int bismillahCount = 0;
      int ayahCount = 0;
      int currentSurah = 0;
      
      final surahNames = {
        112: 'Al-Ikhlas (The Sincerity)',
        113: 'Al-Falaq (The Daybreak)',
        114: 'An-Nas (Mankind)',
      };
      
      for (var layoutLine in page604Layout) {
        final lineNum = layoutLine['line_number'];
        final lineType = layoutLine['line_type'];
        final surahNum = layoutLine['surah_number'];
        
        if (lineType == 'surah_name') {
          headerCount++;
          currentSurah = (surahNum as int?) ?? 0;
          print('Line $lineNum: 📖 HEADER - Surah $surahNum: ${surahNames[surahNum]}');
          print('           Font: QCF_SurahHeader_COLOR-Regular.ttf');
          print('');
        } else if (lineType == 'basmallah') {
          bismillahCount++;
          print('Line $lineNum: 📿 BISMILLAH - Unicode \\uFDFD (﷽) for Surah $currentSurah');
          print('');
        } else if (lineType == 'ayah') {
          ayahCount++;
          if (sourceLineIndex < page604Source.length) {
            final fullLine = page604Source[sourceLineIndex];
            final text = fullLine.split(',').length > 1 ? fullLine.split(',')[1] : '';
            final preview = text.length > 70 ? text.substring(0, 70) + '...' : text;
            
            print('Line $lineNum: 📝 AYAH ${ayahCount}');
            print('           Text: $preview');
            print('           Font: p604-v2');
            print('');
            
            sourceLineIndex++;
          }
        }
      }
      
      print('-'*80);
      print('SUMMARY:');
      print('  Headers: $headerCount (3 Surahs)');
      print('  Bismillah: $bismillahCount (one per Surah)');
      print('  Ayah lines: $ayahCount');
      print('  Source lines available: ${page604Source.length}');
      print('  Total lines: ${page604Layout.length}');
      print('='*80);
      
      expect(headerCount, equals(3), reason: 'Page 604 should have 3 surah headers');
      expect(bismillahCount, equals(3), reason: 'Page 604 should have 3 bismillah');
      expect(ayahCount, equals(9), reason: 'Page 604 should have 9 ayah lines');
    });
    
    test('VERIFY: Source file has text for both pages', () {
      final page187Lines = sourceByPage[187] ?? [];
      final page604Lines = sourceByPage[604] ?? [];
      
      expect(page187Lines, isNotEmpty, reason: 'Page 187 must have source text');
      expect(page604Lines, isNotEmpty, reason: 'Page 604 must have source text');
      
      print('\n✅ Page 187: ${page187Lines.length} source lines available');
      print('✅ Page 604: ${page604Lines.length} source lines available');
    });
  });
}
