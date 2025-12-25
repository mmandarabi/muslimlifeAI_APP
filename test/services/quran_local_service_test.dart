import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_mind/services/quran_local_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String mockJson = '''
  [
    {
      "id": 1,
      "name": "الفاتحة",
      "transliteration": "Al-Fatihah",
      "type": "meccan",
      "total_verses": 7,
      "verses": [
        {"id": 1, "text": "بسم الله الرحمن الرحيم"},
        {"id": 2, "text": "الحمد لله رب العالمين"}
      ]
    },
    {
      "id": 114,
      "name": "الناس",
      "transliteration": "An-Nas",
      "type": "meccan",
      "total_verses": 6,
      "verses": [
        {"id": 1, "text": "قل أعوذ برب الناس"}
      ]
    }
  ]
  ''';

  group('QuranLocalService Tests', () {
    late QuranLocalService service;

    setUp(() {
      service = QuranLocalService();
      // Use setMockMessageHandler to intercept rootBundle calls
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final Uint8List encoded = utf8.encoder.convert(mockJson);
        return ByteData.view(encoded.buffer);
      });
    });

    test('loadSurahIndex parses JSON correctly', () async {
      final surahs = await service.loadSurahIndex();
      expect(surahs.length, 2);
      expect(surahs[0].transliteration, 'Al-Fatihah');
      expect(surahs[1].id, 114);
    });

    test('getSurahDetails returns correct surah', () async {
      final surah = await service.getSurahDetails(1);
      expect(surah.transliteration, 'Al-Fatihah');
      expect(surah.verses.length, 2);
    });

    test('getSurahDetails throws on invalid ID', () async {
      expect(() => service.getSurahDetails(999), throwsException);
    });

    test('getCachedSurahs is used on subsequent calls', () async {
      await service.loadSurahIndex();
      // We can't easily verify the isolate not running, but we can verify the data remains consistent
      final surahs = await service.loadSurahIndex();
      expect(surahs.length, 2);
    });
  });
}
