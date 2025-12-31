The Programmatic Mushaf: Engineering a Vector-Based Quranic Rendering Engine in Flutter
1. Introduction: The Intersection of Theology and Technology
The digitization of the Holy Quran represents one of the most rigorous challenges in the field of electronic text representation. Unlike secular literature, where the primary objective is legibility and reflowability across various device form factors, the digital representation of the Quran—specifically the widely accepted Madani Mushaf printed by the King Fahd Glorious Quran Printing Complex (KFGQPC)—demands an absolute adherence to a fixed visual layout. This constraint is not merely aesthetic but theological and mnemonic; the preservation of the "Uthmanic Script" involves specific calligraphic rules, ligatures, and stop signs (waqf) that maintain the integrity of the recitation and the memorization (Hifz) process. For millions of Muslims, the "page" is a cognitive unit of memorization, where a specific verse's location—top right, center, or bottom left—is encoded in the reader's spatial memory.
For over a decade, the mobile development community has addressed this requirement primarily through rasterization. Applications such as Quran Android and Ayah have traditionally relied on high-resolution scanned images of the KFGQPC pages.1 While this approach guarantees visual fidelity, it imposes severe technical limitations: substantial application bundle sizes (often exceeding 100-200MB for high-quality assets), pixelation at extreme zoom levels, and a fundamental disconnect between the visual pixels and the semantic text data. The text on the screen is, to the computer, merely a picture, necessitating complex auxiliary databases to overlay interactivity.
The current frontier of Quranic software engineering seeks to transcend these raster-based limitations by implementing a Programmatic, Vector-Based Architecture. This approach utilizes the raw coordinate data, vector glyphs, and font technologies provided by KFGQPC to reconstruct the Mushaf page dynamically on the device's Graphics Processing Unit (GPU). By shifting from static images to dynamic rendering, developers can achieve infinite scalability, significantly reduced file sizes, and intrinsic accessibility, all while maintaining the non-negotiable "100% Layout" fidelity.
This report serves as an exhaustive architectural blueprint for implementing this paradigm using the Flutter framework. It synthesizes technical research on rendering engines 3, proprietary data schemas 5, and advanced mobile graphics techniques 7 to define the standard for the next generation of Quranic applications.
2. Rendering Paradigms: From Raster to Immediate Mode
To appreciate the necessity and complexity of a programmatic solution, one must first deconstruct the evolution of digital Quranic rendering. The choice of rendering engine is not a trivial implementation detail; it dictates the application's memory footprint, battery consumption, accessibility profile, and long-term maintainability.
2.1 The Legacy of Rasterization
The earliest and most persistent method for displaying the Madani Mushaf is the "Raster Page" model. In this architecture, each of the 604 pages of the Quran is stored as a pre-rendered bitmap (JPEG or PNG).
Fidelity Assurance: The primary advantage of this approach is risk mitigation. Because the image is a digital photograph of the physical page approved by the KFGQPC scholars, there is zero risk of "rendering errors." No font engine glitch can displace a diacritic (fatha or kasra) because the diacritic is burned into the pixels.
The "Night Mode" Problem: A significant drawback, however, is the rigidity of bitmaps. Implementing a "Dark Mode"—essential for reading in low-light environments—requires one of two suboptimal solutions: digitally inverting the colors, which often results in a jarring, unnatural aesthetic, or downloading an entirely separate set of 604 images pre-colored for night reading, thereby doubling the storage requirement.
Zoom Degradation: Furthermore, raster images suffer from finite resolution. As users pinch-to-zoom to inspect intricate calligraphy or tajweed rules, the text becomes blurry or pixelated unless exceptionally large source files are used, which in turn degrades device performance and consumes storage.3
2.2 The Vector Alternative: SVG vs. Canvas
As the industry moves toward vector graphics, two primary technologies emerge: Scalable Vector Graphics (SVG) and Immediate Mode Rendering (Canvas).
2.2.1 Scalable Vector Graphics (SVG)
SVG is an XML-based markup language that describes 2D graphics. In the context of web and some mobile frameworks, SVG is handled via the Document Object Model (DOM).
The Object Overhead: Research indicates that while SVG offers perfect scalability, its reliance on the DOM is a fatal flaw for complex Quranic pages.3 A single page of the Quran may contain hundreds of intricate diacritics, stops, and ligatures. If each of these is represented as a distinct DOM node or SVG element, the memory overhead becomes massive. The browser or rendering engine must maintain the state, event listeners, and styling computation for thousands of objects simultaneously.
Mobile Performance: On mobile devices, rendering complex SVGs with thousands of paths can lead to dropped frames during scrolling. The "Retained Mode" nature of SVG means the system "remembers" every shape, which is unnecessary for a static page that only changes when the user turns the page.4
2.2.2 Flutter Canvas (Immediate Mode)
The optimal solution, and the focus of this report, is the Canvas API, specifically within the Flutter framework. Flutter’s rendering engine (historically Skia, transitioning to Impeller) allows for "Immediate Mode" rendering.7
The Mechanism: In Immediate Mode, the application issues drawing commands frame-by-frame (e.g., "draw this glyph at x,y"). Once the command is issued, the engine forgets the object. It does not retain a tree of objects. This allows the application to loop through thousands of glyph coordinates and paint them onto a single surface in milliseconds with minimal memory overhead.8
Coordinate Precision: Flutter’s CustomPainter provides low-level access to the GPU. This is essential for the "100% Layout" requirement. We are not asking a text layout engine to "write a paragraph"; we are commanding the GPU to "place Glyph X at Coordinate Y." This distinction is critical. Standard text widgets use shaping engines (like HarfBuzz) that might subtly adjust kerning or line breaking based on the OS version or user settings.9 To guarantee the KFGQPC layout, we must bypass standard text layout and treat text as geometry.10



