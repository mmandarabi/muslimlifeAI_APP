# Technical Implementation: Syncing Quranic Glyph Bounding Boxes with Text Tokens
## For 15-Line Mushaf Layout (QCF Standard)

---

## Executive Summary

Your issue stems from a **fundamental schema mismatch**: your `mushaf_v2_map.txt` uses a sequential token-based approach while `ayahinfo.db` uses a **line_type-aware** coordinate system. Pages with Surah headers (like Page 604) have lines where `line_type = 'surah_name'` or `line_type = 'basmallah'`—these consume visual space but have **no glyph coordinates** in the DB because they're rendered using separate decorative fonts (QCF_BSML), not the per-page glyph fonts.

---

## 1. Data Schema: Industry Standard Approach

### 1.1 The Correct Two-Table Architecture

Industry-standard apps (Quran.com, Ayah App, QuranEngine iOS) use **two separate databases** that must be joined:

#### **Layout Database (`pages` table)**

```sql
CREATE TABLE pages (
    id INTEGER PRIMARY KEY,
    page_number INTEGER NOT NULL,
    line_number INTEGER NOT NULL,       -- 1-15 for each page
    line_type TEXT NOT NULL,            -- 'ayah' | 'surah_name' | 'basmallah'
    is_centered BOOLEAN DEFAULT FALSE,
    first_word_id INTEGER,              -- NULL for surah_name/basmallah
    last_word_id INTEGER,               -- NULL for surah_name/basmallah
    surah_number INTEGER                -- Only populated for surah_name lines
);
```

#### **Glyph Coordinates Database (`glyphs` table)**

```sql
CREATE TABLE glyphs (
    glyph_id INTEGER PRIMARY KEY,
    page_number INTEGER NOT NULL,
    line_number INTEGER NOT NULL,       -- Physical line on rendered page
    sura_number INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    position INTEGER NOT NULL,          -- Word position within the line (RTL: right=1)
    min_x INTEGER NOT NULL,
    max_x INTEGER NOT NULL,
    min_y INTEGER NOT NULL,
    max_y INTEGER NOT NULL
);
CREATE INDEX page_idx ON glyphs(page_number);
CREATE INDEX sura_ayah_idx ON glyphs(sura_number, ayah_number);
```

### 1.2 Critical Insight: Line Numbers Are NOT Sequential for Ayah Content

On a page with a Surah header (e.g., Page 604), the layout looks like:

| line_number | line_type   | first_word_id | Glyph Count in DB |
|-------------|-------------|---------------|-------------------|
| 1           | surah_name  | NULL          | **0** (no glyphs) |
| 2           | basmallah   | NULL          | **0** (no glyphs) |
| 3           | ayah        | 77201         | 8                 |
| 4           | ayah        | 77209         | 9                 |
| ...         | ...         | ...           | ...               |

**Your bug**: You're iterating tokens sequentially (line 1, 2, 3...) and mapping them to glyphs sequentially, but the glyph DB skips lines 1-2 because they're headers!

---

## 2. Alignment Formula: The Anchor Algorithm

### 2.1 The Core Redistribution Algorithm

```dart
/// Dart/Flutter implementation for syncing tokens to glyph coordinates
class MushafPageMapper {
  final Database layoutDb;    // pages table
  final Database glyphDb;     // glyphs table
  
  /// Maps tokens to their bounding boxes for a given page
  Future<List<TokenRect>> mapTokensToRects(int pageNumber) async {
    // Step 1: Get ALL lines for this page with their types
    final lines = await layoutDb.query(
      'pages',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC',
    );
    
    // Step 2: Get ALL glyphs for this page
    final glyphs = await glyphDb.query(
      'glyphs',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC, position DESC', // RTL ordering
    );
    
    // Step 3: Build glyph lookup map keyed by (line_number, position)
    final glyphMap = <String, Map<String, dynamic>>{};
    for (final glyph in glyphs) {
      final key = '${glyph['line_number']}_${glyph['position']}';
      glyphMap[key] = glyph;
    }
    
    // Step 4: Iterate ONLY ayah-type lines and map words to glyphs
    final result = <TokenRect>[];
    
    for (final line in lines) {
      final lineType = line['line_type'] as String;
      final lineNumber = line['line_number'] as int;
      
      // SKIP non-ayah lines - they have no glyph coordinates!
      if (lineType != 'ayah') {
        continue;
      }
      
      final firstWordId = line['first_word_id'] as int?;
      final lastWordId = line['last_word_id'] as int?;
      
      if (firstWordId == null || lastWordId == null) continue;
      
      // Step 5: Calculate word count for this line
      final wordCount = lastWordId - firstWordId + 1;
      
      // Step 6: Map each word position to its glyph
      for (int pos = 1; pos <= wordCount; pos++) {
        final wordId = firstWordId + pos - 1;
        final glyphKey = '${lineNumber}_$pos';
        final glyph = glyphMap[glyphKey];
        
        if (glyph != null) {
          result.add(TokenRect(
            wordId: wordId,
            lineNumber: lineNumber,
            position: pos,
            rect: Rect.fromLTRB(
              glyph['min_x'].toDouble(),
              glyph['min_y'].toDouble(),
              glyph['max_x'].toDouble(),
              glyph['max_y'].toDouble(),
            ),
            surah: glyph['sura_number'] as int,
            ayah: glyph['ayah_number'] as int,
          ));
        }
      }
    }
    
    return result;
  }
}

class TokenRect {
  final int wordId;
  final int lineNumber;
  final int position;
  final Rect rect;
  final int surah;
  final int ayah;
  
  TokenRect({
    required this.wordId,
    required this.lineNumber,
    required this.position,
    required this.rect,
    required this.surah,
    required this.ayah,
  });
}
```

