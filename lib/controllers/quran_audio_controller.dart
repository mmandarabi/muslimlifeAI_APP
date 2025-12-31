import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quran_surah.dart';
import '../models/word_segment.dart';
import '../services/unified_audio_service.dart';
import '../services/quran_page_service.dart';
import '../data/reciter_manifest.dart';

class QuranAudioController extends ChangeNotifier {
  final UnifiedAudioService _audioService = UnifiedAudioService();
  
  // Subscriptions
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  // Local State
  bool isPlaying = false;
  bool isDownloading = false;
  bool isTransitioning = false;
  bool isBrowsing = false;
  bool isProgrammaticScroll = false; // Flag to skip isBrowsing trigger during auto-turns
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int? activeAyahId;
  int? activePageNumber; // 🔧 FIX: Track which page contains the active ayah
  int? activeWordIndex; // 🆕 PHASE 2: Word-level tracking
  List<AyahSegment> ayahSegments = [];
  List<WordSegment> wordSegments = []; // 🆕 PHASE 2: Word-level segments
  int _maxAyahIdSeen = -1000;
  int? _currentSurahId;
  int? get currentSurahId => _currentSurahId;
  set currentSurahId(int? id) {
    if (_currentSurahId == id) return;
    _currentSurahId = id;
    if (id != null) {
      _audioService.setContext(id);
    } else {
      resetPlayingContext();
    }
    notifyListeners();
  }

  // Constants
  static const int bismillahId = -786;
  
  // 🆕 PHASE 2: Getter for active word segment
  WordSegment? get activeWordSegment {
    if (activeWordIndex == null || wordSegments.isEmpty) return null;
    try {
      return wordSegments.firstWhere(
        (seg) => seg.ayahNumber == activeAyahId && seg.wordIndex == activeWordIndex,
      );
    } catch (e) {
      return null;
    }
  }

  void init(int surahId) {
    currentSurahId = surahId;
    isPlaying = _audioService.isPlaying;
    currentPosition = _audioService.position;
    totalDuration = _audioService.duration ?? Duration.zero;
    isDownloading = _audioService.downloadingNotifier.value;
    isTransitioning = _audioService.transitioningNotifier.value;

    _playerStateSubscription = _audioService.onPlayerStateChanged.listen((state) {
      if (!_audioService.isTransitioning) {
        isPlaying = state.playing;
        notifyListeners();
      }
    });

    _positionSubscription = _audioService.onPositionChanged.listen((pos) {
      if (!_audioService.isTransitioning) {
        currentPosition = pos;
        _updateActiveWord(); // 🆕 PHASE 2: Word-level tracking enabled
        notifyListeners();
      }
    });

    _durationSubscription = _audioService.onDurationChanged.listen((dur) {
      totalDuration = dur ?? Duration.zero;
      notifyListeners();
    });

    _audioService.downloadingNotifier.addListener(_onDownloadStatusChanged);
    _audioService.transitioningNotifier.addListener(_onTransitionStatusChanged);
    _audioService.surahChangedNotifier.addListener(_onSurahAutoChanged);

    fetchTimestamps(surahId);
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioService.downloadingNotifier.removeListener(_onDownloadStatusChanged);
    _audioService.transitioningNotifier.removeListener(_onTransitionStatusChanged);
    _audioService.surahChangedNotifier.removeListener(_onSurahAutoChanged);
    super.dispose();
  }

  void _onDownloadStatusChanged() {
    isDownloading = _audioService.downloadingNotifier.value;
    notifyListeners();
  }

  void _onTransitionStatusChanged() {
    isTransitioning = _audioService.transitioningNotifier.value;
    notifyListeners();
  }

  void _onSurahAutoChanged() {
    final newId = _audioService.currentSurahId;
    if (newId != null && newId != currentSurahId) {
       debugPrint("QuranAudioController: Auto-Surah change detected -> $newId");
       currentSurahId = newId; 
       fetchTimestamps(newId);
       notifyListeners();
    }
  }

