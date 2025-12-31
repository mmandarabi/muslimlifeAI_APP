import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'dart:io';

void main() {
  final dbPath = join(Directory.current.path, 'assets', 'quran', 'ayahinfo.db');
  final db = sqlite3.open(dbPath);

  print('🔎 Page 2 Glyph Counts per Line:');
  
  final result = db.select('SELECT line_number, COUNT(*) as count FROM glyphs WHERE page_number = 2 GROUP BY line_number ORDER BY line_number');
  
  for (final row in result) {
    print('Line ${row['line_number']}: ${row['count']} glyphs');
  }
  
  // Also total
  final total = db.select('SELECT COUNT(*) as count FROM glyphs WHERE page_number = 2');
  print('TOTAL GLYPHS: ${total.first['count']}');

  db.dispose();
}
