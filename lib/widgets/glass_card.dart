import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:muslim_mind/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double sigma;
  final bool showPattern;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.opacity = 0.05,
    this.borderRadius = 24.0, // Standardized to 24px
    this.border,
    this.padding,
    this.onTap,
    this.sigma = 15.0,
    this.showPattern = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Light Mode: Dark tint, higher shadow
    // Dark Mode: White tint, subtle shadow
    final tintColor = color ?? (isDark ? Colors.white : Colors.black);
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);
    final patternOpacity = isDark ? 0.05 : 0.03;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              // REMOVED internal padding from the decorated container to fix "Box within Box"
              decoration: BoxDecoration(
                color: tintColor.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(borderRadius),
                border: border ?? Border.all(color: borderColor, width: 0.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle Islamic Pattern Texture (Conditional)
                  if (showPattern)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Opacity(
                          opacity: patternOpacity,
                          child: Image.asset(
                            'assets/images/islamic_pattern_bg.png',
                            repeat: ImageRepeat.repeat,
                            color: isDark ? null : Colors.black,
                            colorBlendMode: isDark ? null : BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  // Child Content (Now handles its own padding to keep pattern edge-to-edge)
                  Padding(
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
