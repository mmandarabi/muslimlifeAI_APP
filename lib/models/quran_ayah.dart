class QuranAyah {
  final int id;
  final String text;

  // The 'id' in ayahs array is usually the ayah number within the Surah for this specific JSON structure
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
