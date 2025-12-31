import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/services/mushaf_word_reconstruction_service.dart';
import '../lib/services/mushaf_layout_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Phase 5: Critical Page Testing', () {
    setUpAll(() async {
      MushafLayoutService.overrideDbPath = 'd:/solutions/MuslimLifeAI_demo/assets/quran/databases/qpc-v2-15-lines.db';
      await MushafLayoutService.initialize();
      await MushafWordReconstructionService.initialize();
    });

    test('Page 1 - 8-line ornate layout with verse combination', () async {
      print('\n═══════════════════════════════════');
      print('📖 PAGE 1 (AL-FATIHA) TEST');
      print('═══════════════════════════════════');
      
      // Get layout structure
      final layout = await MushafLayoutService.getPageLayout(1);
      final headers = await MushafLayoutService.getSurahHeaders(1);
      final bismillah = await MushafLayoutService.getBismillahLines(1);
      final ayahLines = await MushafLayoutService.getAyahLines(1);
      
      print('\n📊 LAYOUT STRUCTURE:');
      print('  Total lines: ${layout.length}');
      print('  Headers: ${headers.length}');
      print('  Bismillah: ${bismillah.length}');
      print('  Ayah lines: ${ayahLines.length}');
      
      expect(layout.length, equals(8), reason: 'Page 1 should have 8 total lines');
      expect(headers.length, equals(1), reason: 'Page 1 should have 1 header');
      expect(bismillah.length, equals(0), reason: 'Page 1 has NO separate Bismillah line');
      expect(ayahLines.length, equals(7), reason: 'Page 1 should have 7 ayah lines');
      
      // Get reconstructed text
      final textLines = await MushafWordReconstructionService.getReconstructedPageLines(1);
      
      print('\n📝 RECONSTRUCTED TEXT:');
      print('  Text lines: ${textLines.length}');
      
      for (int i = 0; i < textLines.length; i++) {
        final words = textLines[i].split(' ').where((w) => w.isNotEmpty).toList();
        print('  Line ${i + 1}: ${words.length} words');
      }
      
      // Critical: Line 3 (ayah line 3 = layout line 4) should have 7 words (verses 1:3+1:4)
      if (textLines.length >= 3) {
        final line3Words = textLines[2].split(' ').where((w) => w.isNotEmpty).toList();
        print('\n✨ CRITICAL TEST - Line 4 (3rd ayah line):');
        print('  Word count: ${line3Words.length}');
        print('  Expected: 7 (verse 1:3 = 3 words + verse 1:4 = 4 words)');
        print('  Status: ${line3Words.length == 7 ? "✅ PASS" : "❌ FAIL"}');
        
        expect(line3Words.length, equals(7), 
          reason: 'Page 1 Line 4 must have 7 words (verses 1:3+1:4 combined)');
      }
      
      print('═══════════════════════════════════\n');
    });

    test('Page 187 - NO Bismillah (Surah 9)', () async {
      print('\n═══════════════════════════════════');
      print('📖 PAGE 187 (AT-TAWBAH) TEST');
      print('═══════════════════════════════════');
      
      final layout = await MushafLayoutService.getPageLayout(187);
      final headers = await MushafLayoutService.getSurahHeaders(187);
      final bismillah = await MushafLayoutService.getBismillahLines(187);
      final ayahLines = await MushafLayoutService.getAyahLines(187);
      
      print('\n📊 LAYOUT STRUCTURE:');
      print('  Total lines: ${layout.length}');
      print('  Headers: ${headers.length}');
      print('  Bismillah: ${bismillah.length} ⚠️ MUST BE 0');
      print('  Ayah lines: ${ayahLines.length}');
      
      expect(layout.length, equals(15), reason: 'Page 187 should have 15 total lines');
      expect(headers.length, equals(1), reason: 'Page 187 should have 1 header');
      expect(bismillah.length, equals(0), reason: 'Surah 9 (At-Tawbah) has NO Bismillah!');
      expect(ayahLines.length, equals(14), reason: 'Page 187 should have 14 ayah lines');
      
      final textLines = await MushafWordReconstructionService.getReconstructedPageLines(187);
      
      print('\n📝 RECONSTRUCTED TEXT:');
      print('  Text lines: ${textLines.length}');
      print('  Status: ${bismillah.length == 0 ? "✅ PASS - NO Bismillah" : "❌ FAIL - Bismillah found"}');
      
      print('═══════════════════════════════════\n');
    });

    test('Page 604 - 3 Surahs with correct distribution', () async {
      print('\n═══════════════════════════════════');
      print('📖 PAGE 604 (LAST PAGE) TEST');
      print('═══════════════════════════════════');
      
      final layout = await MushafLayoutService.getPageLayout(604);
      final headers = await MushafLayoutService.getSurahHeaders(604);
      final bismillah = await MushafLayoutService.getBismillahLines(604);
      final ayahLines = await MushafLayoutService.getAyahLines(604);
      
      print('\n📊 LAYOUT STRUCTURE:');
      print('  Total lines: ${layout.length}');
      print('  Headers: ${headers.length} (Al-Ikhlas, Al-Falaq, An-Nas)');
      print('  Bismillah: ${bismillah.length}');
      print('  Ayah lines: ${ayahLines.length}');
      print('  Formula: ${headers.length} + ${bismillah.length} + ${ayahLines.length} = ${headers.length + bismillah.length + ayahLines.length}');
      
      expect(layout.length, equals(15), reason: 'Page 604 should have 15 total lines');
      expect(headers.length, equals(3), reason: 'Page 604 has 3 surahs');
      expect(bismillah.length, equals(3), reason: 'Each surah has Bismillah');
      expect(ayahLines.length, equals(9), reason: 'Al-Ikhlas=2, Al-Falaq=3, An-Nas=4 = 9 ayah lines');
      
      final textLines = await MushafWordReconstructionService.getReconstructedPageLines(604);
      
      print('\n📝 RECONSTRUCTED TEXT:');
      print('  Text lines: ${textLines.length}');
      expect(textLines.length, equals(9), reason: 'Should have 9 ayah text lines');
      
      print('\n  Ayah line breakdown:');
      for (int i = 0; i < textLines.length; i++) {
        final words = textLines[i].split(' ').where((w) => w.isNotEmpty).toList();
        String surah = i < 2 ? 'Al-Ikhlas' : (i < 5 ? 'Al-Falaq' : 'An-Nas');
        print('    Line ${i + 1} ($surah): ${words.length} words');
      }
      
      print('  Status: ${textLines.length == 9 ? "✅ PASS" : "❌ FAIL"}');
      print('═══════════════════════════════════\n');
    });

    test('Full integrity check - All 604 pages', () async {
      print('\n═══════════════════════════════════');
      print('🔍 FULL 604-PAGE INTEGRITY AUDIT');
      print('═══════════════════════════════════\n');
      
      int totalErrors = 0;
      List<int> pagesWithErrors = [];
      
      for (int page = 1; page <= 604; page++) {
        try {
          final textLines = await MushafWordReconstructionService.getReconstructedPageLines(page);
          
          if (textLines.isEmpty) {
            totalErrors++;
            pagesWithErrors.add(page);
          }
          
          // Progress indicator
          if (page % 100 == 0) {
            print('  ✓ Scanned $page pages...');
          }
        } catch (e) {
          totalErrors++;
          pagesWithErrors.add(page);
          if (totalErrors <= 5) {
            print('  ❌ Page $page: $e');
          }
        }
      }
      
      print('\n📊 AUDIT RESULTS:');
      print('  Total pages: 604');
      print('  Pages with errors: $totalErrors');
      print('  Success rate: ${((604 - totalErrors) / 604 * 100).toStringAsFixed(1)}%');
      
      if (pagesWithErrors.isNotEmpty && pagesWithErrors.length <= 10) {
        print('  Error pages: ${pagesWithErrors.join(", ")}');
      } else if (pagesWithErrors.length > 10) {
        print('  Error pages: ${pagesWithErrors.take(10).join(", ")}... and ${pagesWithErrors.length - 10} more');
      }
      
      print('═══════════════════════════════════\n');
      
      expect(totalErrors, equals(0), 
        reason: 'All 604 pages should load without errors. Found errors on: $pagesWithErrors');
    });

    tearDownAll(() {
      MushafWordReconstructionService.dispose();
    });
  });
}
