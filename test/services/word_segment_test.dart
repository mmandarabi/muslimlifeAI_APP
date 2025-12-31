import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:muslim_mind/models/word_segment.dart';
import 'package:muslim_mind/models/reciter_manifest.dart';
import 'package:muslim_mind/services/ayah_by_ayah_parser.dart';
import 'package:muslim_mind/services/surah_by_surah_parser.dart';
import 'package:muslim_mind/services/audio_segment_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WordSegment Model Tests', () {
    test('should parse from array format (numeric)', () {
      final segment = WordSegment.fromArray([1, 380, 730], 1, 1);
      
      expect(segment.surahId, 1);
      expect(segment.ayahNumber, 1);
      expect(segment.wordIndex, 1);
      expect(segment.timestampFrom, 380);
      expect(segment.timestampTo, 730);
    });

    test('should parse from array format (string)', () {
      final segment = WordSegment.fromArray(['1', '380', '730'], 1, 1);
      
      expect(segment.surahId, 1);
      expect(segment.ayahNumber, 1);
      expect(segment.wordIndex, 1);
      expect(segment.timestampFrom, 380);
      expect(segment.timestampTo, 730);
    });

    test('should calculate duration correctly', () {
      final segment = WordSegment.fromArray([1, 380, 730], 1, 1);
      expect(segment.durationMs, 350);
    });

    test('should generate correct ID', () {
      final segment = WordSegment.fromArray([1, 380, 730], 1, 1);
      expect(segment.id, '1:1:1');
    });

    test('should serialize to JSON and back', () {
      final original = WordSegment(
        surahId: 1,
        ayahNumber: 1,
        wordIndex: 1,
        timestampFrom: 380,
        timestampTo: 730,
      );

      final json = original.toJson();
      final restored = WordSegment.fromJson(json, 1, 1);

      expect(restored.surahId, original.surahId);
      expect(restored.ayahNumber, original.ayahNumber);
      expect(restored.wordIndex, original.wordIndex);
      expect(restored.timestampFrom, original.timestampFrom);
      expect(restored.timestampTo, original.timestampTo);
    });
  });

  group('ReciterManifest Tests', () {
    test('should get reciter by ID', () {
      final sudais = ReciterManifest.getReciter('sudais');
      expect(sudais, isNotNull);
      expect(sudais!.name, 'Abdur-Rahman As-Sudais');
      expect(sudais.format, ReciterAudioFormat.ayahByAyah);
    });

    test('should map legacy reciter IDs', () {
      expect(ReciterManifest.mapLegacyReciterId('sudais'), 'sudais');
      expect(ReciterManifest.mapLegacyReciterId('3'), 'sudais'); // QDC API ID
      expect(ReciterManifest.mapLegacyReciterId('alafasy'), 'alafasy');
      expect(ReciterManifest.mapLegacyReciterId('7'), 'alafasy'); // QDC API ID
    });

    test('should validate reciter IDs', () {
      expect(ReciterManifest.isValidReciter('sudais'), true);
      expect(ReciterManifest.isValidReciter('invalid'), false);
    });

    test('should get all reciters', () {
      final reciters = ReciterManifest.getAllReciters();
      expect(reciters.length, greaterThanOrEqualTo(3));
      expect(reciters.any((r) => r.id == 'sudais'), true);
      expect(reciters.any((r) => r.id == 'abdul_basit'), true);
      expect(reciters.any((r) => r.id == 'alafasy'), true);
    });
  });

  group('AyahByAyahParser Tests', () {
    test('should load Sudais ayah-by-ayah data', () async {
      final reciter = ReciterManifest.getReciter('sudais')!;
      final data = await AyahByAyahParser.loadFromAsset(reciter.segmentsPath);

      expect(data, isNotEmpty);
      
      // Check Al-Fatiha first ayah (Bismillah)
      final bismillah = data['1:1'];
      expect(bismillah, isNotNull);
      expect(bismillah!.surahNumber, 1);
      expect(bismillah.ayahNumber, 1);
      expect(bismillah.segments, isNotEmpty);
      
      print('✅ Loaded ${data.length} ayahs from Sudais data');
      print('   Bismillah has ${bismillah.segments.length} word segments');
    });

    test('should extract word segments for specific ayah', () async {
      final reciter = ReciterManifest.getReciter('sudais')!;
      final data = await AyahByAyahParser.loadFromAsset(reciter.segmentsPath);
      
      final segments = AyahByAyahParser.getAyahSegments(data, 1, 1);
      expect(segments, isNotNull);
      expect(segments!.length, greaterThan(0));
      
      // Verify segment structure
      final firstWord = segments.first;
      expect(firstWord.surahId, 1);
      expect(firstWord.ayahNumber, 1);
      expect(firstWord.wordIndex, greaterThan(0));
      expect(firstWord.timestampFrom, greaterThanOrEqualTo(0));
      expect(firstWord.timestampTo, greaterThan(firstWord.timestampFrom));
      
      print('✅ Bismillah (1:1) has ${segments.length} words');
      print('   First word: ${firstWord.timestampFrom}ms - ${firstWord.timestampTo}ms');
    });

    test('should get all segments for a surah', () async {
      final reciter = ReciterManifest.getReciter('sudais')!;
      final data = await AyahByAyahParser.loadFromAsset(reciter.segmentsPath);
      
      final segments = AyahByAyahParser.getSurahSegments(data, 1);
      expect(segments, isNotEmpty);
      
      // Al-Fatiha has 7 ayahs
      final ayahNumbers = segments.map((s) => s.ayahNumber).toSet();
      expect(ayahNumbers.length, 7);
      
      print('✅ Al-Fatiha has ${segments.length} total word segments across 7 ayahs');
    });
  });

  group('SurahBySurahParser Tests', () {
    test('should load Abdul Basit surah-by-surah data', () async {
      final reciter = ReciterManifest.getReciter('abdul_basit')!;
      final data = await SurahBySurahParser.loadFromAssets(
        segmentsPath: reciter.segmentsPath,
        surahMetadataPath: reciter.surahMetadataPath!,
      );

      expect(data.segments, isNotEmpty);
      expect(data.surahMetadata, isNotEmpty);
      
      // Check Al-Fatiha
      final bismillah = data.segments['1:1'];
      expect(bismillah, isNotNull);
      expect(bismillah!.segments, isNotEmpty);
      
      // Check surah metadata
      final surah1 = data.surahMetadata[1];
      expect(surah1, isNotNull);
      expect(surah1!.audioUrl, isNotEmpty);
      expect(surah1.duration, greaterThan(0));
      
      print('✅ Loaded ${data.segments.length} ayah segments');
      print('   Loaded ${data.surahMetadata.length} surah metadata entries');
      print('   Al-Fatiha audio: ${surah1.audioUrl}');
    });

    test('should have cumulative timestamps', () async {
      final reciter = ReciterManifest.getReciter('abdul_basit')!;
      final data = await SurahBySurahParser.loadFromAssets(
        segmentsPath: reciter.segmentsPath,
        surahMetadataPath: reciter.surahMetadataPath!,
      );

      final ayah1 = data.segments['1:1']!;
      final ayah2 = data.segments['1:2']!;
      
      // Ayah 2 should start where Ayah 1 ends (cumulative)
      expect(ayah2.timestampFrom, ayah1.timestampTo);
      
      // Word segments should also be cumulative
      final lastWordAyah1 = ayah1.segments.last;
      final firstWordAyah2 = ayah2.segments.first;
      
      expect(firstWordAyah2.timestampFrom, greaterThanOrEqualTo(lastWordAyah1.timestampTo));
      
      print('✅ Timestamps are cumulative:');
      print('   Ayah 1 ends at: ${ayah1.timestampTo}ms');
      print('   Ayah 2 starts at: ${ayah2.timestampFrom}ms');
    });
  });

  group('AudioSegmentService Integration Tests', () {
    test('should load word segments for Sudais (ayah-by-ayah)', () async {
      final service = AudioSegmentService();
      
      final segments = await service.getWordSegments(1, 'sudais');
      
      expect(segments, isNotEmpty);
      expect(segments.first.surahId, 1);
      
      // Al-Fatiha has 7 ayahs, each with multiple words
      final ayahNumbers = segments.map((s) => s.ayahNumber).toSet();
      expect(ayahNumbers.length, 7);
      
      print('✅ Loaded ${segments.length} word segments for Al-Fatiha (Sudais)');
    });

    test('should load word segments for Abdul Basit (surah-by-surah)', () async {
      final service = AudioSegmentService();
      
      final segments = await service.getWordSegments(1, 'abdul_basit');
      
      expect(segments, isNotEmpty);
      expect(segments.first.surahId, 1);
      
      print('✅ Loaded ${segments.length} word segments for Al-Fatiha (Abdul Basit)');
    });

    test('should cache segments in memory', () async {
      final service = AudioSegmentService();
      
      // First load
      final segments1 = await service.getWordSegments(1, 'sudais');
      expect(segments1, isNotEmpty);
      
      // Second load (should be cached and return same data)
      final segments2 = await service.getWordSegments(1, 'sudais');
      expect(segments2, isNotEmpty);
      expect(segments2.length, segments1.length);
      
      // Verify cache returns identical data
      expect(segments2.first.id, segments1.first.id);
      expect(segments2.last.id, segments1.last.id);
      
      print('✅ Caching works: ${segments1.length} segments cached and retrieved successfully');
    });

    test('should get audio URL for reciter', () async {
      final service = AudioSegmentService();
      
      final url = await service.getAudioUrl(1, 'abdul_basit');
      
      expect(url, isNotNull);
      expect(url, contains('http'));
      expect(url, contains('.mp3'));
      
      print('✅ Audio URL: $url');
    });
  });

  group('Bismillah Verification Tests', () {
    test('should confirm Bismillah is included in segments', () async {
      final reciter = ReciterManifest.getReciter('abdul_basit')!;
      final data = await SurahBySurahParser.loadFromAssets(
        segmentsPath: reciter.segmentsPath,
        surahMetadataPath: reciter.surahMetadataPath!,
      );

      // Check Surah 1 (Al-Fatiha) - Ayah 1 is Bismillah
      final bismillah = data.segments['1:1']!;
      expect(bismillah.segments.length, greaterThanOrEqualTo(3)); // At least 3-4 words
      
      // Check Surah 2 (Al-Baqarah) - Should also have Bismillah as first ayah
      final baqarahBismillah = data.segments['2:1'];
      expect(baqarahBismillah, isNotNull);
      
      print('✅ Bismillah verification:');
      print('   Al-Fatiha Bismillah: ${bismillah.segments.length} words');
      print('   Al-Baqarah Bismillah: ${baqarahBismillah?.segments.length ?? 0} words');
    });
  });
}
