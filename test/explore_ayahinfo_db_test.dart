import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Explore ayahinfo.db for Surah Names and Bismillah Glyphs', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final db = await openDatabase(
      'D:\\solutions\\MuslimLifeAI_demo\\assets\\quran\\databases\\ayahinfo.db',
      readOnly: true,
    );
    
    // 1. Check all tables
    print('\n' + '='*70);
    print('STEP 1: Database Tables');
    print('='*70);
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (final table in tables) {
      print('  • ${table['name']}');
    }
    
    // 2. Check schema of each table
    print('\n' + '='*70);
    print('STEP 2: Table Schemas');
    print('='*70);
    for (final table in tables) {
      final tableName = table['name'] as String;
      print('\nTable: $tableName');
      final columns = await db.rawQuery("PRAGMA table_info($tableName)");
      for (final col in columns) {
        print('  - ${col['name']}: ${col['type']}');
      }
    }
    
    // 3. Check glyphs table for Page 604
    print('\n' + '='*70);
    print('STEP 3: Glyphs for Page 604');
    print('='*70);
    final glyphs604 = await db.rawQuery('''
      SELECT line_number, position, glyph_id, glyph_type
      FROM glyphs
      WHERE page_number = 604
      ORDER BY line_number, position
      LIMIT 50
    ''');
    
    print('\nFirst 50 glyphs:');
    for (final glyph in glyphs604) {
      print('  Line ${glyph['line_number']}, Pos ${glyph['position']}: '
            'ID=${glyph['glyph_id']}, Type=${glyph['glyph_type']}');
    }
    
    // 4. Check for Surah name glyphs (line_number 1 is usually Surah name)
    print('\n' + '='*70);
    print('STEP 4: Line 1 Glyphs (Surah Name)');
    print('='*70);
    final line1Glyphs = await db.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 1
      ORDER BY position
    ''');
    
    print('\nLine 1 has ${line1Glyphs.length} glyphs');
    if (line1Glyphs.isNotEmpty) {
      print('Sample glyph data:');
      final sample = line1Glyphs.first;
      sample.forEach((key, value) {
        print('  $key: $value');
      });
    }
    
    // 5. Check for Bismillah glyphs (line_number 2 is usually Bismillah)
    print('\n' + '='*70);
    print('STEP 5: Line 2 Glyphs (Bismillah)');
    print('='*70);
    final line2Glyphs = await db.rawQuery('''
      SELECT *
      FROM glyphs
      WHERE page_number = 604 AND line_number = 2
      ORDER BY position
    ''');
    
    print('\nLine 2 has ${line2Glyphs.length} glyphs');
    if (line2Glyphs.isNotEmpty) {
      print('Sample glyph data:');
      final sample = line2Glyphs.first;
      sample.forEach((key, value) {
        print('  $key: $value');
      });
    }
    
    // 6. Check if there's a separate table for decorative elements
    print('\n' + '='*70);
    print('STEP 6: Looking for Decorative/Header Elements');
    print('='*70);
    
    // Check if there's a table for page decorations
    final decorTables = tables.where((t) => 
      (t['name'] as String).toLowerCase().contains('decor') ||
      (t['name'] as String).toLowerCase().contains('header') ||
      (t['name'] as String).toLowerCase().contains('ornament') ||
      (t['name'] as String).toLowerCase().contains('image')
    ).toList();
    
    if (decorTables.isNotEmpty) {
      print('Found potential decoration tables:');
      for (final table in decorTables) {
        print('  • ${table['name']}');
      }
    } else {
      print('No decoration/header tables found');
    }
    
    // 7. Count glyphs per line for Page 604
    print('\n' + '='*70);
    print('STEP 7: Glyph Count per Line (Page 604)');
    print('='*70);
    final glyphCounts = await db.rawQuery('''
      SELECT line_number, COUNT(*) as glyph_count
      FROM glyphs
      WHERE page_number = 604
      GROUP BY line_number
      ORDER BY line_number
    ''');
    
    for (final row in glyphCounts) {
      print('  Line ${row['line_number']}: ${row['glyph_count']} glyphs');
    }
    
    await db.close();
    
    print('\n' + '='*70);
    print('EXPLORATION COMPLETE');
    print('='*70);
  });
}
