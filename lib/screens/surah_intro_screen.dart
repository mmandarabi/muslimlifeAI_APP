import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/models/quran_surah.dart';
import 'package:muslim_mind/models/quran_display_names.dart';
import 'package:muslim_mind/screens/quran_read_mode.dart';
import 'package:muslim_mind/screens/quran_screen.dart'; // Audio Practice Mode
import 'package:muslim_mind/services/ai_chat_service.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:muslim_mind/widgets/glass_card.dart';
import 'package:quran/quran.dart' as quran;

class SurahIntroScreen extends StatefulWidget {
  final int surahId;

  const SurahIntroScreen({super.key, required this.surahId});

  @override
  State<SurahIntroScreen> createState() => _SurahIntroScreenState();
}

class _SurahIntroScreenState extends State<SurahIntroScreen> {
  String _aiSummary = "Asking MuslimMind AI for spiritual insights...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    try {
      final summary = await AiService().sendMessage(
        "Generate a 2-sentence spiritual summary of Surah ${widget.surahId} (${quran.getSurahName(widget.surahId)}). Focus on its key themes and lessons.",
      );
      if (mounted) {
        setState(() {
          _aiSummary = summary;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiSummary = "Unable to reach MuslimMind AI at the moment.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surahName = quran.getSurahName(widget.surahId);
    final arabicName = kUthmaniSurahTitles[widget.surahId] ?? quran.getSurahNameArabic(widget.surahId);
    final verseCount = quran.getVerseCount(widget.surahId);
    final place = quran.getPlaceOfRevelation(widget.surahId);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.getBackgroundColor(context),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Nav
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(LucideIcons.x, color: AppColors.getTextPrimary(context)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Arabic Title
                        Text(
                          arabicName,
                          style: TextStyle(
                            fontFamily: 'KFGQPCUthmanic',
                            fontSize: 80, // 7xl visual equivalent
                            color: AppColors.accent,
                            height: 1.2,
                            shadows: [
                              Shadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 10))
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Surah $surahName",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTag(context, "$verseCount Ayahs"),
                            const SizedBox(width: 12),
                            _buildTag(context, place),
                          ],
                        ),
                        
                        const SizedBox(height: 48),

                        // Gemini Summary
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(LucideIcons.sparkles, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 12),
                                  Text("Spiritual Insight", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  _aiSummary,
                                  key: ValueKey(_aiSummary),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Read Mode
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuranReadMode(
                                  surahId: widget.surahId,
                                  surahName: surahName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(LucideIcons.book_open),
                          label: const Text("Start Reading"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                             // Practice/Audio Mode
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuranScreen( // This is the Practice Mode screen
                                  surahId: widget.surahId,
                                  surahName: surahName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(LucideIcons.headphones),
                          label: const Text("Listen & Practice"),
                           style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.getTextPrimary(context),
                            side: BorderSide(color: AppColors.getTextSecondary(context).withOpacity(0.3)),
                            textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.getTextPrimary(context).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getTextPrimary(context).withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1,
        ),
      ),
    );
  }
}
