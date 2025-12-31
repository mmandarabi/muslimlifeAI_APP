Getting Started
Installation
npm
pnpm
yarn
bun
bun add @quranjs/api

Quick Start
import { Language, QuranClient } from "@quranjs/api";

// Initialize the client
const client = new QuranClient({
  clientId: process.env.QURAN_CLIENT_ID!,
  clientSecret: process.env.QURAN_CLIENT_SECRET!,
  defaults: {
    language: Language.ENGLISH,
  },
});

// Fetch all chapters
const chapters = await client.chapters.findAll();

// Get a specific verse
const verse = await client.verses.findByKey("2:255", {
  translations: [20],
  words: true,
});

// Search
const results = await client.search.search("light", {
  language: Language.ENGLISH,
  size: 10,
});

Environment Variables
# .env
QURAN_CLIENT_ID=your_client_id
QURAN_CLIENT_SECRET=your_client_secret

const client = new QuranClient({
  clientId: process.env.QURAN_CLIENT_ID!,
  clientSecret: process.env.QURAN_CLIENT_SECRET!,
});

Runtime Configuration
// Get current config
const config = client.getConfig();

// Update config
client.updateConfig({
  defaults: { language: Language.ARABIC },
});

// Clear auth token
client.clearCachedToken();

Chapters API
The Chapters API provides access to information about the 114 chapters (surahs) of the Quran.

Get All Chapters
const chapters = await client.chapters.findAll();

chapters.forEach((chapter) => {
  console.log(`${chapter.id}. ${chapter.nameSimple} (${chapter.nameArabic})`);
  console.log(`   Verses: ${chapter.versesCount}`);
  console.log(`   Revelation: ${chapter.revelationPlace}`);
});

Chapter Type
Field	Type	Notes
id	number	Sequential chapter identifier.
versesCount	number	Total verses in the chapter.
bismillahPre	boolean	Indicates if Bismillah precedes the chapter.
revelationOrder	number	Order of revelation.
revelationPlace	string	meccan or medinan.
pages	number[]	Mushaf page range for the chapter.
nameComplex	string	Full transliterated name (e.g., Al-Baqarah).
nameSimple	string	Common English name.
transliteratedName	string	Transliteration suitable for URLs.
nameArabic	string	Arabic chapter name.
translatedName	TranslatedName	Localized name with language metadata.
With Language Options
import { Language } from "@quranjs/api";

const arabicChapters = await client.chapters.findAll({
  language: Language.ARABIC,
});

const urduChapters = await client.chapters.findAll({
  language: Language.URDU,
});

Get Chapter by ID
const alFatiha = await client.chapters.findById("1");
const alBaqarah = await client.chapters.findById("2");
const anNas = await client.chapters.findById("114");

Get Chapter Info
const info = await client.chapters.findInfoById("1");

console.log(info.shortText); // Brief description
console.log(info.text); // Full description
console.log(info.source); // Source attribution

ChapterInfo Type
Field	Type	Notes
id	number	Unique identifier for the info record.
chapterId	number	Chapter the info is associated with.
text	string	Full descriptive text.
shortText	string	Condensed overview for quick display.
source	string	Attribution for the content.
languageName	string	Language of the info text (e.g., english).
Verses API
The Verses API provides access to Quranic verses with support for translations, tafsirs, audio, and word analysis.

Get Verse by Key
const verse = await client.verses.findByKey("2:255");
const firstVerse = await client.verses.findByKey("1:1");
const lastVerse = await client.verses.findByKey("114:6");

Verse Type
Field	Type	Notes
id	number	Database identifier for the verse.
verseNumber	number	Verse number within the surah.
verseKey	string	Verse key in chapter:verse format.
chapterId	number \| string	Chapter that contains the verse.
pageNumber	number	Mushaf page containing the verse.
juzNumber	number	Juz where the verse appears.
hizbNumber	number	Hizb number (1–60).
rubElHizbNumber	number	Rub' position within the Hizb.
words	Word[]	Optional word-level metadata.
textUthmani*	string	Various Uthmani scripts (textUthmani, textUthmaniSimple, textUthmaniTajweed).
textImlaei*	string	Imlaei script variants (textImlaei, textImlaeiSimple).
textIndopak*	string	IndoPak script variants (textIndopak, textIndopakNastaleeq).
imageUrl	string	Optional rendered verse image URL.
imageWidth	number	Width for the rendered image.
v1Page	number	Legacy Quran.com v1 page number.
v2Page	number	Legacy Quran.com v2 page number.
codeV1	string	Legacy Uthmani code (deprecated).
codeV2	string	Legacy code for the v2 dataset.
translations	Translation[]	Translations returned with the verse.
tafsirs	Tafsir[]	Tafsir entries returned with the verse.
audio	AudioResponse	Optional audio metadata.
With Translations
const verse = await client.verses.findByKey("2:255", {
  translations: [20, 131], // English and Urdu
  words: true,
  translationFields: {
    languageName: true,
    resourceName: true,
    verseKey: true,
  },
});