2.3 The "100% Layout" Constraint Analysis
The user query specifies "100% KFGQPC Quran Layout." It is imperative to define what this entails technically. The Madani Mushaf is a fixed-format document.
Fixed Page Boundaries: Each page begins and ends with specific words. For example, Page 5 always begins with "Ula'ika" (2:5) and ends with "Al-Muflihoon" (2:5).
Fixed Line Breaks: There are exactly 15 lines per page. Line 3 of Page 5 must end at a specific character.
Justification: The text is fully justified. In Arabic calligraphy, justification is not achieved by merely widening spaces (as in English) but by extending the connecting strokes between letters (Kashida) or using wider alternate glyph forms for specific letters.
Standard Text widgets in Android (TextView), iOS (UILabel), or Flutter (Text) cannot guarantee this. They rely on dynamic font shaping. If a user changes their system font size, or if the OS updates its shaping logic, the words will reflow, breaking the "100% Layout" rule. Therefore, the Programmatic Mushaf cannot rely on the content of the text (the Unicode characters) alone; it must rely on the spatial data (the physical coordinates) of the text. We do not render "sentences"; we render "maps of glyphs."
3. The Data Substrate: Engineering the KFGQPC Ecosystem
The foundation of any programmatic rendering engine is the data it consumes. The KFGQPC has released a sophisticated ecosystem of fonts, databases, and metadata that serves as the raw material for this reconstruction. A robust data engineering pipeline is required to ingest, normalize, and serve this data to the mobile client.
3.1 The "Page-Specific" Font Architecture (QCF v1 vs. v2)
The Quran Complex Fonts (QCF) are unique in the world of typography. To achieve the hand-written look where the shape of a letter depends heavily on its position in the line and the desired width of the word, KFGQPC created a system where each page of the Quran utilizes a specific subset of glyphs.11
3.1.1 QCF Version 1 (The "Classic" Approach)
In the QCF v1 system, there is a distinct font file for each page of the Quran (e.g., QCF_P001.ttf, QCF_P002.ttf... QCF_P604.ttf).
Mechanism: The "text" for Page 1 is not standard Unicode Arabic. Instead, it is a sequence of code points in the Unicode Private Use Area (PUA). For instance, the code point 0xE001 in font file QCF_P005.ttf might represent a specific wide ligature of "Allah", while the same code point 0xE001 in QCF_P006.ttf might represent the word "Yalamoon".
Implication: The application must implement a dynamic asset loading system. It cannot simply load one font. As the user swipes from Page 4 to Page 5, the app must unload QCF_P004.ttf and load QCF_P005.ttf. This requires careful memory management to prevent the "Out of Memory" (OOM) errors common in mobile development when handling many typeface assets.
3.1.2 QCF Version 2 and the "Smart Mushaf" Font
Later iterations (v2 and the v4 "Smart Mushaf") attempted to consolidate these glyphs into fewer files or a single massive font file using advanced OpenType features.
Trade-off: While a single font file simplifies asset management, it shifts the complexity to the rendering engine. The engine must support advanced OpenType substitution tables to select the correct glyph variant for the "100% Layout." For a "Coordinate-Driven" approach, the v1 (Page-Specific) or v2 systems are often preferred because the one-to-one mapping between the glyph code in the database and the glyph shape in the font file is more direct and easier to validate programmatically.13
3.2 The Glyph Coordinate Database (The "Rosetta Stone")
To enable interactivity—such as highlighting a specific word when tapped or syncing with audio—the application needs to know the bounding box of every glyph. Since we are drawing these glyphs on a Canvas, the system has no intrinsic knowledge of "words." We must provide this spatial intelligence.
Research snippet 5 reveals the schema used by leading Android implementations, such as the open-source Quran Android project. The core entity is the glyphs table (often found in ayah_info.db):
Column Name
Type
Description
glyph_id
INTEGER
Primary Key. Unique identifier for the glyph occurrence.
page_number
INTEGER
The physical page number (1-604). Indexed for fast retrieval.
line_number
INTEGER
The line number (1-15) on the page.
sura_number
INTEGER
The theological Chapter ID (1-114).
ayah_number
INTEGER
The theological Verse ID within the Surah.
position
INTEGER
The word index within the Ayah (1st word, 2nd word, etc.).
min_x
INTEGER
The left-most coordinate of the glyph's bounding box.
max_x
INTEGER
The right-most coordinate of the glyph's bounding box.
min_y
INTEGER
The top-most coordinate of the glyph's bounding box.
max_y
INTEGER
The bottom-most coordinate of the glyph's bounding box.

