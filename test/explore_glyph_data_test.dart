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

  test('Explore Glyph Data for Surah Names and Bismillah', () async {
    print('\n' + '='*70);
    print('EXPLORING GLYPH DATA FOR HEADERS');
    print('='*70);
    
    // Get layout for Page 604
    final layout = await MushafLayoutService.getPageLayout(604);
    
    // Open glyph database
    final glyphDb = await openDatabase(
      'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db',
      readOnly: true,
    );
    
    // 1. Check database tables
    print('\nSTEP 1: Database Tables');
    print('-' * 50);
    final tables = await glyphDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (final table in tables) {
      print('  • ${table['name']}');
    }
    
    // 2. Check glyphs table schema
    print('\nSTEP 2: Glyphs Table Schema');
    print('-' * 50);
    final columns = await glyphDb.rawQuery("PRAGMA table_info(glyphs)");
    for (final col in columns) {
      print('  ${col['name']}: ${col['type']}');
    }
    
    // 3. Check Line 1 (Surah Name)
    print('\nSTEP 3: Line 1 Glyphs (Surah Name - Al-Ikhlas)');
    print('-' * 50);
    final line1Glyphs = await glyphDb.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 1
      ORDER BY position
      LIMIT 5
    ''');
    
    print('Found ${line1Glyphs.length} glyphs on Line 1');
    if (line1Glyphs.isNotEmpty) {
      print('\nFirst glyph data:');
      line1Glyphs.first.forEach((key, value) {
        print('  $key: $value');
      });
    }
    
    // 4. Check Line 2 (Bismillah)
    print('\nSTEP 4: Line 2 Glyphs (Bismillah)');
    print('-' * 50);
    final line2Glyphs = await glyphDb.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 2
      ORDER BY position
      LIMIT 5
    ''');
    
    print('Found ${line2Glyphs.length} glyphs on Line 2');
    if (line2Glyphs.isNotEmpty) {
      print('\nFirst glyph data:');
      line2Glyphs.first.forEach((key, value) {
        print('  $key: $value');
      });
    }
    
    // 5. Count glyphs per line
    print('\nSTEP 5: Glyph Count per Line (Page 604)');
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
      print('  Line $lineNum (${lineData.lineType}): $count glyphs');
    }
    
    // 6. Check if glyph_id can be used with QCF font
    print('\nSTEP 6: Sample Glyph IDs');
    print('-' * 50);
    final sampleGlyphs = await glyphDb.rawQuery('''
      SELECT line_number, position, glyph_id, char_type
      FROM glyphs
      WHERE page_number = 604
      ORDER BY line_number, position
      LIMIT 20
    ''');
    
    for (final glyph in sampleGlyphs) {
      print('  Line ${glyph['line_number']}, Pos ${glyph['position']}: '
            'ID=${glyph['glyph_id']}, Type=${glyph['char_type']}');
    }
    
    await glyphDb.close();
    
    print('\n' + '='*70);
    print('EXPLORATION COMPLETE');
    print('='*70);
  });
}
