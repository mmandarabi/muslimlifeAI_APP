import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word_segment.dart';

/// Parses Surah-by-Surah JSON format.
/// Two files: segments.json (word timestamps) and surah.json (audio URLs).
class SurahBySurahParser {
  /// Loads and parses both segments.json and surah.json files.
  static Future<SurahBySurahData> loadFromAssets({
    required String segmentsPath,
    required String surahMetadataPath,
  }) async {
    // Load segments
    final segmentsJson = await rootBundle.loadString(segmentsPath);
    final Map<String, dynamic> segmentsData = json.decode(segmentsJson);

    // Load surah metadata
    final surahJson = await rootBundle.loadString(surahMetadataPath);
    final Map<String, dynamic> surahData = json.decode(surahJson);

    // Parse segments
    final Map<String, AyahSegmentData> segments = {};
    
    // Sort keys to ensure we process ayahs in order for cumulative calculation
    final sortedKeys = segmentsData.keys.toList()
      ..sort((a, b) {
         final aParts = a.split(':').map(int.parse).toList();
         final bParts = b.split(':').map(int.parse).toList();
         if (aParts[0] != bParts[0]) return aParts[0].compareTo(bParts[0]);
         return aParts[1].compareTo(bParts[1]);
      });

    int currentProcessingSurah = -1;
    int runningOffset = 0;

    for (final key in sortedKeys) {
      final value = segmentsData[key] as Map<String, dynamic>;

      final parts = key.split(':');
      final surahNumber = int.parse(parts[0]);
      final ayahNumber = int.parse(parts[1]);

      // Reset offset for new Surah
      if (surahNumber != currentProcessingSurah) {
        currentProcessingSurah = surahNumber;
        runningOffset = 0;
      }

      final segmentsJson = value['segments'];
      if (segmentsJson is! List) {
        throw FormatException('Expected segments to be a List for $key, got ${segmentsJson.runtimeType}');
      }
      
      final wordSegments = <WordSegment>[];
      int maxSegmentEnd = 0;

      for (var i = 0; i < (segmentsJson as List).length; i++) {
        final seg = segmentsJson[i];
        if (seg is! List) continue;
        
        final segList = seg as List<dynamic>;
        if (segList.length < 3) continue;
        
        try {
          // Create segment manually to inject offset
          // JSON: [wordIndex, start, end]
          final wDesc = WordSegment.fromArray(segList, surahNumber, ayahNumber);
          
          final adjustedStart = wDesc.timestampFrom + runningOffset;
          final adjustedEnd = wDesc.timestampTo + runningOffset;
          
          if (wDesc.timestampTo > maxSegmentEnd) {
            maxSegmentEnd = wDesc.timestampTo;
          }

          wordSegments.add(WordSegment(
            surahId: surahNumber,
            ayahNumber: ayahNumber,
            wordIndex: wDesc.wordIndex,
            timestampFrom: adjustedStart,
            timestampTo: adjustedEnd,
          ));
        } catch (e) {
          print('Warning: Skipping unparseable segment[$i] in $key: $e');
        }
      }

      // Check if explicit timestamp_from is available (and non-zero), otherwise use calculated
      // Ideally we trust the running offset for Gapless sync
      final statedStart = value['timestamp_from'] as int?;
      final effectiveStart = (statedStart != null && statedStart > 0) ? statedStart : runningOffset;

      segments[key] = AyahSegmentData(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        segments: wordSegments,
        durationSec: value['duration_sec'] as int? ?? 0,
        durationMs: value['duration_ms'] as int? ?? 0,
        timestampFrom: effectiveStart,
        timestampTo: effectiveStart + maxSegmentEnd, // Approximate
      );
      
      // Advance offset by the duration of this ayah's segments
      // (Used for the NEXT ayah)
      runningOffset += maxSegmentEnd; // maxSegmentEnd is relative duration
    }

    // Parse surah metadata
    final Map<int, SurahMetadata> surahMetadata = {};
    for (final entry in surahData.entries) {
      final surahNumber = int.parse(entry.key);
      final value = entry.value as Map<String, dynamic>;

      surahMetadata[surahNumber] = SurahMetadata(
        surahNumber: value['surah_number'] as int,
        audioUrl: value['audio_url'] as String,
        duration: value['duration'] as int,
      );
    }

    return SurahBySurahData(
      segments: segments,
      surahMetadata: surahMetadata,
    );
  }

  /// Gets word segments for a specific ayah.
  static List<WordSegment>? getAyahSegments(
    SurahBySurahData data,
    int surahId,
    int ayahNumber,
  ) {
    final key = '$surahId:$ayahNumber';
    return data.segments[key]?.segments;
  }

  /// Gets all word segments for a surah (all ayahs combined).
  /// Segments are already in cumulative timestamp format (relative to surah start).
  static List<WordSegment> getSurahSegments(
    SurahBySurahData data,
    int surahId,
  ) {
    final segments = <WordSegment>[];
    for (final entry in data.segments.entries) {
      if (entry.value.surahNumber == surahId) {
        segments.addAll(entry.value.segments);
      }
    }
    return segments;
  }

  /// Gets the audio URL for a surah.
  static String? getSurahAudioUrl(
    SurahBySurahData data,
    int surahId,
  ) {
    return data.surahMetadata[surahId]?.audioUrl;
  }

  /// Gets the total duration of a surah in seconds.
  static int? getSurahDuration(
    SurahBySurahData data,
    int surahId,
  ) {
    return data.surahMetadata[surahId]?.duration;
  }
}

/// Container for surah-by-surah data.
class SurahBySurahData {
  final Map<String, AyahSegmentData> segments;
  final Map<int, SurahMetadata> surahMetadata;

  SurahBySurahData({
    required this.segments,
    required this.surahMetadata,
  });
}

/// Represents ayah segment data from surah-by-surah format.
class AyahSegmentData {
  final int surahNumber;
  final int ayahNumber;
  final List<WordSegment> segments;
  final int durationSec;
  final int durationMs;
  final int timestampFrom; // Start time within surah (cumulative)
  final int timestampTo; // End time within surah (cumulative)

  AyahSegmentData({
    required this.surahNumber,
    required this.ayahNumber,
    required this.segments,
    required this.durationSec,
    required this.durationMs,
    required this.timestampFrom,
    required this.timestampTo,
  });

  String get key => '$surahNumber:$ayahNumber';
}

/// Represents surah metadata (audio URL and duration).
class SurahMetadata {
  final int surahNumber;
  final String audioUrl;
  final int duration; // seconds

  SurahMetadata({
    required this.surahNumber,
    required this.audioUrl,
    required this.duration,
  });
}
