import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:muslim_life_ai_demo/widgets/glass_card.dart';
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _isWhisperExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Qibla Direction",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.map_pin, size: 12, color: Colors.white54),
                const SizedBox(width: 4),
                Text(
                  "Belmont, VA",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white54,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Color(0xFF064E3B), // Dark Emerald
                    Color(0xFF0B0C0E), // Deep Black
                  ],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Angle Display
                Text(
                  "293° N",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                      ),
                ),
                const SizedBox(height: 8),
                // Haptic Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.vibrate, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      "Haptic active (Accessibility Mode)",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary.withOpacity(0.8),
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Compass Visualization
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Alignment Pulse (Behind Needle)
                        Container(
                          width: 40,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1.5.seconds)
                         .fade(begin: 0.3, end: 0.7),

                        // Outer Ring
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 2,
                            ),
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        
                        // Inner Ring
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),

                        // Ticks
                        ...List.generate(12, (index) {
                          final angle = (index * 30) * (math.pi / 180);
                          return Transform.rotate(
                            angle: angle,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 2,
                                height: index % 3 == 0 ? 16 : 8,
                                color: index % 3 == 0 ? Colors.white54 : Colors.white24,
                                margin: const EdgeInsets.only(top: 10),
                              ),
                            ),
                          );
                        }),

                        // Needle
                        Transform.rotate(
                          angle: -20 * (math.pi / 180), // Offset to match 293 approx
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // North Tip
                              Container(
                                width: 16,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Icon(LucideIcons.arrow_up, color: Colors.black, size: 12),
                                  ],
                                ),
                              ),
                              // Center Pivot
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary, width: 4),
                                ),
                              ),
                              // South Tip
                              Container(
                                width: 16,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom Tip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    borderRadius: 30,
                    child: Row(
                      children: [
                        const Icon(LucideIcons.info, color: Colors.white54, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Align your phone horizontally for best accuracy.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Whisper Line
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isWhisperExpanded = !_isWhisperExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.sparkles, 
                          size: 14, 
                          color: Colors.grey[500]
                        ),
                        const SizedBox(width: 8),
                        AnimatedCrossFade(
                          firstChild: Text(
                            "Spiritual Insight",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          secondChild: Text(
                            "Facing the Ka'bah brings barakah to your salah.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          crossFadeState: _isWhisperExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 110), // Bottom nav space
              ],
            ),
          ),
        ],
      ),
    );
  }
}
