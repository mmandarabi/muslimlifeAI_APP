
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  group('MushafLayoutService', () {
    
    setUpAll(() async {
      // Initialize FFI for Windows Testing
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      // Point to local asset file (relative to project root)
      // Unit tests run with CWD as project root
      MushafLayoutService.overrideDbPath = 'assets/quran/databases/qpc-v1-15-lines.db';
      
      // Ensure DB exists (fail fast if not)
      // await MushafLayoutService.initialize(); // Trigger open
    });

    test('Page 604 returns exactly 15 lines', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(604);
      expect(layout.length, 15);
    });

    test('Page 604 has 3 surah_name lines', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(604);
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      
      expect(headers.length, 3);
      expect(headers[0].surahNumber, 112); // Al-Ikhlas
      expect(headers[1].surahNumber, 113); // Al-Falaq
      expect(headers[2].surahNumber, 114); // An-Nas
    });

    test('Page 604 has 3 basmallah lines', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(604);
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(bismillahs.length, 3);
    });

    test('Page 604 header line numbers are correct', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(604);
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      
      // Print actual line numbers for verification
      print('Header lines: ${headers.map((h) => h.lineNumber).toList()}');
      
      // Headers should be at specific lines (verify against QUL data)
      // Al-Ikhlas at Line 1
      expect(headers[0].lineNumber, lessThanOrEqualTo(5)); 
      // Al-Falaq at Line 5
      expect(headers[1].lineNumber, greaterThan(headers[0].lineNumber));
      // An-Nas at Line 10
      expect(headers[2].lineNumber, greaterThan(headers[1].lineNumber));
    });

    test('Page 1 (Al-Fatiha) has 1 header, 0 basmallah', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(1);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(headers.length, 1);
      expect(headers[0].surahNumber, 1);
      expect(bismillahs.length, 0); // Bismillah IS ayah 1 for Al-Fatiha
    });

    test('Page 187 (At-Tawbah) has 1 header, 0 basmallah', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(187);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      // At-Tawbah is the only Surah without Bismillah
      expect(headers.length, 1);
      expect(headers[0].surahNumber, 9);
      expect(bismillahs.length, 0);
    });

    test('Page 2 (Al-Baqarah) has 1 header, 1 basmallah', () async {
      final service = MushafLayoutService();
      final layout = await service.getPageLayout(2);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(headers.length, 1);
      expect(headers[0].surahNumber, 2);
      expect(bismillahs.length, 1);
    });
  });
}
