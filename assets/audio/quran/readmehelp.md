QUL supports two types of Quranic recitations audio data:

1. Surah-by-Surah (Gapless)
Contains 114 audio files, one per surah.
Each audio file plays the entire surah continuously without gaps.
Often referred to as gapless audio.
2. Ayah-by-Ayah (Gapped)
Contains 6,236 audio files, one for each ayah (verse) in the Quran.
Each audio file corresponds to a single ayah.
Also called gapped audio due to discrete audio segments for each ayah.
Useful for playing single ayah without loading the full surah audio.
Ayah-by-Ayah Segments Data Format
{
  "surah": <surah_number>,
  "ayah": <ayah_number>,
   "audio_url": "audio file url",
  "segments": [
    [ <segment_index>, <start_time_ms>, <end_time_ms> ],
    ...
  ]
}
Surah-by-Surah Segments Data Format
{
              "surah:ayah": {
  "duration_sec": <duration in seconds>,
   "timestamp_from": "start time of this ayah within audio file",
  "timestamp_to": "end time of ayah",
  "segments": [
    [ <segment_index>, <start_time_ms>, <end_time_ms> ],
    ...
  ]}
}
Sample data for surah segment
{
  "1:1": {
    "segments": [
      [1, 361, 1051],
      [2, 1051, 1622],
      [3, 1662, 2763],
      [4, 2803, 4385]
    ],
    "duration_sec": 4,
    "duration_ms": 4224,
    "timestamp_from": 361,
    "timestamp_to": 4585
  }
}



noreply@tx-notifications.quran.com
​You​
​developers@quran.com​
Assalamu Alaikum,

Jazakum Allah Khair for requesting access to the Quran.Foundation API. We’re excited to see what you build, in sha’ Allah.

Before you dive in, these are the ni'mah we offer — and the amanah we expect as you serve Quranic readers.

Developer Benefits
Comprehensive APIs, backend, and managed data so you can focus on solving unique problems.
Opportunity to be featured on Quran.com via the Quran App Portal.
Direct support from QuranFoundation and its broader network.
Reliable, copyrighted, scholarly verified content.
Mission-driven community that prioritizes da’wah impact.
Users can bring their reading history, bookmarks, saved verses, notes, reflections, and streaks into your app.
Full feature set from Quran.com and QuranReflect, plus OAuth and a notification engine.
Funding or in-kind support for high-value projects aligned with QuranFoundation plans.
Developer Disclaimers
Examine intention and risks; your product shapes hearts and behavior.
Building a Quranic or guidance app puts you in a da’wah role—clarify your references and scholars, and consult them on content, behavior design, priorities, and potential harms.
Respect copyrights and licensing expectations.
Honor scholarly review and keep content aligned with verified sources.
Use the API to keep content accurate as removals, additions, or edits occur.
Focus on solving unique problems; the ummah needs more coverage than current resources provide.
Decide your commercial stance with scholars; if allowed, follow guidelines for both developers and QuranFoundation collaboration.
Practice ta’awun (Quranic collaboration) with the wider ecosystem.
Pre-Production (Test)
Client ID: 91e837aa-b0e0-4c67-af60-81b08311a758
Client Secret: X2JqYSIi_Xc3mVcXMK_s~ojaNA
End-Point: https://prelive-oauth2.quran.foundation

⚠️ Limited data, but all features enabled for testing.

Production (Live)
Client ID: 74540ddf-d20c-4f40-a9ca-e06c77d9474c
Client Secret: BkOOtdB6uyMEwILV0AoHzNMHQq
End-Point: https://oauth2.quran.foundation

⚠️ Full Qur’ān content, but NO authentication / user features by default.