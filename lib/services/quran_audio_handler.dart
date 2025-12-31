import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../services/unified_audio_service.dart';

/// 🆕 PHASE 2.5: Audio handler for background playback
/// Wraps UnifiedAudioService to provide media notifications and lock screen controls
class QuranAudioHandler extends BaseAudioHandler with SeekHandler {
  final UnifiedAudioService _audioService = UnifiedAudioService();
  
  QuranAudioHandler() {
    // Listen to audio service state changes and update media item
    _audioService.onPlayerStateChanged.listen((state) {
      playbackState.add(playbackState.value.copyWith(
        playing: state.playing,
        processingState: _mapProcessingState(state.processingState),
      ));
    });
    
    // Listen to position changes
    _audioService.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });
    
    // Listen to duration changes
    _audioService.onDurationChanged.listen((duration) {
      if (duration != null) {
        mediaItem.add(mediaItem.value?.copyWith(duration: duration));
      }
    });
    
    // Listen to surah context changes to update media item
    _audioService.currentSurahContext.addListener(_updateMediaItem);
  }
  
  /// Maps just_audio ProcessingState to audio_service AudioProcessingState
  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }
  
  /// Updates the media item when surah changes
  void _updateMediaItem() {
    final context = _audioService.currentSurahContext.value;
    if (context != null) {
      mediaItem.add(MediaItem(
        id: context.surahId.toString(),
        title: context.surahName,
        artist: 'Quran Recitation',
        artUri: Uri.parse('asset:///assets/images/islamic_pattern_bg.png'),
        duration: _audioService.duration,
      ));
    }
  }
  
  @override
  Future<void> play() async {
    await _audioService.resume();
  }
  
  @override
  Future<void> pause() async {
    await _audioService.pause();
  }
  
  @override
  Future<void> stop() async {
    await _audioService.stop();
    await super.stop();
  }
  
  @override
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }
  
  @override
  Future<void> skipToNext() async {
    final currentId = _audioService.currentSurahId;
    if (currentId != null && currentId < 114) {
      await _audioService.playSurah(currentId + 1);
    }
  }
  
  @override
  Future<void> skipToPrevious() async {
    final currentId = _audioService.currentSurahId;
    if (currentId != null && currentId > 1) {
      await _audioService.playSurah(currentId - 1);
    }
  }
  
  @override
  Future<void> setSpeed(double speed) async {
    await _audioService.setSpeed(speed);
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }
  
  /// Custom action to change reciter
  Future<void> setReciter(String reciterId) async {
    await _audioService.setQuranReciter(reciterId);
  }
  
  /// Custom action to set loop mode
  Future<void> setLoopMode(LoopMode mode) async {
    await _audioService.setLoopMode(mode);
  }
}
