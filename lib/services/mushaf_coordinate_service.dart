
import 'package:flutter/widgets.dart';
import 'mushaf_data_service.dart';

class MushafCoordinateService {
  final MushafDataService _dataService = MushafDataService();

  // Canonical dimensions for the KFGQPC 1024 dataset
  static const double kCanonicalWidth = 1024.0;
  static const double kCanonicalHeight = 1656.0;

  // Cache
  final Map<int, MushafPageData> _pageCache = {};

  Future<MushafPageData> getPageData(int pageNumber, Size screenSize) async {
    if (_pageCache.containsKey(pageNumber)) {
       // Ideally re-scale if size changed, but for now return cached
       return _pageCache[pageNumber]!;
    }

    try {
      final rawData = await _dataService.getPageGlyphs(pageNumber);
      final double scale = screenSize.width / kCanonicalWidth;
      
      List<MushafHighlight> highlights = [];
      Map<int, Rect> lineBounds = {};

      for (var row in rawData) {
        int surah = row['sura_number'] as int? ?? row['sura'] as int? ?? 0;
        int ayah = row['ayah_number'] as int? ?? row['ayah'] as int? ?? 0;
        int line = row['line_number'] as int? ?? 0;
        int position = row['position'] as int? ?? 0; // 🛑 NEW: Capture Word Index

        
        double minX = (row['min_x'] as num? ?? 0).toDouble();
        double minY = (row['min_y'] as num? ?? 0).toDouble();
        double maxX = (row['max_x'] as num? ?? 0).toDouble();
        double maxY = (row['max_y'] as num? ?? 0).toDouble();

        Rect rect = Rect.fromLTRB(
          minX * scale, 
          minY * scale, 
          maxX * scale, 
          maxY * scale
        );

        highlights.add(MushafHighlight(
          surah: surah, 
          ayah: ayah, 
          rect: rect,
          lineNumber: line,
          wordIndex: position // 🛑 NEW FIELD
        ));
        
        // Aggregate Line Bounds
        if (line > 0) {
           if (lineBounds.containsKey(line)) {
             lineBounds[line] = lineBounds[line]!.expandToInclude(rect);
           } else {
             lineBounds[line] = rect;
           }
        }
      }
      
      final pageData = MushafPageData(highlights: highlights, lineBounds: lineBounds);
      _pageCache[pageNumber] = pageData;
      return pageData;
    } catch (e) {
      print("Error fetching page data for $pageNumber: $e");
      return MushafPageData(highlights: [], lineBounds: {});
    }
  }

  /// Inverse transformation: Map screen touch -> Ayah
  MushafHighlight? getAyahFromTouch(Offset touchPosition, List<MushafHighlight> highlights) {
    for (var h in highlights) {
      if (h.rect.contains(touchPosition)) {
        return h;
      }
    }
    return null;
  }
}

class MushafPageData {
  final List<MushafHighlight> highlights;
  final Map<int, Rect> lineBounds;

  MushafPageData({required this.highlights, required this.lineBounds});
}


class MushafHighlight {
  final int surah;
  final int ayah;
  final Rect rect;
  final int lineNumber;
  final int? wordIndex; // 🛑 NEW FIELD

  MushafHighlight({
    required this.surah, 
    required this.ayah, 
    required this.rect,
    required this.lineNumber,
    this.wordIndex,
  });
  
  @override
  String toString() => "S$surah:A$ayah L$lineNumber W$wordIndex $rect";
}
