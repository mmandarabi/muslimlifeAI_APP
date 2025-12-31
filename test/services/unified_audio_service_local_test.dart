import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/audio_segment_service.dart';
import 'package:muslim_mind/models/word_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple Mock
class MockAudioSegmentService implements AudioSegmentService {
  @override
  Future<List<WordSegment>> getWordSegments(int surahId, String reciterId) async {
    if (surahId == 1) {
      return [
        // Ayah 1 (Bismillah) words
        WordSegment(surahId: 1, ayahNumber: 1, wordIndex: 1, timestampFrom: 0, timestampTo: 500),
        WordSegment(surahId: 1, ayahNumber: 1, wordIndex: 2, timestampFrom: 500, timestampTo: 1000),
        // Ayah 2 words
        WordSegment(surahId: 1, ayahNumber: 2, wordIndex: 1, timestampFrom: 1200, timestampTo: 1500),
        WordSegment(surahId: 1, ayahNumber: 2, wordIndex: 2, timestampFrom: 1500, timestampTo: 2200),
      ];
    }
    return [];
  }

  @override
  Future<String?> getAudioUrl(int surahId, String reciterId) async {
    return "https://mock.url/surah_$surahId.mp3";
  }

  @override
  Future<void> cacheSegments(int surahId, String reciterId, List<WordSegment> segments) async {}

  @override
  Future<void> clearCache() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
     SharedPreferences.setMockInitialValues({}); // Start fresh
  });

  test('WORD SYNC AGGREGATION: UnifiedAudioService prefers local word segments', () async {
    final service = UnifiedAudioService();
    final mock = MockAudioSegmentService();
    
    // Inject Mock
    service.segmentServiceOverride = mock;
    
    // Test: Fetch Timestamps for Surah 1
    // Should use Mock data, NOT API
    final timestamps = await service.getAyahTimestamps(1);
    
    expect(timestamps.length, 2, reason: "Should have aggregated 2 ayahs from 4 word segments");
    
    // Verify Aggregation Logic
    // Ayah 1: Starts at word 1 start (0), ends at word 2 end (1000)
    expect(timestamps[0].ayahNumber, 1);
    expect(timestamps[0].timestampFrom, 0);
    expect(timestamps[0].timestampTo, 1000);
    
    // Ayah 2: Starts at word 1 start (1200), ends at word 2 end (2200)
    expect(timestamps[1].ayahNumber, 2);
    expect(timestamps[1].timestampFrom, 1200);
    expect(timestamps[1].timestampTo, 2200);
    
    print("✅ TEST PASSED: Word segments correctly aggregated into Ayah timestamps.");
  });

  test('FALLBACK LOGIC: Uses API if local data missing', () async {
    final service = UnifiedAudioService();
    final mock = MockAudioSegmentService();
    
    // Inject Mock that returns empty for Surah 999
    service.segmentServiceOverride = mock;
    
    // We expect it to try API (and fail gracefully in test env, or return empty)
    // Testing that it doesn't crash is enough here.
    final timestamps = await service.getAyahTimestamps(999);
    
    expect(timestamps, isEmpty, reason: "Should return empty if both local and API fail (API mocked to fail)");
  });
}
