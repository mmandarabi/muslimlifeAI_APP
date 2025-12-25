import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/services/unified_audio_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:muslim_mind/screens/quran_read_mode.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = UnifiedAudioService();
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    return ValueListenableBuilder<SurahContext?>(
      valueListenable: audioService.currentSurahContext,
      builder: (context, surahContext, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
            );
          },
          child: surahContext == null
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : Padding(
                  key: const ValueKey('player'),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranReadMode(
                            surahId: surahContext.surahId,
                            surahName: surahContext.surahName,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 72, // Slimmer profile to match image
                      child: GlassCard(
                        borderRadius: 20,
                        padding: EdgeInsets.zero,
                        opacity: 0.1,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  // 1. Thumbnail (Squircle)
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/islamic_pattern_bg.png', // Placeholder thumbnail
                                        fit: BoxFit.cover,
                                        opacity: const AlwaysStoppedAnimation(0.2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 2. Info
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          surahContext.surahName,
                                          style: GoogleFonts.outfit(
                                            color: textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "PULL UP FOR INTRO",
                                          style: GoogleFonts.inter(
                                            color: secondaryTextColor.withOpacity(0.5),
                                            fontSize: 10,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 3. Play/Pause
                                  StreamBuilder(
                                    stream: audioService.onPlayerStateChanged,
                                    builder: (context, snapshot) {
                                      final isPlaying = audioService.isPlaying;
                                      return GestureDetector(
                                        onTap: () async {
                                          if (isPlaying) {
                                            await audioService.pause();
                                          } else {
                                            await audioService.resume();
                                          }
                                        },
                                        child: Icon(
                                          isPlaying ? LucideIcons.pause : LucideIcons.play,
                                          color: textColor,
                                          size: 24,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),

                            // Progress Bar
                            Positioned(
                              left: 12, right: 12, bottom: 0,
                              child: StreamBuilder<Duration>(
                                stream: audioService.onPositionChanged,
                                builder: (context, snapshot) {
                                  final pos = audioService.position;
                                  final dur = audioService.duration ?? Duration.zero;
                                  final progress = dur.inMilliseconds > 0
                                      ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                                      : 0.0;
                                  
                                  return Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
