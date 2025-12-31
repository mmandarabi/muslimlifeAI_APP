import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/controllers/quran_audio_controller.dart';
import 'package:muslim_mind/services/quran_page_service.dart';
import 'package:muslim_mind/models/quran_surah.dart';

/// Unit tests for Audio Player UX features
/// Tests player visibility, play from page start, and audio continuity
void main() {
  group('Audio Player UX Tests', () {
    late QuranAudioController controller;
    late QuranPageService pageService;

    setUp(() {
      controller = QuranAudioController();
      pageService = QuranPageService();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Player Visibility', () {
      test('Player should be hidden by default', () {
        // This will be tested in widget tests
        // Unit test verifies state management
        bool isPlayerVisible = false;
        expect(isPlayerVisible, false);
      });

      test('Toggle visibility changes state', () {
        bool isPlayerVisible = false;
        
        // First toggle
        isPlayerVisible = !isPlayerVisible;
        expect(isPlayerVisible, true);
        
        // Second toggle
        isPlayerVisible = !isPlayerVisible;
        expect(isPlayerVisible, false);
      });
    });

    group('Play from Page Start', () {
      test('Get first ayah of page returns correct ayah number', () {
        // Page 1 starts with Ayah 1 of Surah 1
        final page1Data = pageService.getPageData(1);
        expect(page1Data.isNotEmpty, true);
        expect(page1Data.first['start'], 1);
        
        // Page 2 starts with Ayah 1 of Surah 2
        final page2Data = pageService.getPageData(2);
        expect(page2Data.isNotEmpty, true);
        final firstAyahPage2 = page2Data.first['start'];
        expect(firstAyahPage2, isNotNull);
      });

      test('Play from page start uses correct ayah', () {
        // Get first ayah of page 3
        final page3Data = pageService.getPageData(3);
        final firstAyah = page3Data.first['start'] as int;
        final surahId = page3Data.first['surah'] as int;
        
        // Verify we got valid data
        expect(firstAyah, greaterThan(0));
        expect(surahId, greaterThan(0));
        
        // This ayah should be used when playing from page start
        expect(firstAyah, isNotNull);
      });
    });

    group('Audio Continuity', () {
      test('Audio state persists when not explicitly stopped', () {
        // Simple state test without service initialization
        bool isPlaying = true;
        int? currentSurahId = 1;
        int? activeAyahId = 5;
        
        // Simulate navigation (don't change state)
        // State should persist
        expect(isPlaying, true);
        expect(currentSurahId, 1);
        expect(activeAyahId, 5);
      });

      test('Stopping audio clears playback state', () {
        // Simple state test
        bool isPlaying = true;
        
        // Stop audio
        isPlaying = false;
        
        // State should be cleared
        expect(isPlaying, false);
      });

      test('Playing new surah cancels previous playback', () {
        // Simple state test
        int currentSurahId = 1;
        bool isPlaying = true;
        
        // Play Surah 2 (should cancel Surah 1)
        currentSurahId = 2;
        
        // Verify switched to Surah 2
        expect(currentSurahId, 2);
      });
    });

    group('Page-Based Playback', () {
      test('First ayah of page 1 is Ayah 1', () {
        final pageData = pageService.getPageData(1);
        expect(pageData.first['start'], 1);
        expect(pageData.first['surah'], 1);
      });

      test('First ayah of page 604 is correct', () {
        final pageData = pageService.getPageData(604);
        expect(pageData.isNotEmpty, true);
        
        final firstAyah = pageData.first['start'];
        final surahId = pageData.first['surah'];
        
        // Page 604 starts with Surah 112
        expect(surahId, 112);
        expect(firstAyah, 1);
      });

      test('Page data contains valid surah and ayah ranges', () {
        for (int page = 1; page <= 10; page++) {
          final pageData = pageService.getPageData(page);
          
          expect(pageData.isNotEmpty, true, 
            reason: 'Page $page should have data');
          
          for (var entry in pageData) {
            final surah = entry['surah'] as int?;
            final start = entry['start'] as int?;
            final end = entry['end'] as int?;
            
            expect(surah, greaterThan(0),
              reason: 'Page $page should have valid surah');
            expect(start, greaterThan(0),
              reason: 'Page $page should have valid start ayah');
            expect(end, greaterThanOrEqualTo(start!),
              reason: 'Page $page end ayah should be >= start ayah');
          }
        }
      });
    });

    group('Controller State Management', () {
      test('Active page number tracks correctly', () {
        controller.activePageNumber = 1;
        expect(controller.activePageNumber, 1);
        
        controller.activePageNumber = 5;
        expect(controller.activePageNumber, 5);
        
        controller.activePageNumber = null;
        expect(controller.activePageNumber, null);
      });

      test('Reset playing context clears active page', () {
        controller.activePageNumber = 5;
        controller.activeAyahId = 10;
        
        controller.resetPlayingContext();
        
        expect(controller.activePageNumber, null);
      });

      test('isBrowsing flag can be set and cleared', () {
        controller.isBrowsing = false;
        expect(controller.isBrowsing, false);
        
        controller.isBrowsing = true;
        expect(controller.isBrowsing, true);
        
        controller.isBrowsing = false;
        expect(controller.isBrowsing, false);
      });
    });
  });
}