With Audio
const verse = await client.verses.findByKey("1:1", {
  reciter: 2,
  words: true,
});

With Tafsir
const verse = await client.verses.findByKey("1:1", {
  tafsirs: [171],
  translations: [20],
});

Get Verses by Chapter
const verses = await client.verses.findByChapter("1");

const paginated = await client.verses.findByChapter("2", {
  translations: [20],
  perPage: 10,
  page: 1,
  words: true,
});

Get Verses by Page
const firstPage = await client.verses.findByPage("1");
const page42 = await client.verses.findByPage("42", {
  translations: [131],
});

Get Verses by Divisions
// By Juz
const juz1 = await client.verses.findByJuz("1");

// By Hizb
const hizb1 = await client.verses.findByHizb("1");

// By Rub
const rub1 = await client.verses.findByRub("1");

Get Random Verse
const random = await client.verses.findRandom({
  translations: [20],
  words: true,
});

Field Selection
Word Fields
const verse = await client.verses.findByKey("1:1", {
  words: true,
  wordFields: {
    textUthmani: true,
    verseKey: true,
    location: true,
  },
});

Translation Fields
const verse = await client.verses.findByKey("2:255", {
  translations: [20, 131],
  translationFields: {
    languageName: true,
    resourceName: true,
    verseKey: true,
  },
});

Verse Fields
const verse = await client.verses.findByKey("1:1", {
  fields: {
    textUthmani: true,
    textUthmaniTajweed: true,
    codeV1: true,
    v1Page: true,
  },
});

Pagination
const verses = await client.verses.findByChapter("2", {
  page: 1,
  perPage: 20,
  translations: [20],
});

Audio API
The Audio API provides access to audio recitations including chapter audio and verse-by-verse audio with timing.

Chapter Recitations
Get All Chapter Recitations
const recitations = await client.audio.findAllChapterRecitations("2");

console.log(recitations[0]);
// {
//   id: 1,
//   chapterId: 1,
//   fileSize: 12345,
//   format: "mp3",
//   audioUrl: "https://audio.quran.com/..."
// }

ChapterRecitation Type
Field	Type	Notes
id	number	Unique identifier for the chapter audio record.
chapterId	number	Surah that the audio recitation belongs to.
fileSize	number	File size in bytes.
format	string	Audio format, typically mp3.
audioUrl	string	Download URL for the chapter recitation.
Get Specific Chapter
const audio = await client.audio.findChapterRecitationById("2", "1");

console.log(`URL: ${audio.audioUrl}`);
console.log(`Format: ${audio.format}`);

Verse Recitations
By Chapter
const { audioFiles, pagination } = await client.audio.findVerseRecitationsByChapter(
  "1",  // Chapter ID
  "2"   // Recitation ID
);

audioFiles.forEach((audio) => {
  console.log(`${audio.verseKey}: ${audio.url}`);
});

VerseRecitation Type
Field	Type	Notes
verseKey	string	Verse identifier such as 2:255.
url	string	Direct URL to the verse audio file.
id	number	Unique identifier for the verse recitation.
chapterId	number	Surah that the verse belongs to.
segments	Segment[]	Optional timing metadata for word-level playback.
format	string	Audio format, e.g. mp3.
Segment entries include the timestamp ranges (start, end) that power word-level playback.

By Verse Key
const { audioFiles } = await client.audio.findVerseRecitationsByKey(
  "2:255",
  "2"
);

const audio = audioFiles[0];
console.log(`URL: ${audio.url}`);
console.log(`Format: ${audio.format ?? "stream"}`);

Field Selection
const { audioFiles } = await client.audio.findVerseRecitationsByChapter("1", "2", {
  fields: {
    segments: true,
    format: true,
    id: true,
    chapterId: false,
  },
});

// Available verse fields: id, chapterId, segments, format


Resources API
The Resources API provides metadata about translations, tafsirs, reciters, and other Quranic resources.

Recitations
Get All Recitations
const recitations = await client.resources.findAllRecitations();

recitations.forEach((r) => {
  console.log(`${r.id}. ${r.reciterName ?? "Unknown"} (${r.style ?? "N/A"})`);
});

RecitationResource Type
Field	Type	Notes
id	number	Unique identifier for the recitation.
reciterName	string	Reciter's full name.
style	string	Recitation style such as murattal.
translatedName	TranslatedName	Localized display names.
TranslatedName objects include languageName, name, and optional localization metadata from the SDK.

Get Recitation Details
const info = await client.resources.findRecitationInfo("2");

console.log(info.info); // Rich text/HTML describing the recitation

