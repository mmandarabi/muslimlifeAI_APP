import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import '../lib/services/mushaf_text_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MushafTextService - Simplified (AS-IS) Tests', () {
    late MushafTextService service;

    setUpAll(() async {
      service = MushafTextService();
      await service.initialize();
    });

    test('Page 604 should return exactly 9 lines (no merging)', () async {
      final lines = await service.getPageLines(604);
      
      print('\n=== Page 604 Line Count Test ===');
      print('Expected: 9 lines');
      print('Actual: ${lines.length} lines');
      
      for (int i = 0; i < lines.length; i++) {
        final preview = lines[i].length > 40 
            ? '${lines[i].substring(0, 40)}...' 
            : lines[i];
        print('Line ${i + 1}: $preview');
      }
      print('================================\n');
      
      expect(lines.length, equals(9), 
        reason: 'Page 604 should have exactly 9 ayah lines (3 surahs: Al-Ikhlas=2, Al-Falaq=3, An-Nas=4)');
    });

    test('Page 187 should return exactly 14 lines (no padding)', () async {
      final lines = await service.getPageLines(187);
      
      print('\n=== Page 187 Line Count Test ===');
      print('Expected: 14 lines (Surah 9 - At-Tawbah, NO Bismillah)');
      print('Actual: ${lines.length} lines');
      print('================================\n');
      
      expect(lines.length, equals(14), 
        reason: 'Page 187 should have 14 ayah lines (At-Tawbah has no Bismillah)');
    });

    test('Page 1 should return exactly 7 lines (Al-Fatiha)', () async {
      final lines = await service.getPageLines(1);
      
      print('\n=== Page 1 Line Count Test ===');
      print('Expected: 7 lines (Al-Fatiha, 7 verses)');
      print('Actual: ${lines.length} lines');
      print('================================\n');
      
      expect(lines.length, equals(7), 
        reason: 'Page 1 should have 7 ayah lines (Al-Fatiha)');
    });

    test('Special markers should be preserved (Sajdah ۩)', () async {
      // Page 176 has Sajdah marker (End of Al-A'raf)
      final lines = await service.getPageLines(176);
      final allText = lines.join(' ');
      
      print('\n=== Sajdah Marker Test (Page 176) ===');
      print('Checking for Sajdah marker (۩)...');
      print('Found: ${allText.contains('۩') ? 'YES ✅' : 'NO ❌'}');
      print('======================================\n');
      
      expect(allText.contains('۩'), isTrue, 
        reason: 'Page 176 should contain Sajdah marker (۩)');
    });

    test('Special markers should be preserved (Saktah ۜ)', () async {
      // Page 293 has Saktah marker (Al-Kahf 18:1)
      final lines = await service.getPageLines(293);
      final allText = lines.join(' ');
      
      print('\n=== Saktah Marker Test (Page 293) ===');
      print('Checking for Saktah marker (ۜ)...');
      print('Found: ${allText.contains('\u06DC') ? 'YES ✅' : 'NO ❌'}');
      print('======================================\n');
      
      expect(allText.contains('\u06DC'), isTrue, 
        reason: 'Page 293 should contain Saktah marker (ۜ / U+06DC)');
    });

    test('No empty lines should be returned', () async {
      final lines = await service.getPageLines(604);
      
      for (int i = 0; i < lines.length; i++) {
        expect(lines[i].trim().isNotEmpty, isTrue, 
          reason: 'Line ${i + 1} should not be empty');
      }
    });

    test('All pages should load without errors', () async {
      int errorCount = 0;
      List<int> errorPages = [];
      
      for (int page = 1; page <= 604; page++) {
        try {
          final lines = await service.getPageLines(page);
          if (lines.isEmpty) {
            errorCount++;
            errorPages.add(page);
          }
        } catch (e) {
          errorCount++;
          errorPages.add(page);
        }
      }
      
      print('\n=== Full 604-Page Load Test ===');
      print('Pages with errors: $errorCount');
      if (errorPages.isNotEmpty) {
        print('Error pages: $errorPages');
      }
      print('================================\n');
      
      expect(errorCount, equals(0), 
        reason: 'All 604 pages should load without errors');
    });
  });
}
