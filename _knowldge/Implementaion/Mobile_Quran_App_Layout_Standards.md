# **Technical Specification and Architectural Blueprint for Professional Mobile Mushaf Applications**

## **1\. Executive Summary: The Imperative of Digital Orthographic Preservation**

The transition of the Holy Quran from physical manuscripts to digital interfaces represents one of the most significant technical challenges in modern Islamic software engineering. Unlike conventional e-book applications that rely on reflowable text engines (such as EPUB or standard HTML rendering), a "Professional Mushaf" application demands a fundamentally different approach: the absolute preservation of the *Mushaf Al-Madinah* layout. This layout, standardized by the King Fahd Glorious Quran Printing Complex (KFGQPC), particularly the 15-line *Hafs* narration printed in 1405H and 1421H, has become the cognitive baseline for millions of memorizers (*Huffaz*) worldwide. Any deviation in line breaks, word positioning, or page boundaries disrupts the mnemonic spatial mapping essential for recitation and memorization.

Consequently, the development of a mobile Quran application that rivals industry leaders—such as Quran.com, Tarteel AI, and Muslim Pro—requires a shift in perspective from "text rendering" to "digital preservation." The objective is not merely to display the text of the Quran but to replicate the physical experience of the printed page with pixel-perfect fidelity while overlaying modern interactive capabilities. This report serves as a comprehensive technical manual for achieving this standard. It synthesizes data from open-source repositories, font engineering specifications, and pixel-level analysis of existing market leaders to provide a definitive guide on layout dimensions, typographic stacks, and rendering architectures.

The analysis reveals that the most robust implementations utilize a "Hybrid Rendering Stack." This architecture decouples the visual presentation (often handled via high-resolution raster images or specialized page-specific vector fonts) from the interaction logic (handled via invisible coordinate meshes). By adopting this layered approach, developers can ensure that the visual output remains immutable and identical to the printed source, while the application remains responsive to touch, audio synchronization, and search queries. This document details the specific dimensions, coordinate database schemas, and Flutter-based code patterns required to execute this architecture with the precision expected by the global Muslim community.

## **2\. The Geometry of the Holy Page: Layout Dimensions and Grid Systems**

The visual identity of a professional Mushaf is governed by the "15-Line Standard." This layout is not an arbitrary design choice but a rigid grid system that dictates the flow of divine text. In this standard, every page (with the exception of the first two pages, Surah Al-Fatihah and the beginning of Al-Baqarah) begins with the start of a verse and ends with the completion of a verse. This "Ayah-ending" property is critical for the visual continuity of the text.

### **2.1 The Aspect Ratio and Physical Proportions**

To replicate the *Mushaf Al-Madinah* digitally, one must start with its physical dimensions. The medium-sized printed Mushaf typically measures approximately 14cm in width and 20cm in height.1 This yields a physical aspect ratio of roughly **0.7:1** (width to height). In the digital domain, maintaining this aspect ratio is crucial to prevent the distortion of the calligraphy.

When translating this to mobile pixels, developers must account for the varying pixel densities of modern screens. Analysis of image assets from the quran\_android repository—the open-source benchmark for this domain—reveals that developers utilize specific width buckets to support a wide range of devices without compromising quality. The standard asset widths identified are **1024px**, **1260px**, and **1920px**.4 These widths are paired with heights that preserve the \~0.7 aspect ratio, resulting in page heights often utilized in calculation references around **1050px** for web-based CSS queries or scaled equivalents on mobile.6

The choice of resolution has profound implications for the application's performance and storage footprint. A width of 1024px is generally sufficient for standard phone densities (xxhdpi), while 1920px width assets are reserved for high-end tablets (iPad Pro, Android Tablets) where the user might zoom in to examine the intricacies of the calligraphy. The layout engine must effectively "letterbox" or "fit-width" these images within the device viewport, filling any remaining vertical space with a background texture that matches the paper color of the Mushaf.

### **2.2 Vertical Distribution Guidelines (The 15-Line Grid)**