RecitationInfoResource Type
Field	Type	Notes
id	number	Recitation identifier.
info	string	Biography or extended information about the reciter.
Translations
Get All Translations
const translations = await client.resources.findAllTranslations();

const english = translations.filter((t) => t.languageName === "english");
const urdu = translations.filter((t) => t.languageName === "urdu");

TranslationResource Type
Field	Type	Notes
id	number	Translation identifier.
name	string	Translation title.
authorName	string	Translator's name.
slug	string	URL-friendly slug.
languageName	string	Language of the translation.
translatedName	TranslatedName	Localized names and language metadata.
Get Translation Details
const info = await client.resources.findTranslationInfo("131");

console.log(info.info); // Information about the translation (HTML/string)

TranslationInfoResource Type
Field	Type	Notes
id	number	Translation identifier.
info	string	Extended translation details or biography.
Tafsirs
Get All Tafsirs
const tafsirs = await client.resources.findAllTafsirs();

tafsirs.forEach((t) => {
  console.log(`${t.name} by ${t.authorName}`);
});

TafsirResource Type
Field	Type	Notes
id	number	Tafsir identifier.
name	string	Tafsir title.
authorName	string	Author of the tafsir.
slug	string	URL-friendly identifier.
languageName	string	Language of the tafsir.
translatedName	TranslatedName	Localized name entries.
Get Tafsir Details
const info = await client.resources.findTafsirInfo("171");

console.log(info.name);       // "Tafsir Ibn Kathir"
console.log(info.authorName); // "Ibn Kathir"
console.log(info.bio);

TafsirInfoResource Type
Field	Type	Notes
id	number	Tafsir identifier.
info	string	Detailed description or biography.
Languages
const languages = await client.resources.findAllLanguages();

languages.forEach((lang) => {
  console.log(`${lang.name} (${lang.isoCode}) - native: ${lang.nativeName}`);
});

LanguageResource Type
Field	Type	Notes
id	number	Language identifier.
name	string	English name of the language.
nativeName	string	Native script name.
isoCode	string	ISO code (e.g., en).
direction	string	Text direction such as ltr or rtl.
translatedNames	TranslatedName[]	Available localized names.
Chapter Resources
Chapter Information
const chapterInfos = await client.resources.findAllChapterInfos();

chapterInfos.forEach((info) => {
  console.log(`${info.name} - ${info.languageName}`);
});

ChapterInfoResource Type
Field	Type	Notes
id	number	Resource identifier.
name	string	Title of the chapter info resource.
authorName	string	Author attribution.
slug	string	URL-friendly identifier.
languageName	string	Language of the chapter info.
translatedName	TranslatedName	Localized names for the resource.
Chapter Reciters
const reciters = await client.resources.findAllChapterReciters();

reciters.forEach((r) => {
  console.log(`${r.name} (${r.arabicName ?? "n/a"})`);
});

ChapterReciterResource Type
Field	Type	Notes
id	number	Reciter identifier.
name	string	Reciter name.
arabicName	string	Arabic display name.
relativePath	string	Relative file path for audio.
format	string	Audio format, e.g., mp3.
filesSize	number	Total file size in kilobytes.
Recitation Styles
const styles = await client.resources.findAllRecitationStyles();

console.log(styles.murattal);  // Murattal reciters
console.log(styles.mujawwad);  // Mujawwad reciters

RecitationStylesResource Type
Field	Type	Notes
mujawwad	string	Label for Mujawwad-style recitations.
murattal	string	Label for Murattal-style recitations.
muallim	string	Label for teaching-style recitations.
Verse Media
const media = await client.resources.findVerseMedia();

console.log(media.name);        // Resource name
console.log(media.languageName); // Language associated with the resource

VerseMediaResource Type
Field	Type	Notes
id	number	Media identifier.
name	string	Media name.
authorName	string	Author or curator name.
languageName	string	Language associated with the resource

Juzs API
The Juzs API provides information about the 30 Juzs, which are traditional divisions of the Quran.

Get All Juzs
const juzs = await client.juzs.findAll();

console.log(juzs[0]); // First Juz
// {
//   id: 1,
//   juzNumber: 1,
//   verseMapping: {
//     "1:1": "1:7",
//     "2:1": "2:141"
//   },
//   firstVerseId: 1,
//   lastVerseId: 148,
//   versesCount: 148
// }

Juz Type
Field	Type	Notes
id	number	Unique identifier for the Juz.
juzNumber	number	Juz sequence from 1 to 30.
verseMapping	Record<string, string>	Maps start/end verse keys for each section within the Juz.
firstVerseId	number	Identifier of the first verse in the Juz.
lastVerseId	number	Identifier of the last verse in the Juz.
versesCount	number	Total verses contained in the Juz.
Understanding Verse Mapping
const juz = juzs[0];

