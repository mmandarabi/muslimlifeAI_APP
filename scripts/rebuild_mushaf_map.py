import sqlite3
import os

print("\n🔧 MUSHAF MAP RESTRUCTURING TOOL")
print("=" * 80)
print("Goal: Align text line distribution with database glyph distribution")
print("=" * 80)

# Paths
original_map_path = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt'
new_map_path = r'd:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map_NEW.txt'
db_path = r'd:\solutions\MuslimLifeAI_demo\assets\quran\databases\ayahinfo.db'

# Load original text file
print("\n📖 Loading original mushaf_v2_map.txt...")
with open(original_map_path, 'r', encoding='utf-8') as f:
    all_lines = f.readlines()

# Open database
print("📊 Opening ayahinfo.db...")
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Output buffer
new_content = []

processed_pages = 0
restructured_pages = 0

print("\n🔄 Processing all 604 pages...\n")

for page in range(1, 605):
    # ========================================
    # STEP 1: Extract original tokens for this page
    # ========================================
    page_prefix = f"# Page {page}"
    
    # Find start index
    start_idx = None
    for i, line in enumerate(all_lines):
        if line.strip() == page_prefix:
            start_idx = i
            break
    
    if start_idx is None:
        print(f"⚠️  Page {page} not found in original file!")
        continue

    # Collect all tokens from original page (flattened)
    all_tokens = []
    for i in range(start_idx + 1, len(all_lines)):
        line = all_lines[i].strip()
        if line.startswith('# Page'):  # Next page
            break
        if not line:
            continue
        
        # Tokenize and add to flat list
        line_tokens = [t for t in line.split(' ') if t.strip()]
        all_tokens.extend(line_tokens)

    # ========================================
    # STEP 2: Get DB line profile for this page
    # ========================================
    cursor.execute("""
        SELECT line_number
        FROM glyphs
        WHERE page_number = ?
        ORDER BY line_number ASC, position ASC
    """, (page,))
    
    # Count glyphs per line
    line_glyph_counts = {}
    for row in cursor.fetchall():
        line_num = row[0]
        if line_num > 0:
            line_glyph_counts[line_num] = line_glyph_counts.get(line_num, 0) + 1

    # Get sorted list of DB lines
    db_lines = sorted(line_glyph_counts.keys())

    # ========================================
    # STEP 3: Redistribute tokens to match DB lines
    # ========================================
    new_line_distribution = {}
    token_index = 0

    for db_line in db_lines:
        glyph_count = line_glyph_counts[db_line]
        tokens_for_line = []
        
        # Assign next N tokens to this line
        for i in range(glyph_count):
            if token_index < len(all_tokens):
                tokens_for_line.append(all_tokens[token_index])
                token_index += 1
        
        new_line_distribution[db_line] = tokens_for_line

    # Track if restructuring occurred
    if len(all_tokens) != token_index:
        restructured_pages += 1

    # ========================================
    # STEP 4: Write to new file with ALL 15 lines
    # ========================================
    new_content.append(f"# Page {page}\n")
    
    for line in range(1, 16):
        if line in new_line_distribution:
            # Line has content
            line_content = ' '.join(new_line_distribution[line])
            new_content.append(line_content + '\n')
        else:
            # Empty line (DB has no glyphs for this line)
            new_content.append('\n')

    processed_pages += 1
    
    if page % 100 == 0:
        print(f"✅ Processed {page} pages...")

conn.close()

# ========================================
# STEP 5: Write new file
# ========================================
print("\n💾 Writing new mushaf_v2_map_NEW.txt...")
with open(new_map_path, 'w', encoding='utf-8') as f:
    f.writelines(new_content)

print("\n" + "=" * 80)
print("📊 RESTRUCTURING COMPLETE:")
print("=" * 80)
print(f"Total pages processed: {processed_pages} / 604")
print(f"Pages restructured: {restructured_pages}")
print(f"Output file: {new_map_path}")
print("")
print("✅ Next steps:")
print("1. Review the new file")
print("2. Backup original: mushaf_v2_map.txt → mushaf_v2_map_BACKUP.txt")
print("3. Replace: mushaf_v2_map_NEW.txt → mushaf_v2_map.txt")
print("4. Run verification audit")
print("=" * 80)
