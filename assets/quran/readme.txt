DATA SOURCES FOR PAGE quran:

Layout Database (qpc-v1-15-lines.db):
Source: QUL (Quran Unstructured Library) from Tarteel.ai
URL: https://qul.tarteel.ai/resources/mushaf-layout/15
Purpose: Defines line structure (15 lines per page, line types: surah_name, basmallah, ayah)
Used by: 
MushafLayoutService
Glyph Database (ayahinfo.db):
Location: 
assets/quran/databases/ayahinfo.db
Purpose: Contains exact glyph count per line (used to validate text integrity)
Used in: Step 5 of diagnostic suite to verify glyph counts match
Text File (mushaf_v2_map.txt):
Location: 
assets/quran/mushaf_v2_map.txt
Format: {page_number},{space-separated glyphs}
Purpose: The actual Quran text glyphs
Used by: 
MushafTextService