import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/services/mushaf_text_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  test('Page 1 - Text File vs Layout DB Analysis', () async {
    // Get text from text file
    final textService = MushafTextService();
    await textService.initialize();
    final textLines = await textService.getPageLines(1);
    
    // Get layout from database
    final db = await databaseFactoryFfi.openDatabase(
      'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db',
      options: OpenDatabaseOptions(readOnly: true)
    );
    
    final layoutRows = await db.query('pages', where: 'page_number = ?', whereArgs: [1], orderBy: 'line_number ASC');
    
    print('\n=== PAGE 1 DETAILED ANALYSIS ===');
    print('\n📄 TEXT FILE CONTENT:');
    print('Total lines: ${textLines.length}');
    for (int i = 0; i < textLines.length; i++) {
      final preview = textLines[i].length > 60 ? '${textLines[i].substring(0, 60)}...' : textLines[i];
      print('  Text[$i]: $preview');
    }
    
    print('\n📊 LAYOUT DB STRUCTURE:');
    print('Total lines: ${layoutRows.length}');
    
    int ayahLineIndex = 0;
    for (var row in layoutRows) {
      final lineNum = row['line_number'];
      final lineType = row['line_type'];
      
      if (lineType == 'ayah') {
        final textIndex = ayahLineIndex < textLines.length ? ayahLineIndex : -1;
        final preview = textIndex >= 0 
            ? (textLines[textIndex].length > 40 ? '${textLines[textIndex].substring(0, 40)}...' : textLines[textIndex])
            : 'NO TEXT';
        print('  Line $lineNum ($lineType): Maps to Text[$textIndex] = $preview');
        ayahLineIndex++;
      } else {
        print('  Line $lineNum ($lineType): HEADER');
      }
    }
    
    print('\n❓ THE PROBLEM:');
    print('  Text file has ${textLines.length} lines (one per verse)');
    print('  Layout DB has ${layoutRows.where((r) => r['line_type'] == 'ayah').length} ayah lines');
    print('  Current mapping: 1:1 (Text[0]→Line2, Text[1]→Line3, etc.)');
    print('  ');
    print('  But Line 4 should show BOTH verse 3 AND 4 combined!');
    print('  This means the text file might already have them combined,');
    print('  OR we need to merge text lines when rendering.');
    print('================================\n');
    
    await db.close();
  });
}
