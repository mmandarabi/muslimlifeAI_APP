import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const surahId = 2;
  const reciterId = 3; // Sudais
  final url = 'https://api.quran.com/api/v4/chapter_recitations/$reciterId/$surahId?segments=true';
  print('Fetching: $url');
  
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final audioUrl = data['audio_file']['audio_url'];
    final timestamps = data['audio_file']['timestamps'];
    
    print('Audio URL: $audioUrl');
    if (timestamps.isNotEmpty) {
      print('First 3 Segments:');
      for (var i = 0; i < 3 && i < timestamps.length; i++) {
        print(timestamps[i]);
      }
    }
  } else {
    print('Error: ${response.statusCode}');
  }
}
