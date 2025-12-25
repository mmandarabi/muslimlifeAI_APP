import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/services/quran_favorite_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/models/quran_display_names.dart';
import 'package:muslim_mind/config/navigation_key.dart';

class ExpandableAudioPlayer extends StatefulWidget {
  const ExpandableAudioPlayer({super.key});

  @override
  State<ExpandableAudioPlayer> createState() => _ExpandableAudioPlayerState();
}

class _ExpandableAudioPlayerState extends State<ExpandableAudioPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  final UnifiedAudioService _audioService = UnifiedAudioService();
  final QuranFavoriteService _favoriteService = QuranFavoriteService();
  
  // Drag state
  double _dragStart = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta! / MediaQuery.of(context).size.height;
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.forward();
      setState(() => _isExpanded = true);
    } else {
      _controller.reverse();
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ValueListenableBuilder<SurahContext?>(
      valueListenable: _audioService.currentSurahContext,
      builder: (context, surah, child) {
        debugPrint("ExpandableAudioPlayer: Build. Surah: ${surah?.surahName ?? 'NULL'}");
        if (surah == null) return const SizedBox.shrink();

        return ValueListenableBuilder<double>(
          valueListenable: _audioService.playerBottomPadding,
          builder: (context, dynamicBottomPadding, _) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                // Transition values
                final playerHeight = lerpDouble(72.0, screenHeight, t)!;
                final borderRadius = lerpDouble(20.0, 0.0, t)!;
                final horizontalPadding = lerpDouble(16.0, 0.0, t)!;
                // dynamicBottomPadding is the "Resting" position (Mini player)
                // When expanded (t=1.0), it should be 0.
                final safeAreaOffset = (1 - t) * bottomPadding;
                final bottomPos = lerpDouble(dynamicBottomPadding, 0.0, t)! + safeAreaOffset;

                return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: bottomPos,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                    height: playerHeight,
                    child: GestureDetector(
                      onVerticalDragUpdate: _handleVerticalDragUpdate,
                      onVerticalDragEnd: _handleVerticalDragEnd,
                      onTap: t < 0.1 ? _toggleExpanded : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: t < 0.1 ? Border.all(color: Colors.white.withOpacity(0.12)) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5 * (1 - t)),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              // 1. BACKGROUND LAYER (Strictly Raisin Black #202124)
                              // 🛑 UX REQ: Strict color match, no transparency/glass in Mini Mode to ensure visibility and brand alignment.
                              Positioned.fill(
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: const Color(0xFF202124), // Raisin Black
                                     borderRadius: BorderRadius.circular(borderRadius),
                                   ),
                                 ),
                              ),
      
                              // 2. MINI MODE CONTENT
                              if (t < 0.5)
                                Opacity(
                                  opacity: (1 - t * 2).clamp(0.0, 1.0),
                                  child: _buildMiniPlayer(surah),
                                ),
                              
                              // 3. FULL MODE CONTENT
                              if (t > 0.5)
                                Opacity(
                                  opacity: ((t - 0.5) * 2).clamp(0.0, 1.0),
                                  child: _buildFullPlayer(surah),
                                ),

                              // 🛑 UI FIX: Local Overlay for Selectors (Guaranteed Top Z-Index)
                              if (_activeOverlay != null)
                                Positioned.fill(child: _activeOverlay!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMiniPlayer(SurahContext surah) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF35363A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/islamic_pattern_bg.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.2),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kUthmaniSurahTitles[surah.surahId] ?? surah.surahName,
                  style: GoogleFonts.amiri(
                    color: AppColors.textPrimaryDark,
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
                Text(
                  surah.surahName.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondaryDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Controls
          StreamBuilder(
            stream: _audioService.onPlayerStateChanged,
            builder: (context, _) {
              final isPlaying = _audioService.isPlaying;
              return ValueListenableBuilder<bool>(
                valueListenable: _audioService.downloadingNotifier,
                builder: (context, isDownloading, child) {
                  if (isDownloading) {
                    return const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    );
                  }
                  return IconButton(
                    icon: Icon(isPlaying ? LucideIcons.pause : LucideIcons.play, color: Colors.white),
                    onPressed: () => isPlaying ? _audioService.pause() : _audioService.resume(),
                  );
                },
              );
            },
          ),
          // 🛑 UX REQ: 'X' Button to completely stop and close the player
          IconButton(
            icon: const Icon(LucideIcons.x, color: Colors.white, size: 24),
            onPressed: () {
               HapticFeedback.mediumImpact();
               _audioService.stop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFullPlayer(SurahContext surah) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.chevron_down, color: Colors.white),
                  onPressed: _toggleExpanded,
                ),
                Column(
                  children: [
                    Text(
                      "LISTEN TO RECITATION FROM",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "AL QURAN",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // 🛑 UX REQ: 'X' Button in Full Player as well
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white),
                  onPressed: () {
                    _toggleExpanded(); // Collapse first
                    Future.delayed(const Duration(milliseconds: 300), () {
                       _audioService.stop();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Artwork (Hero Card Style)
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
                      // "Nano Banana" Artwork fixed to the card
                      Image.asset(
                        'assets/images/player_bg.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                      // SURA NAMES INSIDE HERO CARD
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                            FutureBuilder<bool>(
                              future: _favoriteService.isFavorite(surah.surahId),
                              builder: (context, snapshot) {
                                final isFav = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isFav ? LucideIcons.heart : LucideIcons.heart,
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
            const SizedBox(height: 60),
            // Progress Bar
            _buildProgressBar(),
            const SizedBox(height: 48),
            // Main Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.shuffle, color: Colors.white, size: 24),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(LucideIcons.skip_back, color: Colors.white, size: 36),
                  onPressed: () => _audioService.playSurah(surah.surahId - 1),
                ),
                StreamBuilder(
                  stream: _audioService.onPlayerStateChanged,
                  builder: (context, _) {
                    final isPlaying = _audioService.isPlaying;
                    return ValueListenableBuilder<bool>(
                      valueListenable: _audioService.downloadingNotifier,
                      builder: (context, isDownloading, child) {
                        if (isDownloading) {
                           return Container(
                              width: 80, height: 80,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                              )
                           );
                        }
                        return GestureDetector(
                          onTap: () => isPlaying ? _audioService.pause() : _audioService.resume(),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? LucideIcons.pause : LucideIcons.play,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(LucideIcons.skip_forward, color: Colors.white, size: 36),
                  onPressed: () => _audioService.playSurah(surah.surahId + 1),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.repeat, color: Colors.white, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 60),
            // Footer (Speed, Reciter)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _footerButton("98", "SPEED", _showSpeedDialog),
                _footerButton("REC", "RECITER", _showReciterDialog),
                _footerButton("INF", "INFO", () {}),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _audioService.onPositionChanged,
      builder: (context, snapshot) {
        final pos = _audioService.position;
        final dur = _audioService.duration ?? Duration.zero;
        final progress = dur.inMilliseconds > 0
            ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

        return Column(
          children: [
            // Custom Seek Bar (No Overlay Dependency)
            LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onHorizontalDragStart: (details) {
                     final relativePos = details.localPosition.dx / constraints.maxWidth;
                     final newPos = dur.inMilliseconds * relativePos;
                     _audioService.seek(Duration(milliseconds: newPos.toInt()));
                  },
                  onHorizontalDragUpdate: (details) {
                     final relativePos = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                     final newPos = dur.inMilliseconds * relativePos;
                     _audioService.seek(Duration(milliseconds: newPos.toInt()));
                  },
                  onTapUp: (details) {
                     final relativePos = details.localPosition.dx / constraints.maxWidth;
                     final newPos = dur.inMilliseconds * relativePos;
                     _audioService.seek(Duration(milliseconds: newPos.toInt()));
                  },
                  child: Container(
                    height: 30, // Hit target
                    color: Colors.transparent, 
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: [
                        // Track
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Progress
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Handle (Visual Only)
                        Align(
                          alignment: Alignment(progress * 2 - 1, 0), // Map 0..1 to -1..1
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(pos), style: GoogleFonts.firaCode(color: Colors.white.withOpacity(0.5), fontSize: 12)),
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

  Widget _footerButton(String label, String sub, VoidCallback onTap) {
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
             child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
           ),
           const SizedBox(height: 4),
           Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🛑 UI FIX: Local State approach to guarantee Z-Index dominance (No Overlay/Context lookup needed)
  Widget? _activeOverlay;

  void _showOverlaySelector(String title, List<Widget> Function(VoidCallback close) itemBuilder) {
     setState(() {
       _activeOverlay = Material(
         color: Colors.black.withOpacity(0.6), // Dim background
         type: MaterialType.transparency,
         child: Stack(
           children: [
             // 1. Dismiss on tap outside
             Positioned.fill(
               child: GestureDetector(
                 onTap: () => setState(() => _activeOverlay = null),
                 behavior: HitTestBehavior.opaque,
                 child: Container(color: Colors.transparent),
               ),
             ),
             // 2. The Selector Sheet
             Align(
               alignment: Alignment.bottomCenter,
               child: Container(
                 margin: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: AppColors.cardDark,
                   borderRadius: BorderRadius.circular(24),
                   border: Border.all(color: Colors.white.withOpacity(0.1)),
                   boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
                 ),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                             IconButton(
                               icon: const Icon(Icons.close, color: Colors.white, size: 20),
                               onPressed: () => setState(() => _activeOverlay = null),
                             )
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      ...itemBuilder(() => setState(() => _activeOverlay = null)),
                      const SizedBox(height: 16),
                   ],
                 ),
               ),
             ),
           ],
         ),
       );
     });
  }

  void _showSpeedDialog() {
    _showOverlaySelector(
      "Playback Speed", 
      (close) => [
        _speedTile(1.0, close),
        _speedTile(1.25, close),
        _speedTile(1.5, close),
        _speedTile(2.0, close),
      ]
    );
  }
  
  // Helper for overlay tile
  Widget _speedTile(double speed, VoidCallback close) {
     final isSelected = _audioService.playbackSpeed == speed;
     return ListTile(
       title: Text("${speed}x", style: TextStyle(color: isSelected ? AppColors.primary : Colors.white)),
       trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
       onTap: () {
         _audioService.setSpeed(speed);
         close();
         setState(() {});
       },
     );
  }

  void _showReciterDialog() {
    _showOverlaySelector(
      "Select Reciter", 
      (close) => [
        _reciterTile("sudais", "Abdurrahman as-Sudais", close),
        _reciterTile("saad", "Saad al-Ghamidi", close),
        _reciterTile("mishary", "Mishary al-Afasy", close),
      ]
    );
  }

  Widget _reciterTile(String id, String name, VoidCallback close) {
    final isSelected = _audioService.currentQuranReciter == id;
    return ListTile(
      title: Text(name, style: TextStyle(color: isSelected ? AppColors.primary : Colors.white)),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        _audioService.setQuranReciter(id);
        close();
        setState(() {});
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
