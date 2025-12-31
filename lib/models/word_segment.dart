/// Represents a word-level audio segment with precise timestamps.
/// Used for word-by-word highlighting during Quran recitation.
class WordSegment {
  final int surahId;
  final int ayahNumber;
  final int wordIndex; // 1-indexed position within the ayah
  final int timestampFrom; // milliseconds
  final int timestampTo; // milliseconds

  WordSegment({
    required this.surahId,
    required this.ayahNumber,
    required this.wordIndex,
    required this.timestampFrom,
    required this.timestampTo,
  });

  /// Creates a WordSegment from a JSON map.
  /// Handles both string and numeric formats from different data sources.
  factory WordSegment.fromJson(
    Map<String, dynamic> json,
    int surahId,
    int ayahNumber,
  ) {
    return WordSegment(
      surahId: surahId,
      ayahNumber: json['ayahNumber'] != null ? _parseToInt(json['ayahNumber']) : ayahNumber,
      wordIndex: _parseToInt(json['wordIndex'] ?? json['word_index'] ?? json[0]),
      timestampFrom: _parseToInt(json['timestampFrom'] ?? json['timestamp_from'] ?? json[1]),
      timestampTo: _parseToInt(json['timestampTo'] ?? json['timestamp_to'] ?? json[2]),
    );
  }

  /// Parses a value to int, handling both string and numeric inputs.
  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot parse $value to int');
  }

  /// Creates a WordSegment from an array format: [wordIndex, startMs, endMs] or [wordIndex, startMs, endMs, extra]
  /// Some data sources include a 4th element (purpose unknown), which is safely ignored.
  factory WordSegment.fromArray(
    List<dynamic> array,
    int surahId,
    int ayahNumber,
  ) {
    if (array.length < 3 || array.length > 4) {
      throw ArgumentError('Word segment array must have 3-4 elements, got ${array.length}');
    }
    return WordSegment(
      surahId: surahId,
      ayahNumber: ayahNumber,
      wordIndex: _parseToInt(array[0]),
      timestampFrom: _parseToInt(array[1]),
      timestampTo: _parseToInt(array[2]),
      // array[3] is ignored if present (unknown purpose in some data sources)
    );
  }

  /// Converts to JSON map for caching.
  Map<String, dynamic> toJson() {
    return {
      'surahId': surahId,
      'ayahNumber': ayahNumber,
      'wordIndex': wordIndex,
      'timestampFrom': timestampFrom,
      'timestampTo': timestampTo,
    };
  }

  /// Unique identifier for this word segment.
  String get id => '$surahId:$ayahNumber:$wordIndex';

  /// Duration of this word segment in milliseconds.
  int get durationMs => timestampTo - timestampFrom;

  @override
  String toString() {
    return 'WordSegment(surah: $surahId, ayah: $ayahNumber, word: $wordIndex, '
        'from: ${timestampFrom}ms, to: ${timestampTo}ms)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordSegment &&
        other.surahId == surahId &&
        other.ayahNumber == ayahNumber &&
        other.wordIndex == wordIndex &&
        other.timestampFrom == timestampFrom &&
        other.timestampTo == timestampTo;
  }

  @override
  int get hashCode {
    return Object.hash(
      surahId,
      ayahNumber,
      wordIndex,
      timestampFrom,
      timestampTo,
    );
  }
}
