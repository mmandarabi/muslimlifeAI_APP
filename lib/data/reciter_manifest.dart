class ReciterManifest {
  /// Returns the intro/Bismillah duration in milliseconds for a specific reciter and surah.
  /// 
  /// Most QDC "Murattal" files start immediately with Ayah 1 (0ms offset).
  /// Exceptions (like Sudais Surah 78) are handled here.
  static int getBismillahOffset(String reciterId, int surahId) {
    // 1. Surah Al-Fatiha (1) always handled by API/Ayah 1 timestamps directly.
    //    We return 0 here because logic usually skips injection for Surah 1 anyway.
    if (surahId == 1) return 0;
    
    // 2. Sudais Exceptions
    if (reciterId == 'sudais') {
      if (surahId == 78) return 23300; // Verified ~23.3s intro
      // Add other Sudais exceptions here if found
    }

    // 3. Mishary Exceptions
    if (reciterId == 'mishary') {
      // Add Mishary exceptions here if found
    }

    // 4. Default: 0ms
    // Most QDC files (112, etc.) start immediately.
    return 0;
  }
}
