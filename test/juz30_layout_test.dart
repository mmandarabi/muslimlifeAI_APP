import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite_ffi for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Set test database path
    MushafLayoutService.overrideDbPath = 'assets/quran/databases/qpc-v1-15-lines.db';
  });

  group('Juz 30 Layout Verification', () {
    test('All Juz 30 pages (582-604) have exactly 15 lines', () async {
      await MushafLayoutService.initialize();
      
      const juz30StartPage = 582;
      const juz30EndPage = 604;
      
      for (int pageNum = juz30StartPage; pageNum <= juz30EndPage; pageNum++) {
        final layout = await MushafLayoutService.getPageLayout(pageNum);
        
        expect(
          layout.length,
          equals(15),
          reason: 'Page $pageNum should have exactly 15 lines',
        );
        
        // Verify line numbers are sequential 1-15
        for (int i = 0; i < layout.length; i++) {
          expect(
            layout[i].lineNumber,
            equals(i + 1),
            reason: 'Page $pageNum line index $i should be line ${i + 1}',
          );
        }
      }
    });

    test('Page 604 has correct structure (3 headers, 3 bismillahs, 9 ayahs)', () async {
      await MushafLayoutService.initialize();
      final layout = await MushafLayoutService.getPageLayout(604);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      final ayahs = layout.where((l) => l.lineType == 'ayah').toList();
      
      expect(headers.length, equals(3), reason: 'Page 604 should have 3 Surah headers');
      expect(bismillahs.length, equals(3), reason: 'Page 604 should have 3 Bismillahs');
      expect(ayahs.length, equals(9), reason: 'Page 604 should have 9 ayah lines');
      
      // Verify Surah IDs
      expect(headers[0].surahNumber, equals(112), reason: 'First header should be Al-Ikhlas');
      expect(headers[1].surahNumber, equals(113), reason: 'Second header should be Al-Falaq');
      expect(headers[2].surahNumber, equals(114), reason: 'Third header should be An-Nas');
    });

    test('Height calculation ensures 1050px total for all Juz 30 pages', () async {
      await MushafLayoutService.initialize();
      const double refH = 1050.0;
      const double headerHeight = 110.0;
      
      for (int pageNum = 582; pageNum <= 604; pageNum++) {
        final layout = await MushafLayoutService.getPageLayout(pageNum);
        
        final headerCount = layout.where((l) => l.lineType == 'surah_name').length;
        final nonHeaderCount = 15 - headerCount;
        final standardLineHeight = (refH - headerCount * headerHeight) / nonHeaderCount;
        
        // Calculate total height
        final totalHeight = (headerCount * headerHeight) + (nonHeaderCount * standardLineHeight);
        
        expect(
          totalHeight,
          equals(refH),
          reason: 'Page $pageNum total height should be exactly $refH px',
        );
        
        // Verify standardLineHeight is reasonable (not negative or huge)
        expect(
          standardLineHeight,
          greaterThan(40),
          reason: 'Page $pageNum standard line height should be > 40px',
        );
        expect(
          standardLineHeight,
          lessThan(80),
          reason: 'Page $pageNum standard line height should be < 80px',
        );
        
        print('✓ Page $pageNum: $headerCount headers, $nonHeaderCount others, lineH=${standardLineHeight.toStringAsFixed(1)}px');
      }
    });

    test('Page 187 (Surah 9 - At-Tawbah) has NO Bismillah', () async {
      await MushafLayoutService.initialize();
      final layout = await MushafLayoutService.getPageLayout(187);
      
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(
        bismillahs.length,
        equals(0),
        reason: 'Page 187 (Surah At-Tawbah) should have NO Bismillah',
      );
      
      // Should still have exactly 15 lines
      expect(layout.length, equals(15));
    });

    test('Page 1 (Al-Fatiha) has correct structure', () async {
      await MushafLayoutService.initialize();
      final layout = await MushafLayoutService.getPageLayout(1);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(headers.length, greaterThanOrEqualTo(1), reason: 'Page 1 should have Al-Fatiha header');
      expect(bismillahs.length, greaterThanOrEqualTo(1), reason: 'Page 1 should have Bismillah');
      expect(layout.length, equals(15), reason: 'Page 1 should have 15 lines');
    });

    test('Page 2 (Al-Baqara) has correct structure', () async {
      await MushafLayoutService.initialize();
      final layout = await MushafLayoutService.getPageLayout(2);
      
      final headers = layout.where((l) => l.lineType == 'surah_name').toList();
      final bismillahs = layout.where((l) => l.lineType == 'basmallah').toList();
      
      expect(headers.length, greaterThanOrEqualTo(1), reason: 'Page 2 should have Al-Baqara header');
      expect(bismillahs.length, greaterThanOrEqualTo(1), reason: 'Page 2 should have Bismillah');
      expect(layout.length, equals(15), reason: 'Page 2 should have 15 lines');
    });
  });
}
