#!/usr/bin/env python3
"""Replace Page 604 lines in mushaf_v2_map.txt with repaired lines"""

def main():
    # Read the original file
    with open(r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # Read the repaired lines
    with open(r'D:\solutions\MuslimLifeAI_demo\page_604_repaired.txt', 'r', encoding='utf-8') as f:
        repaired_lines = [line.strip() + '\n' for line in f.readlines()]
    
    # Replace Page 604 lines
    new_lines = []
    skip_604 = False
    
    for line in lines:
        if line.startswith('604,'):
            if not skip_604:
                # Add all repaired lines
                new_lines.extend(repaired_lines)
                skip_604 = True
            # Skip original 604 lines
        elif line.startswith('605,'):
            skip_604 = False
            new_lines.append(line)
        else:
            new_lines.append(line)
    
    # Write back
    with open(r'D:\solutions\MuslimLifeAI_demo\assets\quran\mushaf_v2_map.txt', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print('✅ Successfully replaced Page 604 lines in mushaf_v2_map.txt')
    print(f'   Replaced 15 lines with {len(repaired_lines)} repaired lines')

if __name__ == '__main__':
    main()
