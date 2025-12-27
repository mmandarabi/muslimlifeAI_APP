import 'quran_ayah.dart';

class QuranSurah {
  final int id;
  final String name; // Arabic Name
  final String transliteration; // English Name
  final String type;
  final int totalAyahs;
  final List<QuranAyah> ayahs;

  QuranSurah({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalAyahs,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      id: json['id'] as int,
      name: json['name'] as String,
      transliteration: json['transliteration'] as String,
      type: json['type'] as String,
      totalAyahs: json['total_verses'] as int,
      ayahs: (json['verses'] as List<dynamic>)
          .map((v) => QuranAyah.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}
