import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Direct V2 database verification', () async {
    // Initialize FFI
    sqfliteFfiInit();
    
    // Open database directly
    final db = await databaseFactoryFfi.openDatabase(
      'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db',
      options: OpenDatabaseOptions(readOnly: true)
    );

    try {
      // Test Page 1
      final page1 = await db.query('pages', where: 'page_number = ?', whereArgs: [1]);
      print('\n=== PAGE 1 RESULTS ===');
      print('Total lines: ${page1.length}');
      
      int ayahLines1 = 0;
      for (var row in page1) {
        if (row['line_type'] == 'ayah') ayahLines1++;
      }
      print('Ayah lines: $ayahLines1');
      
      // Test Page 187
      final page187 = await db.query('pages', where: 'page_number = ?', whereArgs: [187]);
      print('\n=== PAGE 187 RESULTS ===');
      print('Total lines: ${page187.length}');
      
      int headers187 = 0, bismillah187 = 0, ayahLines187 = 0;
      for (var row in page187) {
        if (row['line_type'] == 'surah_name') headers187++;
        if (row['line_type'] == 'basmallah') bismillah187++;
        if (row['line_type'] == 'ayah') ayahLines187++;
      }
      print('Headers: $headers187');
      print('Bismillah: $bismillah187 (MUST be 0 for Surah 9)');
     print('Ayah lines: $ayahLines187');
      
      // Test Page 604
      final page604 = await db.query('pages', where: 'page_number = ?', whereArgs: [604]);
      print('\n=== PAGE 604 RESULTS ===');
      print('Total lines: ${page604.length}');
      
      int headers604 = 0, bismillah604 = 0, ayahLines604 = 0;
      for (var row in page604) {
        if (row['line_type'] == 'surah_name') headers604++;
        if (row['line_type'] == 'basmallah') bismillah604++;
        if (row['line_type'] == 'ayah') ayahLines604++;
      }
      print('Headers: $headers604');
      print('Bismillah: $bismillah604');
      print('Ayah lines: $ayahLines604');
      print('=====================\n');
      
      // Assertions
      expect(page1.length, equals(8), reason: 'Page 1 should have 8 lines');
      expect(ayahLines1, equals(7), reason: 'Page 1 should have 7 ayah lines');
      
      expect(page187.length, equals(15), reason: 'Page 187 should have 15 lines');
      expect(headers187, equals(1), reason: 'Page 187 should have 1 header');
      expect(bismillah187, equals(0), reason: 'Page 187 (Surah 9) should have NO Bismillah');
      expect(ayahLines187, equals(14), reason: 'Page 187 should have 14 ayah lines');
      
      expect(page604.length, equals(15), reason: 'Page 604 should have 15 lines');
      expect(headers604, equals(3), reason: 'Page 604 should have 3 headers');
      expect(bismillah604, equals(3), reason: 'Page 604 should have 3 Bismillah');
      expect(ayahLines604, equals(9), reason: 'Page 604 should have 9 ayah lines');
      
      print('✅ ALL VALIDATIONS PASSED!');
      
    } finally {
      await db.close();
    }
  });
}
