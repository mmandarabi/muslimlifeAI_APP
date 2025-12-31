QPC V2 Font
Page by Page
The QPC V2 Font is a high-quality, handwritten Arabic font developed by the King Fahd Complex for the Printing of the Holy Quran, based on the calligraphy of Usman Taha. It preserves the traditional Uthmani script with precise detailing.

This font uses custom ligatures where each glyph represents an entire word rather than individual letters. To render the complete Quran, a total of 604 separate fonts are used—each corresponding to one page of the Madinah Mushaf.

Tags
Hafs
QPC
V2
Glyph based
Download Links
Download woff
Download woff2
Download ttf
Documentation
Glyph Preview
How to Use This Font
⚠️ This documentation covers usage on web platforms only.
For environments like React Native, Android, or iOS, you'll need to handle font integration using platform-specific methods.
You can use this font in your application by downloading the font file—available in multiple formats such as TTF, WOFF, and WOFF2. You may choose the format that best fits your platform or include multiple formats for broader compatibility.

Some fonts—such as those used for Surah names or Juz titles—depend on special characters or ligatures to render correctly. Ligature files for these fonts are available on this page. Standard Quran fonts require a separate Quran script, which you can download from the Quran Scripts page.
The next step is to declare the font using @font-face in your CSS file and apply it to your elements.

Steps to Integrate
Download the font and scripts/ligatures
Define a @font-face Rule in Your CSS

@font-face {
  font-family: 'p1-v2';
  src: url('https://static-cdn.tarteel.ai/qul/fonts/quran_fonts/v2/ttf.ttf') format('truetype');
  font-display: swap;
}
      
Use the @font-face in your html
You can use the font by:

Applying it directly via style or CSS:

<div style="font-family: 'p1-v2';">
  
  </div>
      
Or using a CSS class:
.my-text {
  font-family: p1-v2;
}
<p class="my-text"></p>