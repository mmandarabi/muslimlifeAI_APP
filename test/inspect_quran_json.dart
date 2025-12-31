import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Inspect quran_uthmani.json structure', () async {
    final file = File(r'D:\solutions\MuslimLifeAI_demo\assets\quran\quran_uthmani.json');
    final content = await file.readAsString();
    
    print('File size: ${file.lengthSync()} bytes');
    
    // Parse JSON
    final data = jsonDecode(content);
    
    print('\nRoot structure type: ${data.runtimeType}');
    
    if (data is List) {
      print('Array with ${data.length} items');
      
      // Show first item structure
      if (data.isNotEmpty) {
        print('\nFirst item structure:');
        final first = data[0];
        print('Type: ${first.runtimeType}');
        print('Keys: ${first.keys.toList()}');
        print('Sample: $first');
        
        // Show second item if exists
        if (data.length > 1) {
          print('\nSecond item:');
          print('Sample: ${data[1]}');
        }
        
        // Show last item
        print('\nLast item:');
        print('Sample: ${data[data.length - 1]}');
      }
    } else if (data is Map) {
      print('Object with keys: ${data.keys.toList()}');
      
      // Show structure
      for (final key in data.keys.take(3)) {
        print('\nKey "$key":');
        print('  Type: ${data[key].runtimeType}');
        if (data[key] is Map) {
          print('  Keys: ${data[key].keys.toList()}');
        }
        print('  Sample: ${data[key]}');
      }
    }
    
    // Search for page-related data
    print('\n' + '='*70);
    print('Looking for page/surah/ayah structure...');
    print('='*70);
    
    if (data is List && data.isNotEmpty) {
      final first = data[0];
      if (first is Map) {
        // Check if it has verse structure
        if (first.containsKey('text') || first.containsKey('verse') || first.containsKey('ayah')) {
          print('✅ Found verse-level data');
          print('Structure: ${first.keys.toList()}');
        }
        if (first.containsKey('page') || first.containsKey('page_number')) {
          print('✅ Found page information');
        }
        if (first.containsKey('surah') || first.containsKey('surah_number') || first.containsKey('chapter')) {
          print('✅ Found surah information');
        }
      }
    }
  });
}