  Future<void> fetchTimestamps(int surahId) async {
    // 🆕 PHASE 2: TEMPORARILY DISABLED - Use legacy ayah-level until word segments tested
    // Word segment loading was causing audio playback issues
    
    // Reset state when context switching
    if (!isPlaying) {
      currentPosition = Duration.zero;
      activeAyahId = null;
      activeWordIndex = null;
    }
    
    // Clear segments immediately if ID mismatch
    if (ayahSegments.isNotEmpty && ayahSegments.first.surahId != surahId) {
      wordSegments = [];
      ayahSegments = [];
      activeAyahId = null;
      activeWordIndex = null;
    }

    // 🔧 HOTFIX: Use legacy ayah-level loading for now
    // Word segments will be enabled after UI integration is tested
    // await _fetchLegacyAyahTimestamps(surahId); // Replaced by below block
    
    // ENABLED: Word-level Sync
    try {
      // Load word segments from Phase 1 data layer
      final segments = await _audioService.getWordSegments(surahId);
      
      if (segments.isNotEmpty) {
        wordSegments = segments;
        
        // Also build ayah segments for backward compatibility (SmartFollow, etc.)
        ayahSegments = _buildAyahSegmentsFromWords(segments, surahId);
        
        _maxAyahIdSeen = -1000;
        _updateActiveWord();
        
        debugPrint("QuranAudioController: Loaded ${segments.length} word segments for Surah $surahId");
      } else {
         throw Exception("No word segments found");
      }
    } catch (e) {
      debugPrint("QuranAudioController: Error loading word segments: $e");
      // Fallback to legacy ayah-level if word segments fail
      await _fetchLegacyAyahTimestamps(surahId);
    }
    
    /* DISABLED UNTIL TESTED:
    try {
      // Load word segments from Phase 1 data layer
      final segments = await _audioService.getWordSegments(surahId);
      
      if (segments.isNotEmpty) {
        wordSegments = segments;
        
        // Also build ayah segments for backward compatibility (SmartFollow, etc.)
        ayahSegments = _buildAyahSegmentsFromWords(segments, surahId);
        
        _maxAyahIdSeen = -1000;
        _updateActiveWord();
        
        debugPrint("QuranAudioController: Loaded ${segments.length} word segments for Surah $surahId");
      }
    } catch (e) {
      debugPrint("QuranAudioController: Error loading word segments: $e");
      // Fallback to legacy ayah-level if word segments fail
      await _fetchLegacyAyahTimestamps(surahId);
    }
    */
    
    notifyListeners();
  }
  
  /// Builds ayah-level segments from word segments for backward compatibility
  List<AyahSegment> _buildAyahSegmentsFromWords(List<WordSegment> words, int surahId) {
    if (words.isEmpty) return [];
    
    final Map<int, List<WordSegment>> ayahGroups = {};
    for (var word in words) {
      ayahGroups.putIfAbsent(word.ayahNumber, () => []).add(word);
    }
    
    return ayahGroups.entries.map((entry) {
      final ayahWords = entry.value;
      return AyahSegment(
        surahId: surahId,
        ayahNumber: entry.key,
        timestampFrom: ayahWords.first.timestampFrom,
        timestampTo: ayahWords.last.timestampTo,
      );
    }).toList();
  }
  
  /// Legacy fallback for ayah-level timestamps (if word segments fail)
  Future<void> _fetchLegacyAyahTimestamps(int surahId) async {
    final segments = await _audioService.getAyahTimestamps(surahId);
    
    List<AyahSegment> finalSegments = [];
    int bismillahDuration = 0;
    if (surahId != 1 && surahId != 9) {
      bismillahDuration = ReciterManifest.getBismillahOffset(
        _audioService.currentQuranReciter,
        surahId,
      );
    }

    if (bismillahDuration > 0 && segments.isNotEmpty) {
      debugPrint("QuranAudioController: Applying Bismillah offset ${bismillahDuration}ms to Surah $surahId (LEGACY MODE)");
      finalSegments.add(AyahSegment(
        surahId: surahId,
        ayahNumber: bismillahId,
        timestampFrom: 0,
        timestampTo: bismillahDuration,
      ));

      for (var segment in segments) {
        finalSegments.add(AyahSegment(
          surahId: surahId,
          ayahNumber: segment.ayahNumber,
          timestampFrom: segment.timestampFrom + bismillahDuration,
          timestampTo: segment.timestampTo + bismillahDuration,
        ));
      }
    } else {
      finalSegments = List.from(segments);
    }

    if (finalSegments.isNotEmpty) {
      ayahSegments = finalSegments;
      _maxAyahIdSeen = -1000;
      _updateActiveAyah();
    }
  }

  /// Explicitly resets the timing context for a surah.
  /// Used during browsing to ensure states don't bleed between surahs.
  void resetPlayingContext() {
    activeAyahId = null;
    activePageNumber = null; // 🔧 FIX: Reset active page
    activeWordIndex = null; // 🆕 PHASE 2
    currentPosition = Duration.zero;
    _maxAyahIdSeen = -1000;
    notifyListeners();
  }