The vertical rhythm of a professional Mushaf page is strictly regimented. Unlike Western typography, where line height (leading) can be adjusted for aesthetic preference, the 15-line Mushaf requires a fixed coordinate system to ensure that all 15 lines fit exactly within the "content block" of the page.

If we normalize the page height to a standard unit (e.g., 100%), the distribution of vertical space follows a consistent pattern derived from the KFGQPC standards:

* **Top Margin & Header Area (10% \- 12%):** This section contains the ornamental frame that houses the *Surah* name on the right and the *Juz* (Part) number on the left.7 The vertical space here is generous to allow for the decorative headers, which are often stylized in the *Thuluth* script, contrasting with the *Naskh* script of the body text.8  
* **Content Block (75% \- 80%):** This is the heart of the page, containing exactly 15 lines of Quranic text. The lines are justified to the full width of the text block. The "line height" in this context is not a CSS property but a calculated division of the available vertical space. For a 1920px height reference image, the content block occupies approximately 1590px, resulting in a per-line height allocation of roughly **106px**.  
* **Bottom Margin & Footer (8% \- 10%):** This area is reserved for the page number, which is centered and often enclosed in a decorative bracket or rosette.

The following table provides specific pixel estimates based on the analysis of high-definition assets used in production environments. These values serve as a baseline for configuring the rendering engine's layout constraints.

### **2.3 Handling the 1050px Page Height Distribution**

