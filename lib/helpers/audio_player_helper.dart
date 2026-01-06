import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/quran_favorite_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/models/quran_display_names.dart';
import 'package:muslim_mind/config/navigation_key.dart';

/// Phase 2: Global state to track if expanded player is open
/// This ensures mini player hides when expanded player is visible
final ValueNotifier<bool> isExpandedPlayerOpen = ValueNotifier(false);

/// Global function to show the expanded audio player modal
/// Single source of truth for opening the audio player from anywhere
void showExpandedAudioPlayer(BuildContext context) {
  debugPrint('🎵 showExpandedAudioPlayer: Called');
  
  final audioService = UnifiedAudioService();
  
  // Phase 4: Check if transitioning between tracks
  if (audioService.isTransitioning) {
    debugPrint('🎵 showExpandedAudioPlayer: Audio is transitioning, showing loading toast');
    
    // Show loading toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading...'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }
  
  final surahContext = audioService.currentSurahContext.value;
  
  if (surahContext == null) {
    debugPrint('🎵 showExpandedAudioPlayer: No surah context available');
    return;
  }

  debugPrint('🎵 showExpandedAudioPlayer: Opening modal for ${surahContext.surahName}');
  
  // Use rootNavigatorKey to access Navigator from global scope
  final navigatorContext = rootNavigatorKey.currentContext;
  if (navigatorContext == null) {
    debugPrint('🎵 showExpandedAudioPlayer: Navigator context not available');
    return;
  }
  
  // Phase 2: Signal that expanded player is opening
  isExpandedPlayerOpen.value = true;
  
  showModalBottomSheet(
    context: navigatorContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // Sanctuary smooth animation (450ms with elegant easing)
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(navigatorContext),
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(milliseconds: 400),
    )..forward(),
    // Phase 3: No longer pass static surah - use live context inside
    builder: (context) => const _GlobalAudioPlayerSheet(),
  ).then((_) {
    // Phase 2: Restore mini player when modal closes
    isExpandedPlayerOpen.value = false;
  });
}

/// The expanded audio player sheet (internal use only)
/// Phase 3: No longer takes static surah parameter - uses live context
class _GlobalAudioPlayerSheet extends StatefulWidget {
  const _GlobalAudioPlayerSheet();

  @override
  State<_GlobalAudioPlayerSheet> createState() => _GlobalAudioPlayerSheetState();
}

class _GlobalAudioPlayerSheetState extends State<_GlobalAudioPlayerSheet> {
  final UnifiedAudioService _audioService = UnifiedAudioService();
  final QuranFavoriteService _favoriteService = QuranFavoriteService();