  /// 🆕 PHASE 2: Word-level tracking (replaces _updateActiveAyah for word segments)
  void _updateActiveWord() {
    // Fallback to legacy ayah tracking if no word segments
    if (wordSegments.isEmpty) {
      _updateActiveAyah();
      return;
    }
    
    if (isTransitioning || isDownloading) return;

    // Context guard: Prevent stale data leakage
    if (wordSegments.first.surahId != currentSurahId) {
      debugPrint("QuranAudioController: GUARD BLOCKED WORD UPDATE. Data(${wordSegments.first.surahId}) != Active($currentSurahId)");
      return;
    }

    final currentMs = currentPosition.inMilliseconds;
    
    // 🎯 NO LOOKAHEAD NEEDED: Word timestamps are precise!
    // This eliminates the +85ms hack from the legacy system
    
    WordSegment? foundWord;
    for (var word in wordSegments) {
      if (currentMs >= word.timestampFrom && currentMs < word.timestampTo) {
        foundWord = word;
        break; // Word segments don't overlap, so first match is correct
      }
    }

    if (foundWord != null) {
      final newAyahId = foundWord.ayahNumber;
      final newWordIndex = foundWord.wordIndex;
      
      // Avoid highlighting before playback starts
      if (!isPlaying && currentMs < 10) {
        if (activeAyahId != null || activeWordIndex != null) {
          activeAyahId = null;
          activeWordIndex = null;
          notifyListeners();
        }
        return;
      }

      // Update if word changed
      if (newAyahId != activeAyahId || newWordIndex != activeWordIndex) {
        if (_audioService.currentSurahId == currentSurahId) {
          if (isPlaying || currentPosition.inMilliseconds < 1000) {
            debugPrint("QuranAudioController: Word change detected! $activeAyahId:$activeWordIndex -> $newAyahId:$newWordIndex at ${currentMs}ms");
            activeAyahId = newAyahId;
            activeWordIndex = newWordIndex;
            _maxAyahIdSeen = (newAyahId > _maxAyahIdSeen) ? newAyahId : _maxAyahIdSeen;
          }
        } else {
          if (activeAyahId != null || activeWordIndex != null) {
            activeAyahId = null;
            activeWordIndex = null;
          }
        }
      }
    }
  }

  /// Legacy ayah-level tracking (kept for backward compatibility)
  void _updateActiveAyah() {
    if (ayahSegments.isEmpty || isTransitioning || isDownloading) return;

    // 🛑 SYNC 2.0: Strict Context Guard
    // Prevents "Data Leakage" where stale segments from Surah A are applied to Surah B's position.
    // This handles the rapid-switch race condition.
    if (ayahSegments.first.surahId != currentSurahId) {
       debugPrint("QuranAudioController: GUARD BLOCKED UPDATE. Data(${ayahSegments.first.surahId}) != Active($currentSurahId)");
       return;
    }

    final currentMs = currentPosition.inMilliseconds;
    int? foundAyahId;

    // 🎯 SYNC FIX: Add small delay to match reciter voice
    // Highlighting was moving slightly ahead of reciter
    // Delay by 150ms to better sync with actual pronunciation
    final lookupMs = currentMs - 150;

    // 🛑 DATA FIX: Handle Overlapping Segments
    // Some QDC timestamps have slight overlaps where End(Ayah X) > Start(Ayah X+1).
    // If we simply `break` on the first match, we might pick the Previous Ayah at the exact boundary.
    // Solution: Collect all candidates and pick the one with the HIGHEST timestampFrom (The latest starting one).
    
    AyahSegment? bestMatch;
    for (var segment in ayahSegments) {
      if (lookupMs >= segment.timestampFrom && lookupMs < segment.timestampTo) {
        if (bestMatch == null || segment.timestampFrom > bestMatch.timestampFrom) {
          bestMatch = segment;
        }
      }
    }
    foundAyahId = bestMatch?.ayahNumber;

    if (foundAyahId != null && foundAyahId != activeAyahId) {
      // 🛑 UX FIX: Avoid highlighting before playback starts or if paused at 0.
      if (!isPlaying && currentMs < 10) {
        if (activeAyahId != null) {
          activeAyahId = null;
          notifyListeners();
        }
        return;
      }

      // Logic for updating active ayah
      // 1. If we are playing, always update to the current segment found.
      // 2. If we are paused, only update if the jump is significant (to avoid micro-jitter).
      
      bool isSignificantJump = (currentMs - (ayahSegments.firstWhere((s) => s.ayahNumber == activeAyahId, orElse: () => AyahSegment(ayahNumber: -1, timestampFrom: 0, timestampTo: 0)).timestampFrom)).abs() > 500;

      if (_audioService.currentSurahId == currentSurahId) {
        if (isPlaying || isSignificantJump || currentPosition.inMilliseconds < 1000) {
          debugPrint("QuranAudioController: Ayah change detected! $activeAyahId -> $foundAyahId at ${currentMs}ms");
          activeAyahId = foundAyahId;
          _maxAyahIdSeen = (foundAyahId > _maxAyahIdSeen) ? foundAyahId : _maxAyahIdSeen;
        }
      } else {
        if (activeAyahId != null) activeAyahId = null;
      }
    }
  }

