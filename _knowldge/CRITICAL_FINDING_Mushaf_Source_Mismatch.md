# CRITICAL FINDING: Source File Structure Mismatch

**Date:** 2025-12-30  
**Status:** 🚨 **BLOCKS ORIGINAL CLEANING SCRIPT PLAN**

---

## 🔴 **THE PROBLEM**

The original cleaning script plan assumed we could:
1. Read source file line by line
2. Check layout DB for line type
3. Keep `ayah` lines, skip `surah_name`/`basmallah` lines

**This approach is WRONG because:**

The **source file line breaking does NOT match the layout database structure**.

---

## 📊 **EVIDENCE**

### **Page 2 Mismatch:**

**Layout DB (qpc-v2-15-lines.db) says:**
- 8 total lines:
  - Line 1: `surah_name` (header)
  - Line 2: `basmallah`
  - Lines 3-8: **6 ayah lines**

**Source File (mushaf_v2_map.txt) has:**
- **Only 5 lines** for Page 2
- Different word groupings than layout DB expects

**Example:**
```
Layout Line 3: Verse 2:1 (words 1-2) + Verse 2:2 (words 1-6)
Source Line 1: ﱁ ﱂ (only 2 words - Verse 2:1 only)
Source Line 2: ﱃ ﱄﱅ ﱆ ﱇ ﱈ ﱉ ﱊ ﱋ ﱌ (continues with Verse 2:2 + 2:3 start)
```

The source file **combined/split lines differently** than the layout DB.

---

## ✅ **WHY PAGE 604 WORKS**

Page 604 verification showed **perfect match** between layout DB and expected structure:
- 15 lines total
- 3 headers + 3 bismillah + 9 ayah lines
- Verses span correctly across ayah lines

This suggests **some pages in the source file are correct, others are not**.

---

## 🎯 **ROOT CAUSE**

**Verses span across multiple lines** in Mushaf layout:
- Verse 2:2 starts on Line 3, continues on Line 4
- Verse 113:3 starts on Line 7, continues on Line 8
- etc.

The source file used **different line breaking logic** than the official Mushaf layout.

---

## 💡 **SOLUTION: NEW APPROACH REQUIRED**

The cleaning script must **RECONSTRUCT** the text file from scratch using:

### **Data Sources:**
1. **Layout DB** (`qpc-v2-15-lines.db`) - Line structure (which words go on which line)
2. **Word DB** (`qpc-v2.db`) - Actual word text in QPC V2 glyph format

### **New Algorithm:**

```
FOR each page (1-604):
  
  1. Query layout DB for this page's structure:
     SELECT line_number, line_type, first_word_id, last_word_id
     FROM pages WHERE page_number = ?
     ORDER BY line_number
  
  2. FOR each line in layout:
     
     IF line_type == 'ayah':
       
       // Query word DB for words in range
       SELECT text FROM words
       WHERE id >= first_word_id AND id <= last_word_id
       ORDER BY id
       
       // Concatenate words with spaces
       line_text = words.join(' ')
       
       // Write to output file
       WRITE: "page_number,line_text"
     
     ELSE IF line_type == 'surah_name' OR 'basmallah':
       // Skip - don't write to output
       CONTINUE
  
  3. Output will have ONLY ayah lines, properly structured
```

---

## 📋 **UPDATED REQUIREMENTS**

### **Input:**
1. ❌ ~~`mushaf_v2_map.txt`~~ (source file - DO NOT USE)
2. ✅ `qpc-v2-15-lines.db` (layout structure)
3. ✅ `qpc-v2.db` (word text)

### **Output:**
- `mushaf_v2_map_CLEANED.txt`
- Format: `page_number,word1 word2 word3...`
- One line per ayah line from layout DB
- ~4,900-5,000 lines total (604 pages × avg 8 ayah lines per page)

---

## ✅ **ADVANTAGES OF NEW APPROACH**

1. **Guaranteed correct line structure** - matches official Mushaf layout exactly
2. **No source file inconsistencies** - builds from authoritative databases
3. **Handles verse spanning** - correctly splits verses across lines
4. **All special markers preserved** - QPC V2 glyphs maintained
5. **Reproducible** - same output every time from same databases

---

## ⚠️ **IMPLICATIONS**

1. **Original plan is obsolete** - cannot use source file
2. **Script complexity increases** - must query two databases per line
3. **Processing time increases** - database queries for every line
4. **But correctness is guaranteed** - no more mismatches

---

## 🎯 **NEXT STEPS**

1. ⏳ Get user approval for new approach
2. ⏳ Write new cleaning script specification
3. ⏳ Implement script using layout DB + word DB
4. ⏳ Verify output matches expected structure
5. ⏳ Deploy cleaned file

---

**AWAITING USER DECISION: Approve new reconstruction approach?**
