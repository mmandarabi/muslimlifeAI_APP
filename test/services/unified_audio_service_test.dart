import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mock just_audio platform channel once for all tests
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('com.ryanheise.just_audio.methods', (message) async {
      return null; // Return success for all calls
    });
  });

  group('UnifiedAudioService Tests', () {
    late UnifiedAudioService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = UnifiedAudioService();
      await service.stop(); // Reset state between tests
    });

    test('Initial state is correct', () {
      expect(service.isPlaying, isFalse);
      expect(service.isTransitioning, isFalse);
      expect(service.currentSurahId, isNull);
    });

    test('Rapid Restart Test (Race Condition)', () async {
      try {
        final future1 = service.playSurah(1).timeout(const Duration(milliseconds: 100));
        final future2 = service.stop();
        final future3 = service.playSurah(2).timeout(const Duration(milliseconds: 100));

        await Future.wait([future1, future2, future3]).catchError((e) => []);
      } catch (_) {}

      expect(service.currentSurahId, 2);
    });

    test('updateAdhanSettings updates local state', () async {
      await service.updateAdhanSettings(reminder: false, notification: true);
      expect(service.reminderEnabled, isFalse);
      expect(service.notificationEnabled, isTrue);
    });

    test('prepareSurah sets context without playing', () async {
      await service.prepareSurah(18, 'Al-Kahf');
      expect(service.currentSurahId, 18);
      expect(service.currentSurahContext.value?.surahName, 'Al-Kahf');
      expect(service.isPlaying, isFalse);
    });
  });
}
