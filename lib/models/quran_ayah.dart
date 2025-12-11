class QuranAyah {
  final int id;
  final String text;

  // The 'id' in verses array is usually the verse number within the Surah for this specific JSON structure
  QuranAyah({
    required this.id,
    required this.text,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}
