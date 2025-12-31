import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/quran_surah.dart';
import '../models/quran_ayah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranLocalService {
  static final QuranLocalService _instance = QuranLocalService._internal();

  factory QuranLocalService() {
    return _instance;
  }

  QuranLocalService._internal();

  // In-memory cache
  List<QuranSurah>? _cachedSurahs;

  /// Loads the entire Quran into memory using a background isolate.
  /// safe to call multiple times; returns cached data if available.
  Future<List<QuranSurah>> loadSurahIndex() async {
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    try {
      // 1. Load JSON string from assets (Main Thread - fast IO)
      final jsonString = await rootBundle.loadString('assets/quran/quran_uthmani.json');

      // 2. Parse JSON in Background Isolate (Heavy CPU)
      _cachedSurahs = await compute(_parseQuranJson, jsonString);

      return _cachedSurahs!;
    } catch (e) {
      debugPrint("QuranLocalService: Error loading Quran - $e");
      // Return empty list or rethrow depending on desired behavior.
      // For now, rethrowing so UI knows it failed.
      throw Exception("Failed to parse Quran data: $e");
    }
  }

  /// Returns ayahs for a specific Surah ID (1-114).
  /// Requires loadSurahIndex() to have been called first.
  Future<List<QuranAyah>> loadAyahBySurah(int surahNumber) async {
    final surah = await getSurahDetails(surahNumber);
    return surah.ayahs;
  }

  /// Returns the full Surah object (Metadata + Ayahs)
  Future<QuranSurah> getSurahDetails(int surahNumber) async {
     // Ensure data is loaded
    if (_cachedSurahs == null) {
      await loadSurahIndex();
    }

    return _cachedSurahs!.firstWhere(
      (s) => s.id == surahNumber,
      orElse: () => throw Exception("Surah $surahNumber not found"),
    );
  }

  // 🛑 PERSISTENCE: Track Last Read Surah for Home Resume
  static const String _keyLastSurahId = 'last_read_surah_id';
  static const String _keyLastSurahName = 'last_read_surah_name';

  Future<void> saveLastAccessed(int surahId, String surahName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyLastSurahId, surahId);
      await prefs.setString(_keyLastSurahName, surahName);
    } catch (e) {
      debugPrint("QuranLocalService: Failed to save progress: $e");
    }
  }

  Future<Map<String, dynamic>?> getLastAccessed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt(_keyLastSurahId);
      final name = prefs.getString(_keyLastSurahName);
      if (id != null && name != null) {
        return {'id': id, 'name': name};
      }
    } catch (e) {
      debugPrint("QuranLocalService: Failed to load progress: $e");
    }
    return null;
  }
}

/// Top-level function for compute().
/// Parses the JSON string into a specific List<QuranSurah>.
List<QuranSurah> _parseQuranJson(String encodedJson) {
  final List<dynamic> parsed = jsonDecode(encodedJson);
  return parsed.map<QuranSurah>((json) => QuranSurah.fromJson(json)).toList();
}