Insight: This table effectively maps the Theological Structure (Surah/Ayah) to the Physical Structure (Page/Line/X,Y). This mapping is the engine of the entire application. When a user taps at screen coordinate $(250, 400)$, the app queries this table (after coordinate transformation) to find which ayah_number corresponds to that physical location.5
3.3 Audio Synchronization Data
A key requirement for modern Quran apps is "Word-by-Word" highlighting during audio playback. This requires a third dataset that links the temporal domain (Audio Time) to the theological domain (Surah/Ayah/Word).
The standard format for this is a JSON structure, often derived from the EveryAyah project or the Quran.com API.16
Schema Analysis:

JSON


{
  "surah": 1,
  "ayah": 1,
  "segments": [word_start_index, word_end_index, start_msec, end_msec],
    ,   // 1st word, from 0ms to 500ms
     // 2nd word, from 500ms to 1200ms
  ]
}


Data Linkage: The word_start_index in the JSON corresponds to the position column in the SQLite glyphs table.
The Synchronization Logic Chain:
Audio Player reports currentPosition = 750ms.
Logic Layer scans JSON: 750ms falls between 500 and 1200.
Identified Word: Word #2.
Database Query: SELECT min_x, min_y, max_x, max_y FROM glyphs WHERE sura=1 AND ayah=1 AND position=2.
Canvas Update: Draw a translucent rectangle at the returned coordinates.



4. Flutter Implementation Core: The CustomPainter Architecture
Having established the data foundation, we turn to the specific implementation within the Flutter framework. The core of this solution is the CustomPainter class, which allows for highly optimized, low-level drawing operations.
4.1 The Rendering Pipeline
The application’s main view is a PageView.builder where each page is a CustomPaint widget. The rendering logic is encapsulated in a class we shall denote as MushafPagePainter.
4.1.1 The paint Lifecycle
The paint(Canvas canvas, Size size) method is invoked whenever the render object needs to update. The drawing order is critical for correct layering (The "Painter's Algorithm").7
Layer 0: The Background:
The canvas is first filled with the page background. This can be a solid off-white color (to reduce eye strain) or a tiled texture image representing paper grain.
Dart
canvas.drawRect(rect, Paint()..color = paperColor);


