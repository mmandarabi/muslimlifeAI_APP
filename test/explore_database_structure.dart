import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  test('Check qpc-v2.db for word-level text', () async {
    final db = await databaseFactoryFfi.openDatabase(
      'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2.db',
      options: OpenDatabaseOptions(readOnly: true)
    );

    // Check tables
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('\n=== QPC-V2.DB TABLES ===');
    for (var table in tables) {
      print('  ${table['name']}');
    }
    
    // Check glyphs table (words)
    print('\n=== WORDS TABLE SCHEMA ===');
    final schema = await db.rawQuery("PRAGMA table_info(words)");
    for (var col in schema) {
      print('  ${col['name']}: ${col['type']}');
    }
    
    // Get words for Page 1, Line 4 (word IDs 8-14 based on verification doc)
    print('\n=== PAGE 1, LINE 4 WORDS (IDs 8-14) ===');
    
    // First check what columns exist
    final sampleRow = await db.query('words', limit: 1);
    if (sampleRow.isNotEmpty) {
      print('Available columns: ${sampleRow[0].keys.join(", ")}');
    }
    
    // Query with correct column names
    final words = await db.rawQuery('''
      SELECT * FROM words 
      WHERE id >= 8 AND id <= 14
      ORDER BY id ASC
    ''');
    
    if (words.isNotEmpty) {
      print('\nFound ${words.length} words:');
      for (var word in words) {
        print('  ${word}');
      }
      
      // Try to combine text if text column exists
      if (words[0].containsKey('text')) {
        final combinedText = words.map((w) => w['text']).join(' ');
        print('\n📝 COMBINED LINE 4 TEXT:');
        print('  $combinedText');
      }
    } else {
      print('No words found in range 8-14');
    }
    
    await db.close();
  });
}
