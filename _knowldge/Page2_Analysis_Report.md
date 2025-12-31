# Page 2 Analysis Report - QPC V2 Database

**Date:** 2025-12-30  
**Status:** ✅ **ANALYSIS COMPLETE**

---

## 📊 **FINDINGS**

### **Layout Database (qpc-v2-15-lines.db) - Page 2 Structure:**

**Total: 8 lines**
1. **Line 1:** `surah_name` (Surah 2 header)
2. **Line 2:** `basmallah` (﷽)
3. **Line 3:** `ayah` - Words: `ﱁ ﱂ ﱃ ﱄ ﱅ ﱆﱇ ﱈﱉ ﱊ`
4. **Line 4:** `ayah` - Words: `ﱋ ﱌ ﱍ ﱎ ﱏ ﱐ ﱑ`
5. **Line 5:** `ayah` - Words: `ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ ﱙ`
6. **Line 6:** `ayah` - Words: `ﱚ ﱛ ﱜ ﱝ ﱞ ﱟ ﱠ ﱡ ﱢ`
7. **Line 7:** `ayah` - Words: `ﱣ ﱤ ﱥ ﱦ ﱧﱨ ﱩ`
8. **Line 8:** `ayah` - Words: `ﱪ ﱫ ﱬ`

**Summary:**
- Headers: 1
- Bismillah: 1
- Ayah lines: **6**

---

### **Source File (mushaf_v2_map.txt) - Page 2 Content:**

**Total: 5 lines**
1. `ﱁ ﱂ`
2. `ﱃ ﱄﱅ ﱆ ﱇ ﱈ ﱉ ﱊ ﱋ ﱌ`
3. `ﱍ ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ`
4. `ﱖ ﱗ ﱘ ﱙ ﱚ ﱛ ﱜ ﱝ ﱞ ﱟ ﱠ ﱡ ﱢ`
5. `ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ ﱪ ﱫ ﱬ`

---

## 🔍 **CRITICAL FINDING: Mismatch Detected**

**Expected (from layout DB):** 6 ayah lines  
**Actual (in source file):** 5 lines  
**Discrepancy:** **1 line missing**

---

## 💡 **POSSIBLE EXPLANATIONS:**

### **Theory 1: Source Line 1 is the Header (rendered as QCF glyph)**
- Source Line 1 (`ﱁ ﱂ`) = Header for Surah 2
- But this doesn't explain the overall count issue

### **Theory 2: Source File Uses Different Line Breaking**
- The source file may have combined some of the layout DB's ayah lines
- Looking at the glyphs, they flow continuously from source line 2-5
- But source line 1 (`ﱁ ﱂ`) appears isolated

### **Theory 3: Source File is Incomplete/Corrupted for Page 2**
- Missing 1 ayah line compared to layout DB

---

## 🎯 **KEY OBSERVATION:**

Looking at the **glyph flow**:
- **Layout Line 3** starts with: `ﱁ ﱂ ﱃ ﱄ ﱅ ﱆﱇ ﱈﱉ ﱊ`
- **Source Line 1** has: `ﱁ ﱂ`
- **Source Line 2** has: `ﱃ ﱄﱅ ﱆ ﱇ ﱈ ﱉ ﱊ ﱋ ﱌ`

It appears **Source Line 1** contains the **first 2 words** of what should be Layout Line 3!

The source file may have:
- **Split Layout Line 3** into 2 source lines (lines 1-2)
- Then merged other layout lines

---

## ❓ **QUESTIONS FOR USER:**

1. **Is Page 2 supposed to be special** (keep header/bismillah as ornamental glyphs)?
2. **Should the cleaning script:**
   - **Option A:** Keep all 5 source lines as-is (assume already cleaned)?
   - **Option B:** Try to remove lines based on layout DB (but how to map 5 to 8)?
   - **Option C:** Flag Page 2 as requiring manual review?

3. **Is the source file format correct for Page 2** or does it need reconstruction?

---

## 🚨 **RECOMMENDATION:**

**Page 2 requires special handling** due to:
1. QCF v2 ornamental glyph encoding
2. Line count mismatch (5 vs 6 expected)
3. Possible different line breaking than layout DB

**Suggested Approach:**
- Treat Page 2 as a **special case** in the cleaning script
- Either keep all 5 lines as-is, OR
- Get user clarification on correct structure

---

**AWAITING USER DECISION ON PAGE 2 HANDLING**
