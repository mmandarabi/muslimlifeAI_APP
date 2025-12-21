import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/services/unified_audio_service.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'package:muslim_life_ai_demo/screens/quran_read_mode.dart';

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
                    child: GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          // 1. Play/Pause Controller
                          StreamBuilder(
                            stream: audioService.onPlayerStateChanged,
                            builder: (context, snapshot) {
                              final isPlaying = audioService.isPlaying;
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (isPlaying) {
                                        await audioService.pause();
                                      } else {
                                        await audioService.resume();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isPlaying ? LucideIcons.pause : LucideIcons.play,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              );
                            },
                          ),

                          // 2. Info
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surahContext.surahName,
                                  style: GoogleFonts.outfit(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Recitation continues...",
                                  style: GoogleFonts.inter(
                                    color: secondaryTextColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3. Mini Progress & Stop
                          StreamBuilder<Duration>(
                            stream: audioService.onPositionChanged,
                            builder: (context, snapshot) {
                              final pos = audioService.position;
                              final dur = audioService.duration ?? Duration.zero;
                              final progress = dur.inMilliseconds > 0
                                  ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                                  : 0.0;

                              return Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 2,
                                      backgroundColor: textColor.withValues(alpha: 0.1),
                                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      audioService.stop();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(LucideIcons.x, color: secondaryTextColor.withValues(alpha: 0.5), size: 18),
                                    ),
                                  ),
                                ],
                              );
                            },
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
}
