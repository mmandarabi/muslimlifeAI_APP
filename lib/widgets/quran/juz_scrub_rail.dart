import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'dart:ui'; // For Glassmorphism

class JuzScrubRail extends StatefulWidget {
  final ValueChanged<int> onJuzSelected;
  final int activeJuz;

  const JuzScrubRail({
    super.key,
    required this.onJuzSelected,
    required this.activeJuz,
  });

  @override
  State<JuzScrubRail> createState() => _JuzScrubRailState();
}

class _JuzScrubRailState extends State<JuzScrubRail> {
  OverlayEntry? _overlayEntry;
  int? _scrubIndex;
  final GlobalKey _railKey = GlobalKey();

  // 🛑 HUD BUBBLE LOGIC: Creates a gloabl overlay for feedback
  void _showOverlay(BuildContext context, Offset globalPos, int juz) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildHudBubble(globalPos, juz),
      );
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      // Update position/state is tricky with naive OverlayEntry.
      // Better: Rebuild the overlay with new data. 
      // Since OverlayEntry is a widget builder, we can use a ValueNotifier/Stream or just setState inside the overlay if it was stateful.
      // Easiest robust way here: Remove and add (might flicker) OR use a Stream.
      // Let's use remove/add for MVP robustness or specific State update if needed.
      // ACTUALLY: The performant way is checking if the builder can just pull from a variable? 
      // No, builder runs once.
      // Let's just recreate it for simplicity in MVP, or use a Listener.
      _overlayEntry!.remove();
      _overlayEntry = OverlayEntry(
         builder: (context) => _buildHudBubble(globalPos, juz),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildHudBubble(Offset globalPos, int juz) {
    // Position to the RIGHT of the rail (toward content area) for easy visibility
    // The rail is on the far left, so we add spacing to move the bubble right
    return Positioned(
      top: globalPos.dy - 40, // Center vertically with touch point
      left: globalPos.dx + 16, // To the right of the rail with 16px spacing
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 120,
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardDark.withOpacity(0.9),
                image: const DecorationImage(
                   image: AssetImage('assets/images/islamic_pattern_bg.png'),
                   opacity: 0.1,
                   fit: BoxFit.cover,
                ),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("JUZ", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, letterSpacing: 2)),
                  Text(
                    juz.toString(),
                    style: GoogleFonts.amiri(
                      color: AppColors.accent,
                      fontSize: 32,
                      height: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 🛑 Ensure hits are captured even on transparent areas
      onVerticalDragStart: (details) {
         final RenderBox box = context.findRenderObject() as RenderBox;
         _handleDrag(details.localPosition, details.globalPosition, context, box.size.height);
      },
      onVerticalDragUpdate: (details) {
         final RenderBox box = context.findRenderObject() as RenderBox;
         _handleDrag(details.localPosition, details.globalPosition, context, box.size.height);
      },
      onVerticalDragEnd: (_) {
         setState(() => _scrubIndex = null);
         _removeOverlay();
      },
      onVerticalDragCancel: () {
         setState(() => _scrubIndex = null);
         _removeOverlay();
      },
      child: Container(
         width: 32,
         key: _railKey,
         padding: const EdgeInsets.symmetric(vertical: 16), // Add padding for touch target safety
         decoration: BoxDecoration(
           color: Colors.white.withOpacity(0.03),
           borderRadius: BorderRadius.circular(30),
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute available space (defined by children + padding)
           children: List.generate(30, (index) {
             final juz = index + 1;
             final isActive = widget.activeJuz == juz || _scrubIndex == juz;
             
             return Container(
               height: 20, // Fixed visual height per item anchor
               alignment: Alignment.center,
               child: Text(
                 juz.toString(),
                 style: GoogleFonts.firaCode(
                   fontSize: isActive ? 12 : 9,
                   fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                   color: isActive ? AppColors.accent : AppColors.textPrimaryDark.withOpacity(0.5),
                 ),
               ),
             );
           }),
         ),
      ),
    );
  }

  void _handleDrag(Offset localPos, Offset globalPos, BuildContext context, double totalHeight) {
     final double localY = localPos.dy;
     final double progress = (localY / totalHeight).clamp(0.0, 1.0);
     
     // Map 0..1 to 1..30
     final int rawIndex = (progress * 30).ceil(); 
     final int targetJuz = rawIndex.clamp(1, 30);
     
     if (_scrubIndex != targetJuz) {
        setState(() => _scrubIndex = targetJuz);
        HapticFeedback.selectionClick();
        
        // Show HUD
        if (_overlayEntry != null || targetJuz != _scrubIndex) {
            _showOverlay(context, globalPos, targetJuz);
        }
        
        // Fire callback
        widget.onJuzSelected(targetJuz);
     } else {
        // Just update HUD position
        _showOverlay(context, globalPos, targetJuz);
     }
  }
}