The specific mention of **1050px** in the query references a common baseline height used in web-based rendering engines (like Quran.com's legacy viewers) and CSS media queries.6 At this scale, the distribution requires precise sub-pixel rendering or rounding strategies to prevent blurring.

When mapping the 15 lines to a 1050px height:

* The **Header** occupies approximately **120px**.  
* The **Footer** occupies approximately **80px**.  
* The remaining **850px** is allocated to the text body.  
* Dividing 850px by 15 lines yields a line height of **56.66px**.

Since fractional pixels can cause rendering artifacts, professional implementations often use a "safe zone" approach. The text is centered within the 850px block, and the font size is adjusted so that the ascenders and descenders of the Arabic script do not clash. The actual *glyph* size might be smaller than the allocated line height to provide natural whitespace (leading) without using explicit padding properties that could disrupt the grid.

## **3\. Typography and Font Engineering: The QCF Standard**

Achieving the "Professional" aesthetic relies heavily on the correct selection and implementation of fonts. Standard system fonts (like Arial or even generic Naskh) are wholly inadequate for a Mushaf application because they lack the specialized ligatures required for the dense, vertically stacked diacritics of the Quranic script. The research identifies two distinct approaches used by market leaders: the **Image-Based Approach** (using baked raster images) and the **Font-Based Approach** (using specialized vector fonts).

### **3.1 Primary Font Families**

The King Fahd Glorious Quran Printing Complex (KFGQPC) is the sole authority on the digital typography used in these applications. They have released several generations of digital assets.

#### **3.1.1 KFGQPC Uthman Taha Naskh**

This typeface replicates the handwriting of the renowned calligrapher Uthman Taha, who penned the Madani Mushaf.9 While visually accurate, the standard TrueType/OpenType version of this font faces challenges in mobile rendering engines. The complexity of Quranic diacritics—where a letter might have a *Shadda*, a *Fatha*, and a *Waqf* (stop sign) mark stacked vertically—often exceeds the positioning capabilities of standard shaping engines like HarfBuzz when running on constrained mobile frameworks.11 This can lead to "clashing," where marks overlap with the line above.

#### **3.1.2 Quran Complex Fonts (QCF) \- The Page-Specific Innovation**

To overcome the limitations of standard fonts, the KFGQPC and developers at Quran.com adopted a "Page-Specific Font" strategy. In this system, the "font" for Page 604 does not contain the entire Arabic alphabet. Instead, it contains glyphs specific to Page 604, where entire words or complex ligatures are pre-shaped and assigned to specific Unicode Private Use Area (PUA) codepoints.12

* **Mechanism:** The application dynamically loads a font file named p604.ttf when the user navigates to Page 604\.  
* **Advantage:** This ensures that the text layout is identical to the printed page. Words cannot reflow, and line breaks are hard-coded into the font's design. This effectively brings the stability of an image with the scalability of a vector.14  
* **Usage:** Apps like Quran.com and Tarteel utilize this heavily to allow for sharp text at any zoom level while maintaining the 15-line grid.

### **3.2 Font Sizes and Leading Values**

For applications utilizing the **RichText** implementation (Font-Based approach), specific metrics must be tuned to match the 15-line density.

* **Body Text:** To fill the 15-line grid on a mobile device, a font size of roughly **23sp to 29pt** is observed, depending on whether the font is the standard Naskh or the QCF page-specific variant.10  
* **Line Height (Leading):** The CSS value line-height: normal is insufficient. The Arabic script, particularly in the Naskh style, has tall ascenders (*Alif*, *Lam*) and deep descenders (*Meem*, *Raa*, *Waw*). To accommodate these without clashing, a line-height multiplier of **1.5 to 1.8** is standard.10 This value is critical; if it is too small, diacritics will clip. If it is too large, the 15 lines will exceed the page boundaries.

### **3.3 Handling Headers and Ornamentation**

Unlike the body text, the Surah headers are rarely rendered using standard fonts.

* **Surah Headers:** These are typically rendered as **Images or SVG Vectors**. The script used for Surah names is *Thuluth*, a more ornamental and curvilinear script than the body's *Naskh*. While some fonts (like Surah Names font families) exist, professional apps often prefer high-quality SVGs to ensure the intricate floral frames are rendered perfectly.17  
* **Ayah End Markers:** In the QCF system, the decorative rosette that marks the end of a verse is a specific glyph within the font file. It is not an image but a character that scales with the text size.11

## **4\. Spacing and Margins: The Art of Invisible Padding**

The "Spacing" query touches on the subtle aesthetic calibrations that distinguish a polished app from a clumsy one. The distribution of whitespace is not uniform; it is hierarchical.

### **4.1 Surah Header and Bismillah Spacing**

The transition between Surahs is a structured visual event.

* **Surah Frame Height:** The decorative frame containing the Surah name occupies the vertical equivalent of **two lines** of text in the 15-line grid.  
* **Bismillah Spacing:**  
  * **Above:** The padding above the *Bismillah* is minimal, largely handled by the bottom margin of the Surah header frame.  
  * **Below:** There is a distinct visual gap between the *Bismillah* and the first Ayah of the Surah. At a 1024px reference width, this gap is approximately **20-30px**. This separation is vital to distinguish the invocation (*Basmalah*) from the revelation (*Wahy*).

### **4.2 The "Zero Padding" Strategy**

Research into the CSS and rendering logic of professional apps suggests a **Zero Padding** strategy for the body text lines. Professional implementations do not add padding-bottom to every line. Instead, they rely on the font metrics (the built-in whitespace of the glyphs) or the exact vertical distribution of the 15 lines within the content container. Adding external padding creates a risk of "drift," where small pixel additions accumulate over 15 lines to push the final line out of the viewport.10 The grid must be absolute; the text must fit inside it.

## **5\. Technical Implementation: The Hybrid Stack Architecture**

The most critical architectural decision is the choice of layout widgets. The user query asks: "Stack/Positioned or Column/ListView?" The research into quran\_android and quran-ios dictates a clear and unified answer for the **Mushaf View**.

### **5.1 The "Hybrid Stack" Pattern**

Professional apps do **not** use Column or ListView for the primary Mushaf page. A ListView implies a scrollable, variable-height container, which fundamentally breaks the "fixed page" paradigm of the Mushaf. Instead, the standard architecture is a **Hybrid Stack**.

The UI is built using a horizontal PageView (to swipe between pages). Inside each page, the structure is a Stack composed of four distinct layers:

1. **Layer 1 (Background):** A container rendering the paper texture (often a cream or yellow-tinted image) to replicate the physical book's feel.18  
2. **Layer 2 (The Content):**  
   * *Image Approach:* A high-resolution PNG of the page (Madani layout). This is the approach of quran\_android.4  
   * *Font Approach:* A RichText widget rendering the QCF page-specific font.14  
3. **Layer 3 (The Interaction Mesh):** A transparent Positioned layer that contains the geometry for touch detection. It utilizes data from an SQLite database (ayahinfo.db) to map screen coordinates to Ayah IDs.21  
4. **Layer 4 (The UI Overlay):** A transient layer for highlights, cursors, and bookmarks. When a user taps a verse (intercepted by Layer 3), Layer 4 draws a semi-transparent colored polygon over the corresponding coordinates.

The following schematic illustrates this layered architecture, emphasizing the separation of visual fidelity (Layer 2\) from interactive logic (Layer 3).

### **5.2 Flutter Implementation Strategy**

The following code snippet demonstrates the correct Flutter implementation of this stack. It uses a Stack widget to overlay the highlighting mechanism on top of the page content, ensuring that the visual layer remains immutable while the interactive layer responds to user input.

## **6\. Data Structures: The AyahInfo Database**

To match the "exact layout standards," the application cannot rely on calculating text position on the fly, which is computationally expensive and prone to errors across different OS versions. Instead, professional apps use a pre-computed coordinate database.

### **6.1 Database Schema and Coordinate Logic**

Analysis of the quran\_android repository reveals the schema for ayahinfo.db, the backend brain of the layout engine.21 This database maps every verse to a set of coordinates relative to the page image size.

**Schema Definition:**

SQL

CREATE TABLE glyphs (  
    glyph\_id INTEGER PRIMARY KEY,  
    page\_number INTEGER NOT NULL,  
    line\_number INTEGER NOT NULL,  
    sura\_number INTEGER NOT NULL,  
    ayah\_number INTEGER NOT NULL,  
    position INTEGER NOT NULL,  
    min\_x INTEGER NOT NULL,  
    max\_x INTEGER NOT NULL,  
    min\_y INTEGER NOT NULL,  
    max\_y INTEGER NOT NULL  
);

* **Coordinate System:** The min\_x, max\_x, min\_y, and max\_y columns define the bounding box of a specific segment of an Ayah.  
* **Polygonal Highlighting:** Since a single Ayah may span multiple lines, one Ayah entry in the database might have multiple rows in the glyphs table—one for the segment on line X, and another for the segment on line X+1. The application's CustomPainter must query all glyphs for (sura\_number, ayah\_number) and unite these rectangles into a single seamless highlight polygon.

## **7\. Comparative Analysis: Image vs. Font Approaches**

Developers often face a strategic choice between the Image-Based approach (prioritizing absolute fidelity) and the Font-Based approach (prioritizing scalability). The following matrix compares these two dominant methodologies to assist in architectural decision-making.

## **8\. Open Source References and Resource Guide**

To accelerate development and ensure compliance with community standards, the following open-source resources are identified as the most relevant high-quality bases for study and asset acquisition.

### **8.1 Primary Reference Repositories**

1. **Quran Android (GitHub: quran/quran\_android):**  
   * **Role:** The gold standard for the **Image-Based** approach.  
   * **Key Component:** The logic for AyahInfoDatabase and the MadaniPageProvider classes provides a complete blueprint for handling image assets and coordinate mapping.4  
2. **Quran iOS (GitHub: quran/quran-ios):**  
   * **Role:** The reference for high-performance rendering on Apple devices.  
   * **Key Component:** Demonstrates the implementation of QCF fonts and efficient text rendering in Swift.23  
3. **Open-Mushaf (GitHub: adelpro/open-mushaf):**  
   * **Role:** A modern Web/PWA implementation.  
   * **Key Component:** Shows how to implement responsive design using KFGQPC assets in a web environment, useful for developers building cross-platform Flutter web apps.24  
4. **Quran Library Package (Flutter):**  
   * **Role:** A specialized Flutter package (quran\_library) designed to provide Mushaf-identical pages and logic out of the box.13

### **8.2 Asset Acquisition Pipeline**

* **Images:** The quran\_android project downloads images from a content delivery network (CDN). These are typically hosted in zip files (e.g., images\_1024.zip) containing standard Madani pages. Developers can inspect the network traffic of the open-source app to identify the current CDN endpoints or generate their own using the quran-android-images-helper tool.5  
* **Fonts:** KFGQPC fonts (both standard Uthman Taha Naskh and the QCF Page-Specific fonts) can be downloaded directly from the King Fahd Complex website or found in the assets/fonts folders of the referenced repositories.12

## **9\. Conclusion**

The development of a professional mobile Mushaf is a discipline of precision. It demands a departure from standard mobile layout paradigms in favor of a rigid, grid-based approach that honors the physical heritage of the *Mushaf Al-Madinah*. The research confirms that the "Hybrid Stack" architecture—anchored by high-resolution Madani assets and driven by a coordinate-based interaction layer—is the only viable path to matching the exacting standards of industry leaders. By strictly adhering to the 15-line grid, utilizing the Stack widget over Column, and leveraging the QCF asset ecosystem, developers can build an application that not only displays the Quran but preserves its digital sanctity for the next generation of readers.

#### **Works cited**

1. Al-Quran (Mushaf Madinah), accessed December 29, 2025, [https://madinah.sg/product/al-quran-mushaf-madinah/](https://madinah.sg/product/al-quran-mushaf-madinah/)  
2. Mushaf Madinah (Blue Color 5.5x8in) | Dar-us-Salam, accessed December 29, 2025, [https://dar-us-salam.com/quran/mushaf-uthmani/q40-mushaf-madinah-blue-color.html](https://dar-us-salam.com/quran/mushaf-uthmani/q40-mushaf-madinah-blue-color.html)  
3. Mushaf Madinah (Standard Size Arabic Quran from Saudi-Arabia) \- Green Color, accessed December 29, 2025, [https://www.hilalplaza.com/products/mushaf-madinah-greenstansize](https://www.hilalplaza.com/products/mushaf-madinah-greenstansize)  
4. New Madina Mushaf print images · Issue \#575 · quran/quran\_android \- GitHub, accessed December 29, 2025, [https://github.com/quran/quran\_android/issues/575](https://github.com/quran/quran_android/issues/575)  
5. murtraja/quran-android-images-helper \- GitHub, accessed December 29, 2025, [https://github.com/murtraja/quran-android-images-helper](https://github.com/murtraja/quran-android-images-helper)  
6. 3 Layer Large Niqab Veil for Muslim Women (92cm) \- Jamaica | Ubuy, accessed December 29, 2025, [https://www.ubuy.com.jm/productuk/4FI8BWWU0-muslim-women-quality-hijab-3](https://www.ubuy.com.jm/productuk/4FI8BWWU0-muslim-women-quality-hijab-3)  
7. Anatomy of Quran Pages \- The Wahy Project, accessed December 29, 2025, [https://thewahyproject.com/2014/08/03/anatomy-of-quran-pages/](https://thewahyproject.com/2014/08/03/anatomy-of-quran-pages/)  
8. What Arabic font is generally used for printing Quran? \- Quora, accessed December 29, 2025, [https://www.quora.com/What-Arabic-font-is-generally-used-for-printing-Quran](https://www.quora.com/What-Arabic-font-is-generally-used-for-printing-Quran)  
9. Quran Hafs by KFGQPC \- Free download and install on Windows | Microsoft Store, accessed December 29, 2025, [https://www.microsoft.com/en-ck/p/quran-hafs-by-kfgqpc/9p2x4tcc66xn](https://www.microsoft.com/en-ck/p/quran-hafs-by-kfgqpc/9p2x4tcc66xn)  
10. mpdf-examples/example61\_new\_mPDF\_v6-0\_features.php at development \- GitHub, accessed December 29, 2025, [https://github.com/mpdf/mpdf-examples/blob/development/example61\_new\_mPDF\_v6-0\_features.php](https://github.com/mpdf/mpdf-examples/blob/development/example61_new_mPDF_v6-0_features.php)  
11. The Digital Canon: A Comparative Philological and Technical Analysis of Quranic Orthography on Quran.com and Tanzil.net, accessed December 29, 2025, [https://thequran.love/2025/11/30/the-digital-canon-a-comparative-philological-and-technical-analysis-of-quranic-orthography-on-quran-com-and-tanzil-net/](https://thequran.love/2025/11/30/the-digital-canon-a-comparative-philological-and-technical-analysis-of-quranic-orthography-on-quran-com-and-tanzil-net/)  
12. Typefaces and type design for Arabic \- Luc Devroye, accessed December 29, 2025, [https://luc.devroye.org/arab.html](https://luc.devroye.org/arab.html)  
13. quran\_library | Flutter package \- Pub.dev, accessed December 29, 2025, [https://pub.dev/packages/quran\_library](https://pub.dev/packages/quran_library)  
14. Quran App a surah view like uthmanic quran 15 line how to make it like quran for android app \- Stack Overflow, accessed December 29, 2025, [https://stackoverflow.com/questions/77073404/quran-app-a-surah-view-like-uthmanic-quran-15-line-how-to-make-it-like-quran-for](https://stackoverflow.com/questions/77073404/quran-app-a-surah-view-like-uthmanic-quran-15-line-how-to-make-it-like-quran-for)  
15. Which font used by quran.com? · Issue \#339 \- GitHub, accessed December 29, 2025, [https://github.com/quran/quran.com-frontend-v2/issues/339](https://github.com/quran/quran.com-frontend-v2/issues/339)  
16. New Features in mPDF v6.0 \- ME Construction News, accessed December 29, 2025, [https://meconstructionnews.com/script/pdf/examples/example61\_new\_mPDF\_v6-0\_features.php](https://meconstructionnews.com/script/pdf/examples/example61_new_mPDF_v6-0_features.php)  
17. Quranic Landmarks: learn these rules to find your way easily, accessed December 29, 2025, [https://understandquran.com/quranic-landmarks/](https://understandquran.com/quranic-landmarks/)  
18. Mushaf with gilding and Medina pages (bluish pages, thin pages) \- SifatuSafwa, accessed December 29, 2025, [https://www.sifatusafwa.com/en/quran-mushaf/mushaf-with-gilding-and-medina-pages-bluish-pages-thin-pages.html](https://www.sifatusafwa.com/en/quran-mushaf/mushaf-with-gilding-and-medina-pages-bluish-pages-thin-pages.html)  
19. Mushaf Madinah, Al Quran Al-Kareem(Cream Paper- Medium size)Uthmani Script, accessed December 29, 2025, [https://darussalamus.com/products/mushaf-madinah-al-quran-al-kareem-cream-paper-medium-size-uthmani-script](https://darussalamus.com/products/mushaf-madinah-al-quran-al-kareem-cream-paper-medium-size-uthmani-script)  
20. Developers \- Quran.com, accessed December 29, 2025, [https://quran.com/en/developers](https://quran.com/en/developers)  
21. ayah-detection/README.md at master \- Quran Utilities \- GitHub, accessed December 29, 2025, [https://github.com/quran/ayah-detection/blob/master/README.md](https://github.com/quran/ayah-detection/blob/master/README.md)  
22. quran/quran\_android: a quran reading application for android \- GitHub, accessed December 29, 2025, [https://github.com/quran/quran\_android](https://github.com/quran/quran_android)  
23. QuranEngine is the engine powering the Quran.com iOS app. \- GitHub, accessed December 29, 2025, [https://github.com/quran/quran-ios](https://github.com/quran/quran-ios)  
24. An open-source Quran Mushaf implementation built with TypeScript, using Next.js, PWA, and TailwindCSS for optimal performance, offline access, and responsive design. \- GitHub, accessed December 29, 2025, [https://github.com/adelpro/open-mushaf](https://github.com/adelpro/open-mushaf)  
25. Copyright | PDF \- Scribd, accessed December 29, 2025, [https://www.scribd.com/document/846357612/Copyright](https://www.scribd.com/document/846357612/Copyright)  
26. ISO/IEC JTC1/SC2/WG2 N3816 \- Unicode, accessed December 29, 2025, [https://www.unicode.org/wg2/docs/n3816.pdf](https://www.unicode.org/wg2/docs/n3816.pdf)