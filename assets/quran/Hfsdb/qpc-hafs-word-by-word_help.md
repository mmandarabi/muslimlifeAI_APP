KFGQPC Hafs script - Word by word Resource
This resource provides Quranic script in KFGQPC Hafs script - Word by word format. The script uses Unicode text with specialized font rendering for digital applications.

Sample JSON

          {
          "1:1": {
          "verse_key": "1:1",
          "text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
          "script_type": "text_qpc_hafs",
          "font_family": "qpc-hafs",
            "words": [
            {
            "position": 1,
            "text": "بِسۡمِ",
            "location": "1:1:1"
            }
            ],
          "page_number": 1,
          "juz_number": 1,
          "hizb_number": 1
          }
          }
        
Field Descriptions
Field	Type	Description
verse_key	String	Reference in the format surah:ayah (e.g., 1:1)
text	String	Unicode text of the verse in KFGQPC Hafs script - Word by word script
script_type	String	Type of script rendering (text_qpc_hafs)
font_family	String	CSS font family for proper rendering (qpc-hafs)
words	Array	Array of word objects with individual word text/images
words[].position	Integer	Position of the word within the verse
words[].text	String	Unicode text of the individual word
words[].location	String	Word location in format surah:ayah:word
page_number	Integer	Mushaf page number where this verse appears
juz_number	Integer	Juz number (1-30) containing this verse
hizb_number	Integer	Hizb number (1-60) containing this verse
Usage Examples
CSS Integration
/* Include the font family in your CSS */
.quran-text {
  font-family: 'qpc-hafs', 'Amiri', serif;
  direction: rtl;
  text-align: right;
}
JavaScript Usage
// Fetch verse data
fetch('/api/v1/verses/1:1.json')
  .then(response => response.json())
  .then(data => {
    document.getElementById('verse').innerHTML = data.text;
    document.getElementById('verse').className = 'qpc-hafs';
  });
Features
High-quality Arabic text rendering
Proper diacritical marks and Tajweed annotations
Responsive design for different screen sizes
Word-by-word display for detailed study
Unicode text for easy copying and searching
Scalable vector rendering