import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  try {
    print("Opening database...");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'qpc-v1-15-lines.db');

    Database db = await openDatabase(path, readOnly: true);
    print("Database opened.");

    print("Querying Page 604...");
    List<Map> list = await db.rawQuery('SELECT * FROM pages WHERE page_number = 604 ORDER BY line_number');
    
    print("Found ${list.length} lines:");
    for (var row in list) {
       print("Line ${row['line_number']}: type=${row['line_type']}, surah=${row['surah_number']}");
    }
    
    await db.close();
    print("Done.");
  } catch (e) {
    print("Error: $e");
  }
}