Layer 1: The Transformation Matrix (Coordinate Mapping):
The coordinates in the SQLite database are stored in a "Reference Space"—typically a normalized grid (e.g., 1000 units wide by 1600 units high). The physical device screen, however, has variable dimensions (e.g., 400x800 logical pixels on a phone, 1024x1366 on an iPad).
The Painter must calculate and apply a scaling matrix before drawing any content.
Algorithmic Transformation Pipeline:
The transformation of a point $P_{db}(x, y)$ from the database to a point $P_{screen}(x, y)$ on the screen involves three distinct operations: Normalization, Scaling, and Translation.
Variable
Definition
Source
$W_{ref}, H_{ref}$
Reference Width/Height of the Coordinate System
Metadata (e.g., 1000 x 1600)
$W_{screen}, H_{screen}$
Current Device Screen Width/Height
Flutter MediaQuery
$S$
Scale Factor
Calculated (Fit Width)
$T_y$
Vertical Translation (Centering)
Calculated




    **The Logic:**
    1.  **Calculate Scale Factor ($S$):** For a standard vertical scrolling app or a "Fit Width" view:
        $$S = \frac{W_{screen}}{W_{ref}}$$
    2.  **Calculate Rendered Height:**
        $$H_{rendered} = H_{ref} \times S$$
    3.  **Calculate Vertical Centering Offset ($T_y$):** If the screen is taller than the page (e.g., on a tall modern phone), we center the page vertically.
        $$T_y = \frac{H_{screen} - H_{rendered}}{2}$$
    4.  **Apply to Canvas:**
        The Flutter Canvas API allows us to set this matrix once, and all subsequent drawing commands will be automatically transformed.
        ```dart
        canvas.translate(0, T_y);
        canvas.scale(S);
        ```


Layer 2: The Highlight Layer (Dynamic):
Before drawing the text, we draw the highlights. This ensures the text renders on top of the colored background, keeping the black ink crisp.
The Painter iterates through the list of "Active Glyph IDs" (derived from the current user selection or audio playback). For each active glyph, it retrieves the coordinates (min_x, min_y, max_x, max_y) from the pre-loaded data and draws a rectangle or path.
Optimization: Using a Paint with a blend mode (like BlendMode.multiply) can simulate the look of a highlighter marker soaking into the paper.18
Layer 3: The Text Layer (Static):
Finally, the text is drawn. Since we are using the KFGQPC fonts which are designed to line up perfectly, we can often construct a TextSpan for each line or the whole page.
Text vs. Glyphs: While canvas.drawParagraph is standard, for absolute 100% fidelity, some developers prefer iterating through the glyphs and using canvas.drawPath if they have converted the font to SVG paths. However, using the native font rendering with the correct letter-spacing usually yields sharper results on high-DPI screens.3
4.2 Handling User Input: The Inverse Matrix
One of the most complex implementation details is "Hit Testing"—determining which word the user tapped.
The GestureDetector provides the tap location in Screen Coordinates $(X_{screen}, Y_{screen})$. However, our database contains Reference Coordinates.
To resolve this, we must apply the Inverse of the transformation matrix used in the painting step.15
The Algorithm:
Capture Tap: User taps at $(200, 450)$.
Untranslate: Remove the vertical offset.

$$Y' = Y_{screen} - T_y$$
Unscale: Divide by the scale factor.

