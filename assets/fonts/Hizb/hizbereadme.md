Export Formats
Hizb data is exported in both JSON and SQLite formats.

JSON Format
Here is an example of the JSON structure for the first hizb:

{
  "1": {
    "hizb_number": 1,
    "verses_count": 81,
    "first_verse_key": "1:1",
    "last_verse_key": "2:74",
    "verse_mapping": {
      "1": "1-7",
      "2": "1-74"
    }
  }
}
    
Field	Type	Description
juz_number	INTEGER	The hizb number (1 to 60).
verses_count	INTEGER	Total number of verses in the hizb.
first_verse_key	TEXT	The key of the first verse in the hizb (e.g. 1:1).
last_verse_key	TEXT	The key of the last verse in the hizb (e.g. 2:74).
verse_mapping	OBJECT	A mapping of surah numbers to ayah ranges within this hizb. For example, "2": "1-74" indicates that Surah 2 (Al-Baqarah) has verses 1 to 74 in this hizb.