import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

/// Service to reconstruct Mushaf text lines using word-level data from databases
/// This properly handles verses that span multiple layout lines (e.g., Page 1 Line 4 = verses 1:3 + 1:4)
class MushafWordReconstructionService {
  static Database? _layoutDb;
  static Database? _wordDb;
  static bool _isInit = false;
  
  /// Initialize both databases
  static Future<void> initialize() async {
    if (_isInit) return;
    
    try {
      // Initialize layout database (qpc-v2-15-lines.db)
      final dbPath = await getDatabasesPath();
      final layoutPath = join(dbPath, 'qpc-v2-15-lines.db');
      final wordPath = join(dbPath, 'qpc-v2.db');
      
      // Copy layout DB if needed
      if (!await databaseExists(layoutPath)) {
        final layoutData = await rootBundle.load('assets/quran/databases/qpc-v2-15-lines.db');
        final layoutBytes = layoutData.buffer.asUint8List();
        await Directory(dirname(layoutPath)).create(recursive: true);
        await File(layoutPath).writeAsBytes(layoutBytes, flush: true);
      }
      
      // Copy word DB if needed
      if (!await databaseExists(wordPath)) {
        final wordData = await rootBundle.load('assets/quran/databases/qpc-v2.db');
        final wordBytes = wordData.buffer.asUint8List();
        await Directory(dirname(wordPath)).create(recursive: true);
        await File(wordPath).writeAsBytes(wordBytes, flush: true);
      }
      
      _layoutDb = await openDatabase(layoutPath, readOnly: true);
      _wordDb = await openDatabase(wordPath, readOnly: true);
      
      _isInit = true;
      print('✅ MushafWordReconstructionService initialized');
    } catch (e) {
      print('❌ Error initializing MushafWordReconstructionService: $e');
    }
  }
  
  /// Get reconstructed text lines for a page using word-level data
  /// Returns list of text lines that match the layout database structure
  static Future<List<String>> getReconstructedPageLines(int pageNumber) async {
    if (!_isInit) await initialize();
    
    // Get layout structure from qpc-v2-15-lines.db
    final layoutRows = await _layoutDb!.query(
      'pages',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC'
    );
    
    final List<String> reconstructedLines = [];
    
    for (var layout in layoutRows) {
      final lineType = layout['line_type'] as String;
      
      // Skip headers and bismillah - they're rendered separately
      if (lineType == 'surah_name' || lineType == 'basmallah') {
        continue;
      }
      
      // For ayah lines, reconstruct text from word database
      if (lineType == 'ayah') {
        final firstWordId = layout['first_word_id'] as int?;
        final lastWordId = layout['last_word_id'] as int?;
        
        if (firstWordId != null && lastWordId != null) {
          // Query words in range from qpc-v2.db
          final words = await _wordDb!.query(
            'words',
            where: 'id >= ? AND id <= ?',
            whereArgs: [firstWordId, lastWordId],
            orderBy: 'id ASC'
          );
          
          // Combine word glyphs into single line
          final lineText = words.map((w) => w['text'] as String).join(' ');
          reconstructedLines.add(lineText);
        }
      }
    }
    
    return reconstructedLines;
  }
  
  static void dispose() {
    _layoutDb?.close();
    _wordDb?.close();
    _layoutDb = null;
    _wordDb = null;
    _isInit = false;
  }
}
