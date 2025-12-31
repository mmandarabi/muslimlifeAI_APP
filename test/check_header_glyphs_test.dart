import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final dbPath = 'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\qpc-v1-15-lines.db';
    if (File(dbPath).existsSync()) {
      MushafLayoutService.overrideDbPath = dbPath;
    }
  });

  test('Check Glyph Data for Surah Names and Bismillah', () async {
    print('\n' + '='*70);
    print('CHECKING GLYPH DATA FOR HEADERS (Page 604)');
    print('='*70);
    
    // Get layout for Page 604
    final layout = await MushafLayoutService.getPageLayout(604);
    
    // Open glyph database
    final glyphDb = await openDatabase(
      'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db',
      readOnly: true,
    );
    
    // Check Line 1 (Surah Name)
    print('\nSTEP 1: Checking Line 1 (Surah Name - Al-Ikhlas)');
    print('-' * 50);
    
    final line1Glyphs = await glyphDb.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 1
      ORDER BY position
    ''');
    
    if (line1Glyphs.isEmpty) {
      print('❌ NO GLYPH DATA found for Line 1 (Surah Name)');
      print('   The database does NOT contain Surah name glyphs');
    } else {
      print('✅ Found ${line1Glyphs.length} glyphs for Line 1 (Surah Name)');
      print('\nFirst 3 glyphs:');
      for (int i = 0; i < (line1Glyphs.length > 3 ? 3 : line1Glyphs.length); i++) {
        final glyph = line1Glyphs[i];
        print('  Glyph $i: ID=${glyph['glyph_id']}, Type=${glyph['char_type']}, '
              'Pos=${glyph['position']}, MinX=${glyph['min_x']}, MinY=${glyph['min_y']}');
      }
    }
    
    // Check Line 2 (Bismillah)
    print('\nSTEP 2: Checking Line 2 (Bismillah)');
    print('-' * 50);
    
    final line2Glyphs = await glyphDb.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 2
      ORDER BY position
    ''');
    
    if (line2Glyphs.isEmpty) {
      print('❌ NO GLYPH DATA found for Line 2 (Bismillah)');
      print('   The database does NOT contain Bismillah glyphs');
    } else {
      print('✅ Found ${line2Glyphs.length} glyphs for Line 2 (Bismillah)');
      print('\nFirst 3 glyphs:');
      for (int i = 0; i < (line2Glyphs.length > 3 ? 3 : line2Glyphs.length); i++) {
        final glyph = line2Glyphs[i];
        print('  Glyph $i: ID=${glyph['glyph_id']}, Type=${glyph['char_type']}, '
              'Pos=${glyph['position']}, MinX=${glyph['min_x']}, MinY=${glyph['min_y']}');
      }
    }
    
    // Check all lines to see which have glyph data
    print('\nSTEP 3: Glyph Count Summary (All Lines)');
    print('-' * 50);
    
    final glyphCounts = await glyphDb.rawQuery('''
      SELECT line_number, COUNT(*) as glyph_count
      FROM glyphs
      WHERE page_number = 604
      GROUP BY line_number
      ORDER BY line_number
    ''');
    
    for (final row in glyphCounts) {
      final lineNum = row['line_number'] as int;
      final count = row['glyph_count'] as int;
      final lineData = layout.firstWhere((l) => l.lineNumber == lineNum);
      
      if (lineData.lineType == 'surah_name') {
        print('  Line $lineNum (SURAH NAME): $count glyphs ${count > 0 ? "✅" : "❌"}');
      } else if (lineData.lineType == 'basmallah') {
        print('  Line $lineNum (BISMILLAH): $count glyphs ${count > 0 ? "✅" : "❌"}');
      } else {
        print('  Line $lineNum (ayah): $count glyphs');
      }
    }
    
    await glyphDb.close();
    
    print('\n' + '='*70);
    print('SUMMARY');
    print('='*70);
    
    final hasLine1Data = line1Glyphs.isNotEmpty;
    final hasLine2Data = line2Glyphs.isNotEmpty;
    
    if (hasLine1Data && hasLine2Data) {
      print('✅ Database HAS glyph data for both Surah names and Bismillah');
      print('   We can render them using the page-specific QCF font!');
    } else {
      print('❌ Database is MISSING glyph data for headers:');
      if (!hasLine1Data) print('   - Surah Name (Line 1): NO DATA');
      if (!hasLine2Data) print('   - Bismillah (Line 2): NO DATA');
      print('\n   RECOMMENDATION: User needs to provide header calligraphy assets');
    }
    
    print('='*70 + '\n');
  });
}
