import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_segment.dart';
import '../models/reciter_manifest.dart';
import 'ayah_by_ayah_parser.dart';
import 'surah_by_surah_parser.dart';

/// Service for loading and caching word-level audio segments.
/// Replaces QDC API calls with local JSON data.
class AudioSegmentService {
  static final AudioSegmentService _instance = AudioSegmentService._internal();
  factory AudioSegmentService() => _instance;
  AudioSegmentService._internal();

  // Memory cache for parsed data
  final Map<String, Map<String, AyahData>> _ayahByAyahCache = {};
  final Map<String, SurahBySurahData> _surahBySurahCache = {};

  // Segment cache: surahId -> List<WordSegment>
  final Map<int, List<WordSegment>> _wordSegmentCache = {};

  /// Loads word segments for a surah using the specified reciter.
  /// Returns cached data if available, otherwise loads from assets.
  Future<List<WordSegment>> getWordSegments(int surahId, String reciterId) async {
    // Check memory cache first
    final cacheKey = surahId;
    if (_wordSegmentCache.containsKey(cacheKey)) {
      return _wordSegmentCache[cacheKey]!;
    }

    // Check disk cache
    final cachedSegments = await _loadFromDiskCache(surahId, reciterId);
    if (cachedSegments != null) {
      _wordSegmentCache[cacheKey] = cachedSegments;
      return cachedSegments;
    }

    // Load from assets
    final reciter = ReciterManifest.getReciter(reciterId);
    if (reciter == null) {
      throw ArgumentError('Invalid reciter ID: $reciterId');
    }

    List<WordSegment> segments;

    if (reciter.format == ReciterAudioFormat.ayahByAyah) {
      segments = await _loadAyahByAyahSegments(surahId, reciter);
    } else {
      segments = await _loadSurahBySurahSegments(surahId, reciter);
    }

    // Cache in memory and disk
    _wordSegmentCache[cacheKey] = segments;
    await _saveToDiskCache(surahId, reciterId, segments);

    return segments;
  }

  /// Loads ayah-by-ayah format segments.
  Future<List<WordSegment>> _loadAyahByAyahSegments(
    int surahId,
    ReciterManifest reciter,
  ) async {
    // Check if we've already loaded this reciter's data
    if (!_ayahByAyahCache.containsKey(reciter.id)) {
      final data = await AyahByAyahParser.loadFromAsset(reciter.segmentsPath);
      _ayahByAyahCache[reciter.id] = data;
    }

    final data = _ayahByAyahCache[reciter.id]!;
    return AyahByAyahParser.getSurahSegments(data, surahId);
  }

  /// Loads surah-by-surah format segments.
  Future<List<WordSegment>> _loadSurahBySurahSegments(
    int surahId,
    ReciterManifest reciter,
  ) async {
    // Check if we've already loaded this reciter's data
    if (!_surahBySurahCache.containsKey(reciter.id)) {
      final data = await SurahBySurahParser.loadFromAssets(
        segmentsPath: reciter.segmentsPath,
        surahMetadataPath: reciter.surahMetadataPath!,
      );
      _surahBySurahCache[reciter.id] = data;
    }

    final data = _surahBySurahCache[reciter.id]!;
    return SurahBySurahParser.getSurahSegments(data, surahId);
  }

  /// Gets the audio URL for a surah.
  Future<String?> getAudioUrl(int surahId, String reciterId) async {
    final reciter = ReciterManifest.getReciter(reciterId);
    if (reciter == null) return null;

    if (reciter.format == ReciterAudioFormat.ayahByAyah) {
      // For ayah-by-ayah, we need the first ayah's URL
      // (Each ayah has its own URL, but we'll handle that in playback logic)
      if (!_ayahByAyahCache.containsKey(reciter.id)) {
        final data = await AyahByAyahParser.loadFromAsset(reciter.segmentsPath);
        _ayahByAyahCache[reciter.id] = data;
      }
      final data = _ayahByAyahCache[reciter.id]!;
      final firstAyah = data['$surahId:1'];
      return firstAyah?.audioUrl;
    } else {
      // For surah-by-surah, get the surah URL
      if (!_surahBySurahCache.containsKey(reciter.id)) {
        final data = await SurahBySurahParser.loadFromAssets(
          segmentsPath: reciter.segmentsPath,
          surahMetadataPath: reciter.surahMetadataPath!,
        );
        _surahBySurahCache[reciter.id] = data;
      }
      final data = _surahBySurahCache[reciter.id]!;
      return SurahBySurahParser.getSurahAudioUrl(data, surahId);
    }
  }

  /// Loads segments from disk cache.
  Future<List<WordSegment>?> _loadFromDiskCache(int surahId, String reciterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'word_segments_${reciterId}_$surahId';
      final cachedJson = prefs.getString(key);

      if (cachedJson != null) {
        final List<dynamic> decoded = json.decode(cachedJson);
        return decoded.map((m) => WordSegment.fromJson(m, surahId, 0)).toList();
      }
    } catch (e) {
      // Ignore cache errors
    }
    return null;
  }

  /// Saves segments to disk cache.
  Future<void> _saveToDiskCache(
    int surahId,
    String reciterId,
    List<WordSegment> segments,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'word_segments_${reciterId}_$surahId';
      final encoded = json.encode(segments.map((s) => s.toJson()).toList());
      await prefs.setString(key, encoded);
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Clears all caches (for testing or reciter changes).
  Future<void> clearCache() async {
    _ayahByAyahCache.clear();
    _surahBySurahCache.clear();
    _wordSegmentCache.clear();

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('word_segments_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
