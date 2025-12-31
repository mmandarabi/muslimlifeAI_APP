import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('Verify Page 2 structure in layout DB and source file', () async {
    print('='*70);
    print('PAGE 2 DATA VERIFICATION');
    print('='*70);
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\qpc-v1-15-lines.db';
    final sourceFile = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\mushaf_v2_map.txt';
    
    // Open layout database
    final layoutDb = await databaseFactory.openDatabase(layoutDbPath, options: OpenDatabaseOptions(readOnly: true));
    
    // Query Page 2 layout
    print('\n📐 LAYOUT DATABASE - Page 2 Structure:');
    final layoutResult = await layoutDb.rawQuery('''
      SELECT line_number, line_type, surah_number
      FROM pages
      WHERE page_number = 2
      ORDER BY line_number
    ''', []);
    
    print('   Total lines in layout: ${layoutResult.length}');
    print('\n   Detailed structure:');
    for (var row in layoutResult) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      final surahNum = row['surah_number'];
      print('   Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');
    }
    
    // Count by type
    final ayahCount = layoutResult.where((r) => r['line_type'] == 'ayah').length;
    final headerCount = layoutResult.where((r) => r['line_type'] == 'surah_name').length;
    final bismillahCount = layoutResult.where((r) => r['line_type'] == 'basmallah').length;
    
    print('\n   Summary:');
    print('   - Ayah lines: $ayahCount');
    print('   - Header lines: $headerCount');
    print('   - Bismillah lines: $bismillahCount');
    
    // Read source file Page 2 lines
    print('\n📄 SOURCE FILE - Page 2 Content:');
    final rawText = await File(sourceFile).readAsString();
    final allLines = rawText.replaceAll('\r\n', '\n').split('\n');
    
    final page2Lines = <String>[];
    for (final line in allLines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      
      if (trimmed.startsWith('2,')) {
        page2Lines.add(trimmed);
      }
    }
    
    print('   Total lines in source: ${page2Lines.length}');
    print('\n   Content:');
    for (int i = 0; i < page2Lines.length; i++) {
      final line = page2Lines[i];
      final content = line.substring(2).trim(); // Remove "2," prefix
      final tokenCount = content.split(' ').where((t) => t.isNotEmpty).length;
      
      // Show first 80 characters
      final preview = content.length > 80 ? content.substring(0, 80) + '...' : content;
      print('   Source Line ${i+1}: $tokenCount tokens');
      print('   Content: $preview');
      print('');
    }
    
    // Comparison
    print('='*70);
    print('COMPARISON:');
    print('='*70);
    print('Layout DB says: ${layoutResult.length} lines ($headerCount header + $bismillahCount bismillah + $ayahCount ayah)');
    print('Source file has: ${page2Lines.length} lines');
    
    if (page2Lines.length == layoutResult.length) {
      print('✅ MATCH - Source has ALL lines (including header/bismillah)');
      print('   → Script should REMOVE $headerCount header + $bismillahCount bismillah');
      print('   → Output should have $ayahCount lines');
    } else if (page2Lines.length == ayahCount) {
      print('✅ MATCH - Source has ONLY ayah lines (header/bismillah already removed)');
      print('   → Script should KEEP all ${page2Lines.length} lines as-is');
    } else {
      print('❌ MISMATCH - Unexpected line count');
    }
    
    await layoutDb.close();
    
  }, timeout: const Timeout(Duration(minutes: 2)));
}
