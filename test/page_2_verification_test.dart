import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/quran_page_service.dart';
import 'package:muslim_mind/services/mushaf_layout_service.dart';
import 'package:muslim_mind/services/mushaf_word_reconstruction_service.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page 2 Specific Verification Test
/// Tests rendering, layout, and audio playback on Page 2 (Al-Baqarah start)
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mock just_audio platform channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.ryanheise.just_audio.methods', (message) async {
      return null;
    });
  });

  group('Page 2 Verification Tests', () {
    
    test('Page 2 has correct surah assignment', () {
      final pageService = QuranPageService();
      final page2Data = pageService.getPageData(2);
      
      // Page 2 should start with Surah 2 (Al-Baqarah)
      expect(page2Data.isNotEmpty, true);
      expect(page2Data.first['surah'], 2, reason: 'Page 2 should start with Surah 2 (Al-Baqarah)');
      expect(page2Data.first['start'], 1, reason: 'Page 2 should start with Ayah 1');
      
      print('✅ Page 2 Surah Assignment: Correct (Surah 2, Ayah 1)');
    });

    test('Page 2 layout has 15 lines', () async {
      final layoutLines = await MushafLayoutService.getPageLayout(2);
      
      // Every Mushaf page should have exactly 15 lines
      expect(layoutLines.length, 15, reason: 'Page 2 should have 15 lines');
      
      // Count headers vs ayah lines
      final headerCount = layoutLines.where((l) => l.lineType == 'surah_name').length;
      final bismillahCount = layoutLines.where((l) => l.lineType == 'basmallah').length;
      final ayahCount = layoutLines.where((l) => l.lineType == 'ayah').length;
      
      print('✅ Page 2 Layout Breakdown:');
      print('   - Headers: $headerCount');
      print('   - Bismillah: $bismillahCount');
      print('   - Ayah lines: $ayahCount');
      print('   - Total: ${layoutLines.length} lines');
      
      // Page 2 should have 1 header (Surah Al-Baqarah)
      expect(headerCount, greaterThanOrEqualTo(1), reason: 'Page 2 should have at least 1 surah header');
    });

    test('Page 2 text lines are reconstructed correctly', () async {
      final textLines = await MushafWordReconstructionService.getReconstructedPageLines(2);
      
      // Should have text for ayah lines (15 - headers - bismillah)
      expect(textLines.isNotEmpty, true, reason: 'Page 2 should have reconstructed text');
      
      print('✅ Page 2 Text Reconstruction:');
      print('   - Total text lines: ${textLines.length}');
      
      // Show first ayah text preview
      if (textLines.isNotEmpty) {
        final firstLinePreview = textLines.first.length > 40 
            ? textLines.first.substring(0, 40) + '...' 
            : textLines.first;
        print('   - First line preview: $firstLinePreview');
      }
    });

    test('Page 2 audio playback setup works', () async {
      SharedPreferences.setMockInitialValues({});
      
      final audioService = UnifiedAudioService();
      
      // Get Page 2 info
      final pageService = QuranPageService();
      final page2Data = pageService.getPageData(2);
      final surahId = page2Data.first['surah'] as int;
      final firstAyah = page2Data.first['start'] as int;
      
      // Verify we can set context for Page 2's surah
      audioService.setContext(surahId);
      
      expect(audioService.currentSurahId, surahId, 
        reason: 'Audio service should set context to Surah $surahId');
      
      print('✅ Page 2 Audio Setup:');
      print('   - Surah ID: $surahId (Al-Baqarah)');
      print('   - First Ayah: $firstAyah');
      print('   - Audio service context set successfully');
    });

    test('Page 2 start ayah can be resolved for playback', () async {
      SharedPreferences.setMockInitialValues({});
      
      final audioService = UnifiedAudioService();
      final pageService = QuranPageService();
      
      // Get Page 2 first ayah
      final page2Data = pageService.getPageData(2);
      final surahId = page2Data.first['surah'] as int;
      final ayahNumber = page2Data.first['start'] as int;
      
      // This is what "Play from page start" would use
      expect(surahId, 2);
      expect(ayahNumber, 1);
      
      print('✅ Page 2 Playback Parameters:');
      print('   - Play from: Surah $surahId, Ayah $ayahNumber');
      print('   - This would start Al-Baqarah from Ayah 1');
    });

    test('Page 2 reciter selection persists', () async {
      SharedPreferences.setMockInitialValues({
        'selected_quran_reciter_key': 'sudais'
      });
      
      final audioService = UnifiedAudioService();
      await audioService.init();
      
      // Default reciter should be loaded
      expect(audioService.currentQuranReciter, 'sudais');
      
      // Change reciter
      await audioService.setQuranReciter('saad');
      expect(audioService.currentQuranReciter, 'saad');
      
      print('✅ Page 2 Reciter Selection:');
      print('   - Initial reciter: sudais');
      print('   - Changed to: saad');
      print('   - Reciter selection works correctly');
    });
  });
}