  int _lastGuidedPage = -1;

  // Smart Follow Logic (Auto Page Turn)
  // This is kept here as it's audio-driven, but the PageController is external.
  void handleSmartFollow(PageController pageController, int currentVisualPage, QuranSurah surah) {
    // 🛑 UX FIX: If user is actively browsing or swipe intent is set, do nothing.
    if (isBrowsing) {
       _lastGuidedPage = -1; 
       return;
    }

    if (isPlaying && activeAyahId != null && activeAyahId! > 0) {
      if (activeAyahId! < 1 || activeAyahId! > surah.ayahs.length) return;

      final qs = QuranPageService();
      final visualPage = (pageController.page?.round() ?? currentVisualPage) + 1;
      
      // 🛑 UX FIX: Stabilization Check 🛑
      // Before calculating ANY jump, check if the ayah is ALREADY visible on the current page.
      final pageData = qs.getPageData(visualPage);
      bool isVisibleOnCurrentPage = false;
      for (var entry in pageData) {
        if (entry['surah'] == surah.id && 
            activeAyahId! >= entry['start']! && 
            activeAyahId! <= entry['end']!) {
           isVisibleOnCurrentPage = true;
           break;
        }
      }

      if (isVisibleOnCurrentPage) {
        return; 
      }

      final audioPage = qs.getPageNumber(surah.id, activeAyahId!);

      // 🛑 UX FIX: Smarter Follow Gate 🛑
      // If audio is on a NEW page (not visualPage), we only turn if:
      // 1. User is not too far away (within 1 page). If they swiped 2+ pages ahead/back, we stop fighting them.
      // 2. We use a guard to ensure we don't spam animateToPage.
      
      final pageDiff = audioPage - visualPage;
      if (pageDiff != 0) {
        // Only follow if the difference is 1 (next page) or -1 (previous page)
        // AND if the audio actually JUST moved into that page.
        if (pageDiff.abs() == 1) {
          if (_lastGuidedPage == audioPage) return; // Debounce redundant animations
          _lastGuidedPage = audioPage;
          isProgrammaticScroll = true; // Set flag to skip isBrowsing in UI

          debugPrint("QuranAudioController: SmartFollow triggering. AudioPage: $audioPage, VisualPage: $visualPage");
          pageController.animateToPage(
            audioPage - 1,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          // User is browsing far away, don't interrupt them.
          // debugPrint("QuranAudioController: SmartFollow suppressed. User is at page $visualPage, audio is at $audioPage");
        }
      }
    }
  }

  int? _lastRequestedAyahId;
  DateTime? _lastIntentTime;

  // Playback Controls
  void playSurah(int surahId, {int? ayahNumber}) {
    // 🛑 UX FIX: Duplicate Intent Guard (Robust)
    // Prevents rapid-fire taps (Tap + DoubleTap conflict) from resetting the player.
    // We check against the LAST REQUESTED Ayah, not the async activeAyahId state.
    if (ayahNumber != null) {
      final now = DateTime.now();
      if (surahId == currentSurahId && 
          _lastRequestedAyahId == ayahNumber && 
          _lastIntentTime != null && 
          now.difference(_lastIntentTime!) < const Duration(milliseconds: 500)) {
        // debugPrint("QuranAudioController: Ignored duplicate play intent for Ayah $ayahNumber");
        return;
      }
      _lastIntentTime = now;
      _lastRequestedAyahId = ayahNumber;
    } else {
      // General Surah Play shouldn't block specific Ayah seeks, but should track time
      _lastIntentTime = DateTime.now();
      _lastRequestedAyahId = null;
    }

    isBrowsing = false; 
    currentSurahId = surahId; 
    
    // 🛑 SYNC FIX: Explicitly fetch timestamps for manual interaction
    // This ensures segments are ready even if auto-sync is skipped due to duplicate IDs.
    fetchTimestamps(surahId);
    
    _audioService.playSurah(surahId, ayahNumber: ayahNumber);
  }

  void pause() => _audioService.pause();
  void resume() => _audioService.resume();
  void stop() => _audioService.stop();
  void seek(Duration position) => _audioService.seek(position);
}
