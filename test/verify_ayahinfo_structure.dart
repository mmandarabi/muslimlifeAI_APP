import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  test('Verify ayahinfo.db structure for Pages 1, 2, 604', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    final layoutDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\qpc-v1-15-lines.db';
    final glyphDbPath = r'D:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db';
    
    final layoutDb = await openDatabase(layoutDbPath, readOnly: true);
    final glyphDb = await openDatabase(glyphDbPath, readOnly: true);
    
    print('='*70);
    print('VERIFYING GLYPH DATABASE STRUCTURE');
    print('='*70);
    
    for (final pageNum in [1, 2, 604]) {
      print('\n📖 Page $pageNum:');
      
      // Get layout from database
      final layout = await layoutDb.rawQuery('''
        SELECT line_number, line_type, surah_number
        FROM pages
        WHERE page_number = ?
        ORDER BY line_number
      ''', [pageNum]);
      
      print('  Layout: ${layout.length} lines');
      
      // Check glyphs for each line
      for (final line in layout) {
        final lineNum = line['line_number'] as int;
        final lineType = line['line_type'] as String;
        
        final glyphs = await glyphDb.rawQuery('''
          SELECT COUNT(*) as count
          FROM glyphs
          WHERE page_number = ? AND line_number = ?
        ''', [pageNum, lineNum]);
        
        final count = glyphs.first['count'] as int;
        
        if (count > 0 || lineType != 'ayah') {
          print('    Line $lineNum ($lineType): $count glyphs');
        }
      }
    }
    
    await layoutDb.close();
    await glyphDb.close();
    
    print('\n' + '='*70);
    print('VERIFICATION COMPLETE');
    print('='*70);
  });
}
