import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  group('Layout Database Investigation', () {
    late Database db;

    setUpAll(() async {
      final dbPath = 'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db';
      db = await databaseFactoryFfi.openDatabase(dbPath, options: OpenDatabaseOptions(readOnly: true));
    });

    tearDownAll(() async {
      await db.close();
    });

    test('Page 187 - Layout DB Structure', () async {
      final List<Map<String, dynamic>> rows = await db.query(
        'pages',
        where: 'page_number = ?',
        whereArgs: [187],
        orderBy: 'line_number ASC',
      );

      print('\n=== PAGE 187 LAYOUT DB STRUCTURE ===');
      print('Total lines in DB: ${rows.length}');
      print('');

      int headerCount = 0;
      int bismillahCount = 0;
      int ayahCount = 0;

      for (var row in rows) {
        final lineNum = row['line_number'];
        final lineType = row['line_type'];
        final surahNum = row['surah_number'];
        
        print('Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');

        if (lineType == 'surah_name') headerCount++;
        if (lineType == 'basmallah') bismillahCount++;
        if (lineType == 'ayah') ayahCount++;
      }

      print('');
      print('Summary:');
      print('  Headers: $headerCount');
      print('  Bismillah: $bismillahCount');
      print('  Ayah lines: $ayahCount');
      print('  Expected total: ${headerCount + bismillahCount + ayahCount}');
      print('=====================================\n');

      expect(rows.length, equals(15), reason: 'Page 187 should have 15 lines in layout DB');
    });

    test('Page 604 - Layout DB Structure', () async {
      final List<Map<String, dynamic>> rows = await db.query(
        'pages',
        where: 'page_number = ?',
        whereArgs: [604],
        orderBy: 'line_number ASC',
      );

      print('\n=== PAGE 604 LAYOUT DB STRUCTURE ===');
      print('Total lines in DB: ${rows.length}');
      print('');

      int headerCount = 0;
      int bismillahCount = 0;
      int ayahCount = 0;

      for (var row in rows) {
        final lineNum = row['line_number'];
        final lineType = row['line_type'];
        final surahNum = row['surah_number'];
        
        print('Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');

        if (lineType == 'surah_name') headerCount++;
        if (lineType == 'basmallah') bismillahCount++;
        if (lineType == 'ayah') ayahCount++;
      }

      print('');
      print('Summary:');
      print('  Headers: $headerCount');
      print('  Bismillah: $bismillahCount');
      print('  Ayah lines: $ayahCount');
      print('  Expected total: ${headerCount + bismillahCount + ayahCount}');
      print('=====================================\n');

      expect(rows.length, equals(15), reason: 'Page 604 should have 15 lines in layout DB');
    });

    test('Page 1 - Layout DB Structure', () async {
      final List<Map<String, dynamic>> rows = await db.query(
        'pages',
        where: 'page_number = ?',
        whereArgs: [1],
        orderBy: 'line_number ASC',
      );

      print('\n=== PAGE 1 LAYOUT DB STRUCTURE ===');
      print('Total lines in DB: ${rows.length}');
      print('');

      int headerCount = 0;
      int bismillahCount = 0;
      int ayahCount = 0;

      for (var row in rows) {
        final lineNum = row['line_number'];
        final lineType = row['line_type'];
        final surahNum = row['surah_number'];
        
        print('Line $lineNum: $lineType ${surahNum != null ? "(Surah $surahNum)" : ""}');

        if (lineType == 'surah_name') headerCount++;
        if (lineType == 'basmallah') bismillahCount++;
        if (lineType == 'ayah') ayahCount++;
      }

      print('');
      print('Summary:');
      print('  Headers: $headerCount');
      print('  Bismillah: $bismillahCount');
      print('  Ayah lines: $ayahCount');
      print('  Expected total: ${headerCount + bismillahCount + ayahCount}');
      print('===================================\n');
    });

    test('Conclusion - Text File vs Layout DB Mapping', () async {
      print('\n=== CRITICAL ANALYSIS ===');
      print('');
      print('Source File (mushaf_v2_map.txt):');
      print('  Page 1:   7 lines');
      print('  Page 187: 6 lines');
      print('  Page 604: 8 lines');
      print('');
      print('Layout DB (qpc-v2-15-lines.db):');
      print('  Each page: Up to 15 lines (headers + bismillah + ayahs)');
      print('');
      print('CONCLUSION:');
      print('  The text file contains ONLY ayah text lines.');
      print('  Headers and Bismillah are NOT in the text file.');
      print('  They must be rendered programmatically using layout DB.');
      print('');
      print('RENDERING STRATEGY:');
      print('  1. Query layout DB for page structure');
      print('  2. For each line in layout:');
      print('     - If "surah_name": Render header using QCF font');
      print('     - If "basmallah": Render Bismillah Unicode');
      print('     - If "ayah": Use text from mushaf_v2_map.txt');
      print('  3. Text file lines map ONLY to "ayah" type lines');
      print('=========================\n');
    });
  });
}