### 2.2 The Key Formula

```
effective_line = line_number WHERE line_type = 'ayah'
glyph_position = word_index_within_line (1-based, RTL)

Token[i] → Rect[effective_line, position]
         WHERE layout.first_word_id <= word_id <= layout.last_word_id
         AND glyphs.line_number = layout.line_number
         AND glyphs.position = (word_id - first_word_id + 1)
```

---

## 3. Open Source References

### 3.1 Primary Repositories

| Repository | Purpose | Key Files |
|------------|---------|-----------|
| [quran/quran_android](https://github.com/quran/quran_android) | Production Android app | `ImageAyahUtils.kt`, glyph DB integration |
| [quran/quran-ios](https://github.com/quran/quran-ios) | Production iOS app (QuranEngine) | `Data/` and `Domain/` layers |
| [quran/quran.com-images](https://github.com/quran/quran.com-images) | Glyph bounds generation | `lib/Quran/DB.pm`, `lib/Quran/Image/Page.pm` |
| [quran/ayah-detection](https://github.com/quran/ayah-detection) | Ayah marker detection scripts | `main.py`, glyphs schema definition |
| [TarteelAI/quranic-universal-library](https://github.com/TarteelAI/quranic-universal-library) | Layout management CMS | Mushaf layout tool |

### 3.2 Key Implementation from quran.com-images

The `DB.pm` file shows how bounds are stored with line_type awareness:

```perl
# From quran.com-images/lib/Quran/DB.pm
sub get_page_lines {
    my ($self, $page) = @_;
    
    # Query includes line_type to distinguish header vs ayah lines
    $self->{_select_page_glyphs} = $self->{_dbh}->prepare_cached(
        "SELECT gpl.glyph_page_line_id, gpl.line_number, gpl.line_type, 
                gpl.position, g.font_file, ..."
    );
}
```

### 3.3 QUL (Quranic Universal Library) Resources

Download the authoritative layout databases from:
- **Layout DB**: https://qul.tarteel.ai/resources/mushaf-layout/15 (KFGQPC V1)
- **Words DB**: https://qul.tarteel.ai/resources/quran-script/57 (QPC V1 Glyphs)

---

## 4. Handling Structural Mismatches

### 4.1 Common Mismatch Scenarios

| Scenario | Cause | Solution |
|----------|-------|----------|
| **Surah Headers** | `line_type='surah_name'` has no glyphs | Skip these lines when mapping |
| **Basmallah Lines** | `line_type='basmallah'` uses QCF_BSML font | Render separately with Bismillah font |
| **Sajdah Marks** | Ornamental, may not have glyph IDs | Filter by `word_type` in words table |
| **End-of-Ayah Symbols** | Included in word count but may have special handling | Check if position exceeds glyph count |
| **Page 1 & 2 Special Layout** | Only 8 lines instead of 15 | Query actual line count, don't assume 15 |

### 4.2 Defensive Redistribution Script

```dart
/// Complete redistribution script with mismatch handling
class GlyphTokenSynchronizer {
  
  /// Redistributes tokens to match actual glyph availability
  List<MappedToken> synchronize({
    required List<LayoutLine> layoutLines,
    required List<GlyphCoordinate> glyphCoordinates,
    required List<WordToken> tokens,
  }) {
    final result = <MappedToken>[];
    
    // Build glyph availability map
    final glyphsByLine = <int, List<GlyphCoordinate>>{};
    for (final glyph in glyphCoordinates) {
      glyphsByLine.putIfAbsent(glyph.lineNumber, () => []).add(glyph);
    }
    
    // Sort each line's glyphs by position (descending for RTL)
    for (final glyphs in glyphsByLine.values) {
      glyphs.sort((a, b) => b.position.compareTo(a.position));
    }
    
    // Process only ayah-type lines
    for (final line in layoutLines.where((l) => l.lineType == 'ayah')) {
      final lineGlyphs = glyphsByLine[line.lineNumber] ?? [];
      
      if (lineGlyphs.isEmpty) {
        // MISMATCH DETECTED: Layout expects content but no glyphs exist
        print('WARNING: Line ${line.lineNumber} has no glyphs but expects '
              'words ${line.firstWordId}-${line.lastWordId}');
        continue;
      }
      
      // Get tokens for this line
      final lineTokens = tokens.where(
        (t) => t.wordId >= line.firstWordId && t.wordId <= line.lastWordId
      ).toList();
      
      // Validate counts
      if (lineTokens.length != lineGlyphs.length) {
        print('MISMATCH: Line ${line.lineNumber} has ${lineTokens.length} '
              'tokens but ${lineGlyphs.length} glyphs');
        
        // Strategy: Map available glyphs to tokens, skip overflow
        final minCount = min(lineTokens.length, lineGlyphs.length);
        for (int i = 0; i < minCount; i++) {
          result.add(MappedToken(
            token: lineTokens[i],
            glyph: lineGlyphs[i],
            lineNumber: line.lineNumber,
          ));
        }
      } else {
        // Perfect match - map 1:1
        for (int i = 0; i < lineTokens.length; i++) {
          result.add(MappedToken(
            token: lineTokens[i],
            glyph: lineGlyphs[i],
            lineNumber: line.lineNumber,
          ));
        }
      }
    }
    
    return result;
  }
}
```

### 4.3 Handling Special Elements

```dart
/// Filter tokens that should not have glyph coordinates
bool shouldHaveGlyph(WordToken token) {
  // These word types are ornamental and may not have coordinates
  const ornamentalTypes = ['end', 'sajdah', 'rub_el_hizb', 'pause'];
  
  return !ornamentalTypes.contains(token.wordType);
}
```

---

## 5. Complete Implementation Recipe

### Step 1: Validate Your Data Sources

```sql
-- Check if your ayahinfo.db has line_type information
PRAGMA table_info(glyphs);

-- If missing line_type, you need to join with a layout database
-- Download from: https://qul.tarteel.ai/resources/mushaf-layout/15
```

### Step 2: Create a Unified View

```sql
-- Create a view that joins layout with glyphs
CREATE VIEW page_word_mapping AS
SELECT 
    p.page_number,
    p.line_number,
    p.line_type,
    p.first_word_id,
    p.last_word_id,
    g.position,
    g.min_x, g.max_x, g.min_y, g.max_y,
    g.sura_number, g.ayah_number
FROM pages p
LEFT JOIN glyphs g ON p.page_number = g.page_number 
                   AND p.line_number = g.line_number
WHERE p.line_type = 'ayah'  -- Only join ayah lines
ORDER BY p.page_number, p.line_number, g.position DESC;
```

### Step 3: Implement the Page Painter

```dart
class MushafPagePainter extends CustomPainter {
  final List<MappedToken> mappedTokens;
  final Size imageSize;
  final Size canvasSize;
  
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    
    for (final mapped in mappedTokens) {
      // Scale glyph coordinates to canvas
      final scaledRect = Rect.fromLTRB(
        mapped.glyph.minX * scaleX,
        mapped.glyph.minY * scaleY,
        mapped.glyph.maxX * scaleX,
        mapped.glyph.maxY * scaleY,
      );
      
      // Draw highlight or handle tap detection
      if (isSelected(mapped.token)) {
        canvas.drawRect(
          scaledRect,
          Paint()
            ..color = Colors.yellow.withOpacity(0.3)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }
}
```

---

## 6. Debugging Checklist

When encountering alignment issues:

- [ ] **Verify line_type exists**: Your layout DB must have line_type column
- [ ] **Check Page 604 specifically**: Query `SELECT * FROM pages WHERE page_number = 604`
- [ ] **Confirm glyph count**: `SELECT COUNT(*) FROM glyphs WHERE page_number = 604 GROUP BY line_number`
- [ ] **Validate word_id continuity**: Ensure first_word_id/last_word_id are correct
- [ ] **Test with QUL data**: Download fresh layout from TarteelAI to compare

---

## 7. Key Takeaways

1. **Never assume sequential line→glyph mapping** - Always check `line_type`
2. **Use two databases**: Layout (pages) + Coordinates (glyphs)
3. **Headers consume lines but not glyph space** - Skip them in your mapping loop
4. **Position is 1-indexed and RTL** - Position 1 is the rightmost word
5. **Download authoritative data from QUL** - https://qul.tarteel.ai

---

## References

- QUL Mushaf Layout Documentation: https://qul.tarteel.ai/docs/mushaf-layout
- QuranPortal Technical Guide: https://quranportal.io/blog/rendering-the-quran-mushaf-digitally
- Quran Android Repository: https://github.com/quran/quran_android
- Quran iOS Repository: https://github.com/quran/quran-ios
- Glyph Detection Scripts: https://github.com/quran/ayah-detection
- QCF Fonts: https://github.com/nuqayah/qpc-fonts
