$filePath = "lib\screens\quran_read_mode.dart"
$content = Get-Content -Path $filePath -Encoding UTF8 -Raw

# Find and replace the ayahCursor block
$oldBlock = @'
               String lineText = "";
                // 🛑 FIX: Only consume text from cache if this is an AYAH line
                if (lineData.lineType == 'ayah') {
                  if (ayahCursor < textLines.length) {
                    lineText = textLines[ayahCursor];
                    
                    ayahCursor++;
                  }
                } }
'@

$newBlock = @'
               String lineText = "";
                // 🛑 FIX: Only consume text from cache if this is an AYAH line
                if (lineData.lineType == 'ayah') {
                  if (ayahCursor < textLines.length) {
                    lineText = textLines[ayahCursor];
                    
                    // 🔍 DEBUG: Ayah sync diagnostic for pages 1 and 604
                    if (pageNum == 1 || pageNum == 604) {
                      final preview = lineText.length > 30 ? lineText.substring(0, 30) + '...' : lineText;
                      final willHighlight = _shouldHighlightLine(lineData, pageData, pageNum);
                      
                      print('📍 Page $pageNum | Line $lineNum | ayahCursor[$ayahCursor] | Type: ${lineData.lineType}');
                      print('   Text: $preview');
                      print('   Highlight: $willHighlight');
                      
                      if (willHighlight) {
                        print('   ✅ HIGHLIGHTED - Active Ayah: S${_controller.currentSurahId}:A${_controller.activeAyahId}');
                        
                        // Show what the database says about this line
                        final lineHighlights = pageData.highlights.where((h) => h.lineNumber == lineNum);
                        for (var h in lineHighlights) {
                          print('   Database: Line $lineNum contains S${h.surah}:A${h.ayah}');
                        }
                      }
                    }
                    
                    ayahCursor++;
                  }
                } else {
                  // Non-ayah lines (header, bismillah)
                  if (pageNum == 1 || pageNum == 604) {
                    print('📍 Page $pageNum | Line $lineNum | Type: ${lineData.lineType} | SKIPPED by ayahCursor');
                  }
                }
'@

$content = $content.Replace($oldBlock, $newBlock)
Set-Content -Path $filePath -Value $content -NoNewline -Encoding UTF8

Write-Host "Debug logging added successfully"
