
import 'dart:convert';
import 'package:flutter/services.dart';

class MushafTextService {
  static final MushafTextService _instance = MushafTextService._internal();
  factory MushafTextService() => _instance;
  MushafTextService._internal();

  // Cache: PageNumber -> List of Lines (Strings)
  final Map<int, List<String>> _textCache = {};
  bool _isInit = false;

  /// Loads the V2 map file. Should be called during app init or lazy loaded.
  Future<void> initialize() async {
    if (_isInit) return;
    try {
      final String content = await rootBundle.loadString('assets/quran/mushaf_v2_map.txt');
      LineSplitter.split(content).forEach((line) {
        final parts = line.split(',');
        if (parts.length >= 2) {
          final int? page = int.tryParse(parts[0]);
          final String text = parts.sublist(1).join(','); // Rejoin in case text has commas? Unlikely for Quran.
          
          if (page != null) {
            if (!_textCache.containsKey(page)) {
              _textCache[page] = [];
            }
            // Add valid text lines. Trim to remove CR/LF artifacts.
            if (text.trim().isNotEmpty) {
               _textCache[page]!.add(text.trim());
            }
          }
        }
      });
      _isInit = true;
      print("✅ MushafTextService initialized. Loaded ${_textCache.length} pages.");
    } catch (e) {
      print("❌ Error loading Mushaf Map: $e");
    }
  }

  Future<List<String>> getPageLines(int pageNumber) async {
    if (!_isInit) await initialize();
    List<String> lines = _textCache[pageNumber] ?? [];
    return _applyDataSanitization(pageNumber, lines);
  }

  // ✅ SIMPLIFIED: All drift/merge/padding logic removed
  // The mushaf_v2_map.txt source file is validated correct AS-IS
  // No compensation needed - use text exactly as provided

  List<String> _applyDataSanitization(int page, List<String> lines) {
    if (lines.isEmpty) return lines;
    
    // ✅ SIMPLIFIED: Just filter empty lines for safety
    // The mushaf_v2_map.txt is validated correct AS-IS
    // No drift correction, merging, or padding needed
    return lines.where((l) => l.trim().isNotEmpty).toList();
  }
}