  @override
  Widget build(BuildContext context) {
    // Phase 3: Listen to live surah context for real-time updates
    return ValueListenableBuilder<SurahContext?>(
      valueListenable: _audioService.currentSurahContext,
      builder: (context, surah, child) {
        // Close modal if surah context becomes null
        if (surah == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          return const SizedBox.shrink();
        }

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF202124), // Full opacity - completely covers mini player
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.chevron_down, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            "NOW PLAYING",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 48), // Balance
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Artwork with Hero Overlay
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 40,
                                      offset: const Offset(0, 20),
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Stack(
                                    children: [
                                      // Background image
                                      Image.asset(
                                        'assets/images/player_bg.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF202124),
                                          child: const Center(
                                            child: Icon(LucideIcons.music, size: 64, color: Colors.white24),
                                          ),
                                        ),
                                      ),
                                      // Gradient overlay for text readability
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.8),
                                            ],
                                            stops: const [0.6, 1.0],
                                          ),
                                        ),
                                      ),
                                      // Surah names (bottom-left) + Favorite (bottom-right)
                                      Positioned(
                                        bottom: 24,
                                        left: 24,
                                        right: 24,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Surah names
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    kUthmaniSurahTitles[surah.surahId] ?? surah.surahName,
                                                    style: GoogleFonts.amiri(
                                                      color: AppColors.accent, // Gold
                                                      fontSize: 32,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  Text(
                                                    surah.surahName,
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Favorite button
                                            FutureBuilder<bool>(
                                              future: _favoriteService.isFavorite(surah.surahId),
                                              builder: (context, snapshot) {
                                                final isFav = snapshot.data ?? false;
                                                return IconButton(
                                                  icon: Icon(
                                                    LucideIcons.heart,
                                                    color: isFav ? AppColors.primary : Colors.white.withOpacity(0.8),
                                                    fill: isFav ? 1.0 : 0.0,
                                                  ),
                                                  iconSize: 28,
                                                  onPressed: () async {
                                                    await _favoriteService.toggleFavorite(surah.surahId);
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Progress Bar
                            _buildProgressBar(),
                            const SizedBox(height: 40),
                            // Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Playlist (dimmed, placeholder)
                                Opacity(
                                  opacity: 0.3,
                                  child: IconButton(
                                    icon: const Icon(LucideIcons.list_music, color: Colors.white, size: 24),
                                    onPressed: () {}, // Placeholder
                                  ),
                                ),
                                // Skip back
                                IconButton(
                                  icon: const Icon(LucideIcons.skip_back, color: Colors.white, size: 36),
                                  onPressed: () => _audioService.playSurah(surah.surahId - 1),
                                ),
                                // Play/Pause
                                StreamBuilder(
                                  stream: _audioService.onPlayerStateChanged,
                                  builder: (context, _) {
                                    final isPlaying = _audioService.isPlaying;
                                    // Check if audio is loading/buffering
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: _audioService.downloadingNotifier,
                                      builder: (context, isDownloading, child) {
                                        return IconButton.filled(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.all(24),
                                            iconSize: 32,
                                          ),
                                          // Show loading indicator when buffering
                                          icon: isDownloading
                                              ? const SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.black,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : Icon(isPlaying ? LucideIcons.pause : LucideIcons.play),
                                          onPressed: isDownloading 
                                              ? null 
                                              : () => isPlaying ? _audioService.pause() : _audioService.resume(),
                                        );
                                      },
                                    );
                                  },
                                ),
                                // Skip forward
                                IconButton(
                                  icon: const Icon(LucideIcons.skip_forward, color: Colors.white, size: 36),
                                  onPressed: () => _audioService.playSurah(surah.surahId + 1),
                                ),
                                // Repeat button
                                StreamBuilder<LoopMode>(
                                  stream: _audioService.onPlayerStateChanged.map((s) => _audioService.loopMode),
                                  builder: (context, snapshot) {
                                    final loopMode = _audioService.loopMode;
                                    final isLooping = loopMode != LoopMode.off;
                                    return IconButton(
                                      icon: Icon(
                                        loopMode == LoopMode.one ? LucideIcons.repeat_1 : LucideIcons.repeat,
                                        color: isLooping ? AppColors.primary : Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        final nextMode = loopMode == LoopMode.off
                                            ? LoopMode.all
                                            : (loopMode == LoopMode.all ? LoopMode.one : LoopMode.off);
                                        _audioService.setLoopMode(nextMode);
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            // Action Row (Speed, Reciter, Info)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _footerButton(
                                  _getSpeedDisplay(),
                                  "SPEED",
                                  () => _showSpeedSelector(context),
                                ),
                                _footerButton(
                                  "REC",
                                  "RECITER",
                                  () => _showReciterSelector(context),
                                ),
                                _footerButton(
                                  "INF",
                                  "INFO",
                                  () {}, // Placeholder
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _audioService.onPositionChanged,
      builder: (context, snapshot) {
        final pos = _audioService.position;
        final dur = _audioService.duration ?? Duration.zero;
        final value = dur.inMilliseconds > 0
            ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
                thumbColor: Colors.white,
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                value: value,
                onChanged: (v) {
                  final newPos = dur.inMilliseconds * v;
                  _audioService.seek(Duration(milliseconds: newPos.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(pos), style: GoogleFonts.firaCode(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  // Quality badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("HIGH", style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  Text(_formatDuration(dur), style: GoogleFonts.firaCode(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // Action row helper widget
  Widget _footerButton(String label, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Get speed display as whole number (1.0 → "100", 0.75 → "75")
  String _getSpeedDisplay() {
    final speed = _audioService.playbackSpeed;
    return (speed * 100).toInt().toString();
  }

  // Speed selector modal
  void _showSpeedSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Playback Speed",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white10),
            _speedTile(0.75, context),
            _speedTile(1.0, context),
            _speedTile(1.25, context),
            _speedTile(1.5, context),
            _speedTile(2.0, context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _speedTile(double speed, BuildContext context) {
    final isSelected = _audioService.playbackSpeed == speed;
    return ListTile(
      title: Text(
        "${speed}x",
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.white,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
      onTap: () {
        _audioService.setSpeed(speed);
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  // Reciter selector modal
  void _showReciterSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Reciter",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white10),
            _reciterTile("sudais", "Abdur-Rahman As-Sudais", context),
            _reciterTile("husary", "Mahmoud Khalil Al-Husary", context),
            _reciterTile("abdul_basit", "Abdul Basit Abdul Samad", context),
            _reciterTile("alafasy", "Mishari Rashid Alafasy", context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _reciterTile(String id, String name, BuildContext context) {
    final isSelected = _audioService.currentQuranReciter == id;
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.white,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
      onTap: () async {
        await _audioService.setQuranReciter(id);
        Navigator.pop(context);
        
        // Reload current surah with new reciter
        final currentSurah = _audioService.currentSurahContext.value;
        if (currentSurah != null) {
          await _audioService.playSurah(currentSurah.surahId);
        }
        
        setState(() {});
      },
    );
  }
}