$$X_{ref} = \frac{X_{screen}}{S}$$
$$Y_{ref} = \frac{Y'}{S}$$
Query: Now that we have $(X_{ref}, Y_{ref})$, we perform a spatial query on the in-memory glyph list:
Find Glyph where: $min\_x \le X_{ref} \le max\_x$ AND $min\_y \le Y_{ref} \le max\_y$.
This logic must be extremely efficient. Instead of iterating through all 500+ glyphs on a page, developers should use a spatial indexing structure (like a Quadtree or a simple grid bucket system) to narrow down the search space to a few candidates instantly.
4.3 State Management for Audio Sync
Synchronizing the highlight with audio playback requires a reactive state management approach. The update frequency is high (potentially multiple updates per second), so minimizing widget rebuilds is crucial.
Stream Architecture: The Audio Player emits a stream of Duration (current timestamp).
Transformer Logic: A business logic component (BLoC or Riverpod Provider) listens to this stream. It holds the JSON timing data in memory. On every tick, it performs a binary search on the timing segments to find the active word index.
State Emission: If the active word index changes, the BLoC emits a new state: HighlightState(page: 5, glyphIds: ).
Scoped Rebuild: The CustomPaint widget listens to this state. Crucially, we separate the "Highlight Painter" from the "Text Painter" to avoid redrawing the expensive text layer on every audio tick.



5. Advanced Interactive Features
Moving beyond mere replication of the paper page, the programmatic approach unlocks digital-native capabilities.
5.1 Morphological Highlighting
In a raster-based app, highlighting a verse often involves drawing a simple semi-transparent rectangle over the area. Because Arabic lines are dense, a simple rectangle for Line 3 often obscures the descenders of letters on Line 2 or the ascenders of letters on Line 4.
With access to the glyph coordinates, we can implement Contour Highlighting.
Union of Rectangles: The database gives us a bounding box for each word. An Ayah is composed of multiple words, often spanning multiple lines.
Path Operations: We can programmatically create a Path that is the geometric union of all the individual word rectangles.
Smoothing: We can then apply a "corner rounding" algorithm to this complex path. The result is a highlight that "hugs" the text organically, flowing around line breaks and avoiding overlap with adjacent lines. This provides a polished, high-end feel that distinguishes the app from basic image viewers.15
5.2 Accessibility: The Semantic Bridge
One of the most critical advantages of the programmatic approach is accessibility for the visually impaired.
The Problem: To a screen reader (like Android's TalkBack or iOS VoiceOver), a CustomPaint canvas is a black box. It is just a picture. The screen reader does not know there is text inside.
The Solution: Flutter’s SemanticsBuilder.7
The CustomPainter class allows us to override the semanticsBuilder callback. In this method, we can define a list of CustomPainterSemantics objects.
We iterate through our glyph database. For each Ayah, we define a Rect (the bounding box of the ayah) and associate it with a SemanticsProperties object containing the text of the Ayah (e.g., "Surah Al-Baqarah, Verse 5").
Result: When a blind user explores the screen by touch, the system detects these invisible semantic rectangles. When their finger crosses the coordinate of an Ayah, the device speaks the verse number and content. This effectively bridges the gap between the visual "Uthmanic Script" and the digital accessibility tree, making the Holy Quran accessible to all.
6. Performance Optimization
Rendering complex vector graphics on mobile devices, especially low-end Android phones, requires rigorous optimization.
6.1 Repaint Boundaries and Layering
As visualized in Section 4, the use of RepaintBoundary is non-negotiable.
Static Layer: The background and the black text do not change often (only when the user flips the page). We wrap this CustomPaint in a RepaintBoundary. This tells the Flutter engine to cache the rasterized output of this layer as a texture.
Dynamic Layer: The highlighting layer changes frequently (during audio sync or user selection). This is placed in a separate CustomPaint on top of the static layer.
Benefit: When the audio highlights the next word, the engine only repaints the lightweight highlight layer. It composites this with the cached image of the text layer. This reduces the GPU load significantly, maintaining a smooth 60fps even during complex animations.18
6.2 Efficient Asset Management
Loading 604 font files (for QCF v1) would consume hundreds of megabytes of RAM if done simultaneously.
Lazy Loading: The QuranPageController must implement a "Sliding Window" strategy. It should only hold the font assets for the current page, the previous page, and the next page in memory.
Resource Disposal: As the user advances to Page 10, the assets for Page 8 must be explicitly disposed of to free up native heap memory.
7. Conclusion
The transition from raster-based to coordinate-driven vector rendering represents a definitive maturation in Quranic software engineering. By treating the Madani Mushaf not as a series of static images but as a structured database of glyphs and coordinates, developers can achieve the holy grail of digital text: absolute visual fidelity to the KFGQPC standard combined with the infinite flexibility of modern software.
This report has outlined the architectural requirements for such a system: the ingestion of the unique QCF font ecosystem, the utilization of SQLite for spatial mapping, and the implementation of a layered CustomPainter pipeline in Flutter. While the engineering effort required to build the "Programmatic Mushaf" is significantly higher than legacy image-based approaches, the resulting benefits—reduced app size, crisp typography at any scale, semantic accessibility, and granular interactivity—justify the investment. This architecture ensures that the digital preservation of the Quran keeps pace with the evolving expectations of the modern user, serving the text with the precision and dignity it demands.
Works cited
Al Quran (Tafsir & by Word) - App Store - Apple, accessed December 27, 2025, https://apps.apple.com/us/app/al-quran-tafsir-by-word/id1437038111
quran/quran_android: a quran reading application for android - GitHub, accessed December 27, 2025, https://github.com/quran/quran_android
SVG versus Canvas: Which technology to choose and why? - JointJS, accessed December 27, 2025, https://www.jointjs.com/blog/svg-versus-canvas
SVG vs. Canvas vs. WebGL: Rendering Choice for Data Visualization - Dev3lop, accessed December 27, 2025, https://dev3lop.com/svg-vs-canvas-vs-webgl-rendering-choice-for-data-visualization/
scripts to detect ayah markers from quran images - GitHub, accessed December 27, 2025, https://github.com/quran/ayah-detection
By Page | QuranFoundation API Documentation Portal, accessed December 27, 2025, https://api-docs.quran.foundation/docs/content_apis_versioned/4.0.0/verses-by-page-number/
Mastering CustomPainter in Flutter: From SVGs to Racetracks - Very Good Ventures, accessed December 27, 2025, https://www.verygood.ventures/blog/mastering-custompainter-in-flutter-from-svgs-to-racetracks
Mastering Flutter CustomPainter: The Complete Developer's Guide | by Banatube - Medium, accessed December 27, 2025, https://banatube.medium.com/mastering-flutter-custompainter-the-complete-developers-guide-f9b1e8575e6c
[AskJS] Why does GitHub use Puppeteer instead of SVG or Canvas for rendering repository previews? : r/javascript - Reddit, accessed December 27, 2025, https://www.reddit.com/r/javascript/comments/oym8a5/askjs_why_does_github_use_puppeteer_instead_of/
Using SVG for text · Issue #582 · quran/quran_android - GitHub, accessed December 27, 2025, https://github.com/quran/quran_android/issues/582
fonts.json - fawazahmed0/quran-api - GitHub, accessed December 27, 2025, https://github.com/fawazahmed0/quran-api/blob/1/fonts.json
Quran font "KFGQPC Uthmanic" numbers of the ayah [closed] - Stack Overflow, accessed December 27, 2025, https://stackoverflow.com/questions/48254737/quran-font-kfgqpc-uthmanic-numbers-of-the-ayah
thetruetruth/quran-data-kfgqpc: Quran Unicode Uthmanic Font Data arabic text and font from KFGQPC for developer - GitHub, accessed December 27, 2025, https://github.com/thetruetruth/quran-data-kfgqpc
Automatic Pronunciation Error Detection and Correction of the Holy Quran's Learners Using Deep Learning - ResearchGate, accessed December 27, 2025, https://www.researchgate.net/publication/395214532_Automatic_Pronunciation_Error_Detection_and_Correction_of_the_Holy_Quran's_Learners_Using_Deep_Learning
Question about how a verse gets highlighted · Issue #888 · quran/quran_android - GitHub, accessed December 27, 2025, https://github.com/quran/quran_android/issues/888
cpfair/quran-align: Word-accurate timestamps for Qur'anic audio. - GitHub, accessed December 27, 2025, https://github.com/cpfair/quran-align
@kmaslesa/holy-quran-word-by-word-full-data - NPM, accessed December 27, 2025, https://www.npmjs.com/package/%40kmaslesa%2Fholy-quran-word-by-word-full-data
CustomPainter class - rendering library - Dart API - Flutter, accessed December 27, 2025, https://api.flutter.dev/flutter/rendering/CustomPainter-class.html
NSAttributedString: letters interference with arabic font - Stack Overflow, accessed December 27, 2025, https://stackoverflow.com/questions/32891709/nsattributedstring-letters-interference-with-arabic-font
Ayah highlight · Issue #1364 · quran/quran_android - GitHub, accessed December 27, 2025, https://github.com/quran/quran_android/issues/1364
