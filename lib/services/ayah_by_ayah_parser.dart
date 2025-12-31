import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word_segment.dart';

/// Parses Ayah-by-Ayah JSON format.
/// Format: { "1:1": { "surah_number": 1, "ayah_number": 1, "audio_url": "...", "segments": [...] } }
class AyahByAyahParser {
  /// Loads and parses the entire ayah-by-ayah JSON file.
  /// Returns a map of "surah:ayah" keys to ayah data.
  static Future<Map<String, AyahData>> loadFromAsset(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final Map<String, AyahData> result = {};

    for (final entry in jsonData.entries) {
      final key = entry.key; // "1:1"
      final value = entry.value as Map<String, dynamic>;

      final surahNumber = value['surah_number'] as int;
      final ayahNumber = value['ayah_number'] as int;
      final audioUrl = value['audio_url'] as String;
      final duration = (value['duration'] as num).toDouble();
      final segmentsJson = value['segments'] as List<dynamic>;

      final segments = segmentsJson.map((seg) {
        return WordSegment.fromArray(seg as List<dynamic>, surahNumber, ayahNumber);
      }).toList();

      result[key] = AyahData(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        audioUrl: audioUrl,
        duration: duration,
        segments: segments,
      );
    }

    return result;
  }

  /// Gets word segments for a specific ayah.
  static List<WordSegment>? getAyahSegments(
    Map<String, AyahData> data,
    int surahId,
    int ayahNumber,
  ) {
    final key = '$surahId:$ayahNumber';
    return data[key]?.segments;
  }

  /// Gets all word segments for a surah (all ayahs combined).
  static List<WordSegment> getSurahSegments(
    Map<String, AyahData> data,
    int surahId,
  ) {
    final segments = <WordSegment>[];
    for (final entry in data.entries) {
      if (entry.value.surahNumber == surahId) {
        segments.addAll(entry.value.segments);
      }
    }
    return segments;
  }
}

/// Represents ayah data from ayah-by-ayah format.
class AyahData {
  final int surahNumber;
  final int ayahNumber;
  final String audioUrl;
  final double duration;
  final List<WordSegment> segments;

  AyahData({
    required this.surahNumber,
    required this.ayahNumber,
    required this.audioUrl,
    required this.duration,
    required this.segments,
  });

  String get key => '$surahNumber:$ayahNumber';
}
