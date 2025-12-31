import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../lib/services/mushaf_word_reconstruction_service.dart';
import '../lib/services/mushaf_text_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Word Reconstruction Service Tests', () {
    setUpAll(() async {
      await MushafWordReconstructionService.initialize();
    });

    test('Page 1 - Reconstruct Line 4 with verses 3+4 combined', () async {
      final lines = await MushafWordReconstructionService.getReconstructedPageLines(1);
      
      print('\n=== PAGE 1 RECONSTRUCTED LINES ===');
      print('Total ayah lines: ${lines.length}');
      
      for (int i = 0; i < lines.length; i++) {
        final preview = lines[i].length > 60 ? '${lines[i].substring(0, 60)}...' : lines[i];
        print('  Ayah Line ${i + 1}: $preview');
      }
      
      print('\n📊 LINE 4 ANALYSIS:');
      if (lines.length >= 3) {
        final line4 = lines[2]; // Index 2 = Line 4 (after header on line 1)
        final words = line4.split(' ');
        print('  Total words in Line 4 (3rd ayah line): ${words.length}');
        print('  Expected: 7 words (verse 1:3 + verse 1:4 combined)');
        print('  Text: $line4');
        
        expect(words.length, equals(7), 
          reason: 'Line 4 should have 7 words (3 from verse 1:3 + 4 from verse 1:4)');
      }
      
      print('==================================\n');
    });

    test('Page 1 - Compare old vs new approach', () async {
      final reconstructed = await MushafWordReconstructionService.getReconstructedPageLines(1);
      
      final oldService = MushafTextService();
      await oldService.initialize();
      final oldLines = await oldService.getPageLines(1);
      
      print('\n=== OLD VS NEW COMPARISON ===');
      print('Old text service: ${oldLines.length} lines');
      print('New reconstructed: ${reconstructed.length} lines');
      print('');
      
      print('Expected structure:');
      print('  Line 2 (Ayah Line 1): Verse 1:1 (Bismillah)');
      print('  Line 3 (Ayah Line 2): Verse 1:2');
      print('  Line 4 (Ayah Line 3): Verses 1:3 + 1:4 COMBINED ← FIX');
      print('  Line 5 (Ayah Line 4): Verse 1:5 + start of 1:6');
      print('  Line 6 (Ayah Line 5): End of 1:6 + start of 1:7');
      print('  Line 7 (Ayah Line 6): Middle of 1:7');
      print('  Line 8 (Ayah Line 7): End of 1:7');
      print('==============================\n');
      
      expect(reconstructed.length, equals(7), 
        reason: 'Should have 7 ayah lines for Page 1');
    });

    test('Page 604 - Reconstruct with 3 surahs', () async {
      final lines = await MushafWordReconstructionService.getReconstructedPageLines(604);
      
      print('\n=== PAGE 604 RECONSTRUCTED LINES ===');
      print('Total ayah lines: ${lines.length}');
      print('Expected: 9 ayah lines (Al-Ikhlas=2, Al-Falaq=3, An-Nas=4)');
      
      for (int i = 0; i < lines.length; i++) {
        final preview = lines[i].length > 40 ? '${lines[i].substring(0, 40)}...' : lines[i];
        print('  Ayah Line ${i + 1}: $preview');
      }
      print('=====================================\n');
      
      expect(lines.length, equals(9), 
        reason: 'Page 604 should have 9 ayah lines');
    });

    tearDownAll(() {
      MushafWordReconstructionService.dispose();
    });
  });
}
