import 'package:flutter_test/flutter_test.dart';
import '../lib/services/mushaf_text_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Duplicate Content Detection', () {
    late MushafTextService service;

    setUpAll(() async {
      service = MushafTextService();
      await service.initialize();
    });

    test('Page 1 - No duplicate lines', () async {
      final lines = await service.getPageLines(1);
      
      print('\n=== PAGE 1 DUPLICATE CHECK ===');
      print('Total lines: ${lines.length}');
      
      // Check for exact duplicate lines
      final Set<String> uniqueLines = {};
      final List<String> duplicates = [];
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        
        if (uniqueLines.contains(line)) {
          duplicates.add('Line ${i + 1}: ${line.substring(0, line.length > 50 ? 50 : line.length)}...');
          print('❌ DUPLICATE at line ${i + 1}');
        } else {
          uniqueLines.add(line);
          print('✅ Line ${i + 1}: ${line.substring(0, line.length > 50 ? 50 : line.length)}...');
        }
      }
      
      print('\nUnique lines: ${uniqueLines.length}');
      print('Total lines: ${lines.length}');
      print('Duplicates found: ${duplicates.length}');
      
      if (duplicates.isNotEmpty) {
        print('\n⚠️ DUPLICATE LINES:');
        for (var dup in duplicates) {
          print('  $dup');
        }
      }
      print('==============================\n');
      
      expect(duplicates.isEmpty, isTrue, 
        reason: 'Page 1 should not have duplicate lines. Found: ${duplicates.length}');
    });

    test('Page 604 - No duplicate lines', () async {
      final lines = await service.getPageLines(604);
      
      print('\n=== PAGE 604 DUPLICATE CHECK ===');
      print('Total lines: ${lines.length}');
      
      final Set<String> uniqueLines = {};
      final List<String> duplicates = [];
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        
        if (uniqueLines.contains(line)) {
          duplicates.add('Line ${i + 1}');
          print('❌ DUPLICATE at line ${i + 1}: ${line.substring(0, line.length > 40 ? 40 : line.length)}...');
        } else {
          uniqueLines.add(line);
          print('✅ Line ${i + 1}: ${line.substring(0, line.length > 40 ? 40 : line.length)}...');
        }
      }
      
      print('\nUnique lines: ${uniqueLines.length}');
      print('Total lines: ${lines.length}');
      print('Duplicates found: ${duplicates.length}');
      print('===============================\n');
      
      expect(duplicates.isEmpty, isTrue, 
        reason: 'Page 604 should not have duplicate lines');
    });

    test('Page 187 - No duplicate lines', () async {
      final lines = await service.getPageLines(187);
      
      print('\n=== PAGE 187 DUPLICATE CHECK ===');
      print('Total lines: ${lines.length}');
      
      final Set<String> uniqueLines = {};
      final List<String> duplicates = [];
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        
        if (uniqueLines.contains(line)) {
          duplicates.add('Line ${i + 1}');
          print('❌ DUPLICATE at line ${i + 1}');
        } else {
          uniqueLines.add(line);
        }
      }
      
      print('Unique lines: ${uniqueLines.length}');
      print('Total lines: ${lines.length}');
      print('Duplicates found: ${duplicates.length}');
      print('================================\n');
      
      expect(duplicates.isEmpty, isTrue, 
        reason: 'Page 187 should not have duplicate lines');
    });

    test('Random sample pages - No duplicates', () async {
      final testPages = [2, 10, 50, 100, 200, 300, 400, 500, 600];
      int totalDuplicates = 0;
      List<int> pagesWithDuplicates = [];
      
      print('\n=== RANDOM SAMPLE DUPLICATE CHECK ===');
      
      for (var page in testPages) {
        final lines = await service.getPageLines(page);
        final Set<String> uniqueLines = {};
        int duplicateCount = 0;
        
        for (var line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          
          if (uniqueLines.contains(trimmed)) {
            duplicateCount++;
          } else {
            uniqueLines.add(trimmed);
          }
        }
        
        if (duplicateCount > 0) {
          totalDuplicates += duplicateCount;
          pagesWithDuplicates.add(page);
          print('❌ Page $page: $duplicateCount duplicates (${lines.length} total lines)');
        } else {
          print('✅ Page $page: No duplicates (${lines.length} lines)');
        }
      }
      
      print('\nSummary:');
      print('  Total pages checked: ${testPages.length}');
      print('  Pages with duplicates: ${pagesWithDuplicates.length}');
      print('  Total duplicate lines: $totalDuplicates');
      
      if (pagesWithDuplicates.isNotEmpty) {
        print('  Affected pages: $pagesWithDuplicates');
      }
      print('=====================================\n');
      
      expect(pagesWithDuplicates.isEmpty, isTrue,
        reason: 'No pages should have duplicate lines. Found duplicates on: $pagesWithDuplicates');
    });

    test('Full 604-page duplicate scan', () async {
      int totalPagesWithDuplicates = 0;
      List<int> affectedPages = [];
      int totalDuplicateLines = 0;
      
      print('\n=== FULL 604-PAGE DUPLICATE SCAN ===');
      print('Scanning all pages for duplicates...\n');
      
      for (int page = 1; page <= 604; page++) {
        final lines = await service.getPageLines(page);
        final Set<String> uniqueLines = {};
        int pageDuplicates = 0;
        
        for (var line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          
          if (uniqueLines.contains(trimmed)) {
            pageDuplicates++;
          } else {
            uniqueLines.add(trimmed);
          }
        }
        
        if (pageDuplicates > 0) {
          totalPagesWithDuplicates++;
          affectedPages.add(page);
          totalDuplicateLines += pageDuplicates;
          
          if (affectedPages.length <= 10) {
            // Show first 10 affected pages
            print('❌ Page $page: $pageDuplicates duplicate lines');
          }
        }
        
        // Progress indicator every 100 pages
        if (page % 100 == 0) {
          print('  ... scanned $page pages');
        }
      }
      
      print('\n📊 FINAL RESULTS:');
      print('  Total pages: 604');
      print('  Pages with duplicates: $totalPagesWithDuplicates');
      print('  Total duplicate lines: $totalDuplicateLines');
      print('  Percentage affected: ${(totalPagesWithDuplicates / 604 * 100).toStringAsFixed(1)}%');
      
      if (affectedPages.isNotEmpty) {
        print('\n  First 20 affected pages: ${affectedPages.take(20).toList()}');
        if (affectedPages.length > 20) {
          print('  ... and ${affectedPages.length - 20} more');
        }
      }
      print('====================================\n');
      
      expect(totalPagesWithDuplicates, equals(0),
        reason: 'Found duplicates on $totalPagesWithDuplicates pages: ${affectedPages.take(10).toList()}...');
    });
  });
}
