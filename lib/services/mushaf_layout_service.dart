import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';

/// Service to read Mushaf layout database with line_type information
/// Database schema from QUL: https://qul.tarteel.ai/resources/mushaf-layout/15
class MushafLayoutService {
  static Database? _layoutDb;
  static String? overrideDbPath; // For testing purposes
  
  /// Initialize the layout database
  static Future<void> initialize() async {
    if (_layoutDb != null) return;
    
    try {
      String path;
      if (overrideDbPath != null) {
        path = overrideDbPath!;
        // In test mode, we assume file exists or we can't bundle load easily
      } else {
        final dbPath = await getDatabasesPath();
        path = join(dbPath, 'qpc-v2-15-lines.db');
        
        final exists = await databaseExists(path);
        
        if (!exists) {
            final data = await rootBundle.load('assets/quran/databases/qpc-v2-15-lines.db');
            final bytes = data.buffer.asUint8List();
            await Directory(dirname(path)).create(recursive: true);
            await File(path).writeAsBytes(bytes, flush: true);
        }
      }
      
      _layoutDb = await openDatabase(path, readOnly: true);
    } catch (e) {
      // Silent init fail
      if (overrideDbPath != null) rethrow; // Rethrow in tests
    }
  }

  /// Get layout lines for a specific page
  static Future<List<LayoutLine>> getPageLayout(int pageNumber) async {
    if (_layoutDb == null) await initialize();
    if (_layoutDb == null) return [];
    
    final List<Map<String, dynamic>> maps = await _layoutDb!.query(
      'pages',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC',
    );
    
    return List.generate(maps.length, (i) {
      return LayoutLine.fromMap(maps[i]);
    });
  }
  
  /// Get all header lines (surah_name and basmallah)
  static Future<Map<int, List<LayoutLine>>> getPageHeaders(int pageNumber) async {
    final lines = await getPageLayout(pageNumber);
    final headers = <int, List<LayoutLine>>{};
    
    for (final line in lines) {
      if (line.isHeader) {
        headers.putIfAbsent(line.lineNumber, () => []).add(line);
      }
    }
    
    return headers;
  }
  
  /// Get all surah header lines for a page
  static Future<List<LayoutLine>> getSurahHeaders(int pageNumber) async {
    final lines = await getPageLayout(pageNumber);
    return lines.where((line) => line.isSurahName).toList();
  }
  
  /// Get all Bismillah lines for a page
  static Future<List<LayoutLine>> getBismillahLines(int pageNumber) async {
    final lines = await getPageLayout(pageNumber);
    return lines.where((line) => line.isBasmallah).toList();
  }
  
  /// Get all ayah lines for a page (excludes headers and bismillah)
  static Future<List<LayoutLine>> getAyahLines(int pageNumber) async {
    final lines = await getPageLayout(pageNumber);
    return lines.where((line) => line.isAyah).toList();
  }
  
  /// Get ayah line count for a page (should match text file line count)
  static Future<int> getAyahLineCount(int pageNumber) async {
    final ayahLines = await getAyahLines(pageNumber);
    return ayahLines.length;
  }
}

/// Represents a line in the Mushaf layout
class LayoutLine {
  final int pageNumber;
  final int lineNumber;
  final String lineType; // 'ayah' | 'surah_name' | 'basmallah'
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;
  
  LayoutLine({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });
  
  /// Whether this line is a header (not ayah content)
  bool get isHeader => lineType == 'surah_name' || lineType == 'basmallah';
  
  /// Whether this is a surah name line
  bool get isSurahName => lineType == 'surah_name';
  
  /// Whether this is a basmallah line
  bool get isBasmallah => lineType == 'basmallah';
  
  /// Whether this is an ayah content line
  bool get isAyah => lineType == 'ayah';
  
  factory LayoutLine.fromMap(Map<String, dynamic> map) {
    return LayoutLine(
      pageNumber: _tryParseInt(map['page_number']) ?? 0,
      lineNumber: _tryParseInt(map['line_number']) ?? 0,
      lineType: map['line_type']?.toString() ?? 'ayah',
      isCentered: (_tryParseInt(map['is_centered']) ?? 0) == 1,
      firstWordId: _tryParseInt(map['first_word_id']),
      lastWordId: _tryParseInt(map['last_word_id']),
      surahNumber: _tryParseInt(map['surah_number']),
    );
  }

  static int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt(); // Handle double/num
    if (value is String) return int.tryParse(value);
    return null;
  }
  
  @override
  String toString() {
    return 'LayoutLine(page: $pageNumber, line: $lineNumber, type: $lineType, '
           'surah: $surahNumber, centered: $isCentered)';
  }
}
