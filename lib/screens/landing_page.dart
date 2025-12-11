import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_life_ai_demo/screens/intro_screen.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/grid_painter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _infoSectionKey = GlobalKey();

  void _scrollToInfo() {
    Scrollable.ensureVisible(
      _infoSectionKey.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _showHowItWorks() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How It Works",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildBulletPoint("AI-Powered spiritual guidance tailored to you."),
              _buildBulletPoint("Privacy-first design with on-device processing."),
              _buildBulletPoint("Verified sources from Quran and Sunnah."),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToApp() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const IntroScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double heroHeight = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient (Fixed)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    AppColors.background,
                  ],
                  stops: [0.0, 0.6],
                ),
              ),
            ),
          ),
          // Grid Overlay (Fixed)
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(opacity: 0.05, spacing: 50),
            ),
          ),
          
          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section (Full Height)
                SizedBox(
                  height: heroHeight,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        "MuslimLife AI",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                              color: AppColors.primary,
                              shadows: [
                                const Shadow(
                                  color: AppColors.primary,
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 800.ms).moveY(begin: 20, end: 0),
                      
                      const SizedBox(height: 24),
                      
                      // Subtitle
                      Text(
                        "Your Intelligent Companion for Prayer, Quran, and Daily Faith.",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms),
                      
                      const SizedBox(height: 64),
                      
                      // CTAs
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _scrollToInfo,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            child: const Text("Learn More"),
                          ),
                          OutlinedButton(
                            onPressed: _showHowItWorks,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            child: const Text("How It Works"),
                          ),
                          FilledButton(
                            onPressed: _navigateToApp,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            child: const Text("Try the App"),
                          ).animate().shimmer(delay: 1000.ms, duration: 2000.ms),
                        ],
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms),
                    ],
                  ),
                ),

                // Info Section
                Container(
                  key: _infoSectionKey,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                  color: Colors.black12,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        children: [
                          Text(
                            "About the Platform",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            "MuslimLife AI connects you with authenticated Islamic knowledge through a privacy-focused, AI-driven interface. Whether you are looking for accurate prayer times, Qibla direction, or a deeper understanding of the Quran, our platform adapts to your spiritual needs without compromising your data.",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 18,
                                  height: 1.6,
                                  color: Colors.white70,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "© MuslimLife AI — 2025",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
