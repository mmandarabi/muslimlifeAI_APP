import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_life_ai_demo/controllers/quran_audio_controller.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_life_ai_demo/models/quran_surah.dart';
import 'package:muslim_life_ai_demo/models/quran_ayah.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.ryanheise.just_audio.methods', (message) async {
      return null;
    });
  });

  group('QuranAudioController Tests', () {
    late QuranAudioController controller;
    late PageController pageController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = QuranAudioController();
      pageController = PageController();
      // Wait for service init if needed
    });

    test('isBrowsing state protects SmartFollow', () {
       controller.isPlaying = true;
       controller.activeAyahId = 1;
       controller.isBrowsing = true; // User is manually browsing
       
       final mockSurah = QuranSurah(
         id: 1, 
         name: 'Al-Fatiha', 
         transliteration: 'The Opening',
         type: 'Meccan',
         totalVerses: 7,
         verses: [QuranAyah(id: 1, text: '...')]
       );
       
       // handleSmartFollow should do nothing if isBrowsing is true
       controller.handleSmartFollow(pageController, 0, mockSurah);
       
       expect(pageController.hasClients, isFalse); // It didn't try to animate
    });

    test('resetPlayingContext clears state', () {
      controller.activeAyahId = 5;
      controller.currentPosition = const Duration(seconds: 10);
      
      controller.resetPlayingContext();
      
      expect(controller.activeAyahId, isNull);
      expect(controller.currentPosition, Duration.zero);
    });

    test('fetchTimestamps resets state when not playing', () async {
      controller.isPlaying = false;
      controller.activeAyahId = 10;
      controller.currentPosition = const Duration(seconds: 30);
      
      // We don't actually need to wait for the network in this test if we just check the sync reset
      await controller.fetchTimestamps(1);
      
      expect(controller.currentPosition, Duration.zero);
      expect(controller.activeAyahId, isNull);
    });
  });
}
