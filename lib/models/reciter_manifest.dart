/// Manages reciter metadata and audio asset paths.
/// Maps reciter IDs to their respective JSON data files.
class ReciterManifest {
  final String id;
  final String name;
  final String arabicName;
  final ReciterAudioFormat format;
  final String basePath;

  ReciterManifest({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.format,
    required this.basePath,
  });

  /// Gets the path to the segments JSON file.
  String get segmentsPath {
    if (format == ReciterAudioFormat.ayahByAyah) {
      return 'assets/audio/quran/aya_by_aya/$basePath';
    } else {
      return 'assets/audio/quran/surah_by_surah/$basePath/segments.json';
    }
  }

  /// Gets the path to the surah metadata JSON file (surah-by-surah only).
  String? get surahMetadataPath {
    if (format == ReciterAudioFormat.surahBySurah) {
      return 'assets/audio/quran/surah_by_surah/$basePath/surah.json';
    }
    return null;
  }

  /// Predefined reciters with their asset paths.
  static final Map<String, ReciterManifest> _reciters = {
    'sudais': ReciterManifest(
      id: 'sudais',
      name: 'Abdur-Rahman As-Sudais',
      arabicName: 'عبد الرحمن السديس',
      format: ReciterAudioFormat.ayahByAyah,
      basePath: 'ayah-recitation-abdur-rahman-as-sudais-recitation.json',
    ),
    'abdul_basit': ReciterManifest(
      id: 'abdul_basit',
      name: 'Abdul Basit Abdul Samad',
      arabicName: 'عبد الباسط عبد الصمد',
      format: ReciterAudioFormat.surahBySurah,
      basePath: 'AbdulBasitAbdulSamad',
    ),
    'alafasy': ReciterManifest(
      id: 'alafasy',
      name: 'Mishari Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
      format: ReciterAudioFormat.surahBySurah,
      basePath: 'surah-recitation-mishari-rashid-al-afasy-streaming',
    ),
  };

  /// Gets a reciter by ID.
  static ReciterManifest? getReciter(String id) {
    return _reciters[id];
  }

  /// Gets all available reciters.
  static List<ReciterManifest> getAllReciters() {
    return _reciters.values.toList();
  }

  /// Gets reciter IDs.
  static List<String> getReciterIds() {
    return _reciters.keys.toList();
  }

  /// Checks if a reciter ID is valid.
  static bool isValidReciter(String id) {
    return _reciters.containsKey(id);
  }

  /// Maps legacy reciter IDs to new manifest IDs.
  /// Used for backward compatibility with existing user preferences.
  static String? mapLegacyReciterId(String legacyId) {
    switch (legacyId.toLowerCase()) {
      case 'sudais':
      case '3': // QDC API ID
        return 'sudais';
      case 'alafasy':
      case 'mishary':
      case '7': // QDC API ID
        return 'alafasy';
      case 'abdul_basit':
      case 'abdul basit':
      case 'basit':
        return 'abdul_basit';
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'ReciterManifest(id: $id, name: $name, format: $format)';
  }
}

/// Audio format for reciter data.
enum ReciterAudioFormat {
  /// One MP3 file per ayah (discrete segments).
  ayahByAyah,

  /// One MP3 file per surah (continuous playback).
  surahBySurah,
}
