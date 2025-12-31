  Widget _buildMushafContent(int pageNum, Color textColor, QuranSurah mainSurah, Color gold, Color emerald, double refH, [double fontScale = 1.5]) {
    return FutureBuilder<MushafPageData>(
      future: MushafCoordinateService().getPageData(pageNum, Size(430, refH)),
      builder: (context, snapshotCoords) {
        if (!snapshotCoords.hasData) {
           return const Center(child: CircularProgressIndicator(color: Color(0xff574500)));
        }
        
        final pageData = snapshotCoords.data!;
        final highlights = pageData.highlights;
        final double gridLineHeight = refH / 15.0;

        return FutureBuilder<List<String>>(
          future: MushafTextService().getPageLines(pageNum),
          builder: (context, snapshotText) {
             final textLines = snapshotText.data ?? [];
             if (!snapshotText.hasData) return const SizedBox();

             return FutureBuilder<void>(
               future: _loadPageFont(pageNum),
               builder: (context, snapshotFont) {
                 
                 // ✅ FIX: Detect ALL Surahs on page from highlights (not from QuranPageService)
                 // This ensures we catch all Surahs on multi-Surah pages like 604
                 Map<int, int> surahStartLines = {};
                 for (var glyph in highlights) {
                   if (glyph.ayah == 1 && !surahStartLines.containsKey(glyph.surah)) {
                     surahStartLines[glyph.surah] = glyph.lineNumber;
                   }
                 }
                 
                 // Build Header Overlays using accurate Y positioning
                 List<Widget> headerOverlays = [];
                 
                 for (var entry in surahStartLines.entries) {
                    final int sID = entry.key;
                    final int ayah1Line = entry.value;
                    
                    final surahData = (sID == _currentSurahData?.id) ? mainSurah : _surahCache[sID];
                    if (surahData == null) continue;

                    // ✅ FIX: Calculate header and bismillah positions  
                    // Header is 2 lines above ayah 1, bismillah is 1 line above
                    final int headerLine = ayah1Line - 2;
                    final int bismillahLine = ayah1Line - 1;
                    
                    // Use grid-based positioning
                    double headerTop = (headerLine - 1) * gridLineHeight;
                    double bismillahTop = (bismillahLine - 1) * gridLineHeight;
                    
                    headerOverlays.add(
                      Positioned(
                        top: headerTop,
                        left: 0, 
                        right: 0,
                        child: SurahHeaderWidget(
                          surahId: sID,
                          surahNameArabic: "سُورَةُ ${kUthmaniSurahTitles[sID] ?? surahData.name}",
                          surahNameEnglish: surahData.transliteration,
                        ),
                      )
                    );

                    // ✅ FIX: Bismillah with WHITE color (not green)
                    if (sID != 1 && sID != 9) {
                      headerOverlays.add(
                        Positioned(
                          top: bismillahTop,
                          left: 0,
                          right: 0,
                          child: Text(
                            "﷽", // U+FDFD
                            style: const TextStyle(
                               fontFamily: 'QCF_BSML', 
                               fontSize: 56, 
                               color: Colors.white, // ✅ FIX: White, not green
                               height: 1.0,
                             ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      );
                    }
                 }

                 return Stack(
                    children: [
                       // Layer 1: Canvas (Text + Highlights)
                       GestureDetector(
                          onTapUp: (details) {
                            final tappedAyah = MushafCoordinateService().getAyahFromTouch(
                              details.localPosition, 
                              pageData.highlights
                            );
                            if (tappedAyah != null) {
                              _showAyahMenu(tappedAyah.surah, tappedAyah.ayah);
                            }
                          },
                          child: CustomPaint(
                            painter: MushafPagePainter(
                              highlights: pageData.highlights,
                              lineBounds: pageData.lineBounds,
                              textLines: textLines,
                              pageNumber: pageNum,
                              activeSurah: _controller.currentSurahId,
                              activeAyah: _controller.activeAyahId,
                              debugMode: false,
                              backgroundColor: Colors.transparent, 
                              textColor: textColor,
                            ),
                            size: Size(430, refH),
                          ),
                       ),
                       
                       // Layer 2: Headers (Overlays)
                       ...headerOverlays,
                    ],
                 );
               }
             );
          }
        );
      }
    );
  }