Object.entries(juz.verseMapping).forEach(([start, end]) => {
  console.log(`${start} to ${end}`);
});

// Output:
// 1:1 to 1:7     (Al-Fatiha complete)
// 2:1 to 2:141   (First part of Al-Baqarah)

Search API
The Search API enables searching through Quranic content with multi-language support.

Basic Search
const results = await client.search.search("light");

console.log(`Found ${results.totalResults} results`);

(results.results ?? []).forEach((result) => {
  console.log(`${result.verseKey}: ${result.highlighted ?? result.text}`);
});

SearchResult Type
Field	Type	Notes
verseKey	string	Verse identifier such as 24:35.
verseId	number	Internal verse identifier.
text	string	Matched verse text without highlighting applied.
highlighted	string	HTML string with emphasized query matches.
words	Word[]	Word-level metadata for the verse.
translations	Translation[]	Translations returned with the result set.
With Language
import { Language } from "@quranjs/api";

const results = await client.search.search("O�O-U.Oc", {
  language: Language.ARABIC,
  size: 10,
  page: 1,
});

Options
Pagination
const results = await client.search.search("mercy", {
  size: 10,    // Results per page (default: 30)
  page: 1,     // Page number
  language: Language.ENGLISH,
});

console.log(`Page ${results.currentPage} of ${results.totalPages}`);

Language-Specific
const english = await client.search.search("mercy", {
  language: Language.ENGLISH,
});

const arabic = await client.search.search("O�O-U.Oc", {
  language: Language.ARABIC,
});

const urdu = await client.search.search("رحمت", {
  language: Language.URDU,
});

Migration Guide: From quran.v4 to QuranClient
This document outlines how to migrate from the old quran.v4 API to the new class-based QuranClient.

Old Usage (Deprecated)
import { quran } from "@quranjs/api";

// Old way
const chapters = await quran.v4.chapters.findAll();
const verse = await quran.v4.verses.findByKey("1:1");

New Usage (Recommended)
import { QuranClient } from "@quranjs/api";

// Create a client instance with your credentials
const client = new QuranClient({
  clientId: "your-client-id",
  clientSecret: "your-client-secret",
  // Optional: custom base URLs
  contentBaseUrl: "https://apis.quran.foundation", // default
  authBaseUrl: "https://oauth2.quran.foundation", // default
  // Optional: custom fetch implementation
  fetch: fetch, // default: global fetch
});

// Use the client
const chapters = await client.chapters.findAll();
const verse = await client.verses.findByKey("1:1");

Authentication
The new client automatically handles OAuth2 authentication using the client credentials flow:

Requests an access token using your client ID and secret
Caches the token until it expires
Automatically refreshes the token when needed
Includes authentication headers in all API requests
API Changes
All API methods remain the same, but they're now organized under the client instance:

Chapters
client.chapters.findAll()
client.chapters.findById(id)
client.chapters.findInfoById(id)
Verses
client.verses.findByKey(key)
client.verses.findByChapter(id)
client.verses.findByPage(page)
client.verses.findByJuz(juz)
client.verses.findByHizb(hizb)
client.verses.findByRub(rub)
client.verses.findRandom()
Juzs
client.juzs.findAll()
Audio
client.audio.findAllChapterRecitations(reciterId)
client.audio.findChapterRecitationById(reciterId, chapterId)
client.audio.findVerseRecitationsByChapter(chapterId, recitationId)
client.audio.findVerseRecitationsByKey(key, recitationId)
Resources
client.resources.findAllRecitations()
client.resources.findAllTranslations()
client.resources.findAllTafsirs()
client.resources.findAllLanguages()
client.resources.findRecitationInfo(id)
client.resources.findTranslationInfo(id)
client.resources.findTafsirInfo(id)
Search
client.search.search(query, options)
Configuration Updates
You can update the client configuration at runtime:

client.updateConfig({
  contentBaseUrl: "https://new-api-base.com",
});

Backward Compatibility
The legacy quran.v4 namespace that was exported in v1 has been removed in v2. Upgrading projects must create a QuranClient instance (as shown above) and supply a client ID and secret. Any code that still imports quran.v4 will throw at runtime after upgrading, so plan your migration before bumping to v2.

Error Handling
The new client provides better error handling with authentication-specific errors:

try {
  const chapters = await client.chapters.findAll();
} catch (error) {
  if (error.message.includes("Token request failed")) {
    // Handle authentication error
    console.error("Authentication failed:", error.message);
  } else {
    // Handle other API errors
    console.error("API error:", error.message);
  }
}

Custom Fetch
You can provide a custom fetch implementation for environments that don't have global fetch:

import nodeFetch from "node-fetch";

const client = new QuranClient({
  clientId: "your-client-id",
  clientSecret: "your-client-secret",
  fetch: nodeFetch,
});

