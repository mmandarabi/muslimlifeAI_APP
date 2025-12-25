import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adhan/adhan.dart';
import 'package:muslim_mind/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:google_fonts/google_fonts.dart';

class QiblaScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const QiblaScreen({super.key, this.onBack});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _hasPermissions = false;
  bool _isLoading = true;
  String? _error;
  
  // Qibla Data
  double? _qiblaDirection; // Angle to Kaaba from True North
  double? _distanceInKm;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  Future<void> _initCompass() async {
    if (kIsWeb) {
      setState(() {
        _error = "Compass not supported on Web";
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. Check Location Service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
         setState(() {
          _error = "Location services are disabled. Please enable them.";
          _isLoading = false;
        });
        return;
      }

      // 2. Check/Request Permission (Using Geolocator to match PrayerService)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = "Location permission is required to find Qibla.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = "Location permission is permanently denied. Please enable in Settings.";
          _isLoading = false;
        });
        return;
      }

      // 3. Get Location (Fast Track First)
      Position? position;
      debugPrint("QiblaScreen: Fetching last known position...");
      final lastKnown = await Geolocator.getLastKnownPosition();
      
      if (lastKnown != null) {
        final age = DateTime.now().difference(lastKnown.timestamp);
        if (age.inMinutes < 30) {
          debugPrint("QiblaScreen: Using fresh cached position.");
          position = lastKnown;
        }
      }

      if (position == null) {
        debugPrint("QiblaScreen: Requesting current position (45s limit)...");
        LocationSettings settings;
        if (defaultTargetPlatform == TargetPlatform.android) {
          settings = AndroidSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 45), // Increased to 45s
            forceLocationManager: true,
          );
        } else {
          settings = AppleSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 45), // Increased to 45s
          );
        }
        position = await Geolocator.getCurrentPosition(locationSettings: settings);
      }
      
      // 4. Calculate Qibla
      final coordinates = Coordinates(position!.latitude, position!.longitude);
      final qibla = Qibla(coordinates);
      
      setState(() {
        _currentPosition = position;
        _qiblaDirection = qibla.direction;
        _distanceInKm = _calculateDistance(position!.latitude, position!.longitude);
        _hasPermissions = true;
        _isLoading = false;
        _error = null; // Clear any previous error
      });

    } catch (e) {
      debugPrint("QiblaScreen: Location error: $e. Using fallback (Belmont, VA).");
      
      // FALLBACK: Belmont, VA
      final fallbackPosition = Position(
        latitude: 39.0207, 
        longitude: -77.4980, 
        timestamp: DateTime.now(), 
        accuracy: 0, 
        altitude: 0, 
        heading: 0, 
        speed: 0, 
        speedAccuracy: 0, 
        altitudeAccuracy: 0, 
        headingAccuracy: 0 
      );
      
      final coordinates = Coordinates(fallbackPosition.latitude, fallbackPosition.longitude);
      final qibla = Qibla(coordinates);
      
      if(mounted) {
        setState(() {
          _currentPosition = fallbackPosition;
          _qiblaDirection = qibla.direction;
          _distanceInKm = _calculateDistance(fallbackPosition.latitude, fallbackPosition.longitude);
          _hasPermissions = true;
          _isLoading = false;
          _error = null;
        });
        
        String msg = "GPS Signal Not Found. Using default location.";
        if (e.toString().contains('TimeoutException')) {
          msg = "GPS Timeout: Using default location (Belmont, VA). Tap to retry.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(msg),
             backgroundColor: Colors.orange,
             duration: const Duration(seconds: 5),
             action: SnackBarAction(
               label: "RETRY", 
               textColor: Colors.white,
               onPressed: _initCompass
             ),
           )
        );
      }
    }
  }
  
  // Haversine visualization
  double _calculateDistance(double lat1, double lon1) {
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;
    // Simplified approx distance logic if needed, or stick to library if it had it.
    // 'adhan' dart package handles calculation but Qibla object returns direction.
    // We can implement Haversine manually for distance display.
    const p = 0.017453292519943295;
    final c = math.cos;
    final a = 0.5 - c((kaabaLat - lat1) * p) / 2 +
        c(lat1 * p) * c(kaabaLat * p) *
            (1 - c((kaabaLon - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    // Strict Palette Enforcements
    const backgroundColor = Color(0xFF202124);
    const textColor = Color(0xFFF1F3F4);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.triangle_alert, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: textColor, fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initCompass,
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
           return const Scaffold(
            backgroundColor: Color(0xFF0B0C0E),
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final compassEvent = snapshot.data!;
        // heading: The heading relative to True North if available, otherwise Magnetic North
        final double? heading = compassEvent.heading;
        final double? accuracy = compassEvent.accuracy;
        
        if (heading == null) {
          final backgroundColor = AppColors.getBackgroundColor(context);
          final textColor = AppColors.getTextPrimary(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: Text("Device does not support compass", style: TextStyle(color: textColor))),
          );
        }
        
        return _CompassUI(
          heading: heading,
          qiblaDirection: _qiblaDirection ?? 0,
          accuracy: accuracy ?? 0,
          distanceInKm: _distanceInKm ?? 0,
          locationName: "${_currentPosition?.latitude.toStringAsFixed(2)}, ${_currentPosition?.longitude.toStringAsFixed(2)}",
          onBack: widget.onBack,
        );
      },
    );
  }
}

class _CompassUI extends StatefulWidget {
  final double heading;
  final double qiblaDirection;
  final double accuracy;
  final double distanceInKm;
  final String locationName;
  final VoidCallback? onBack;

  const _CompassUI({
    required this.heading,
    required this.qiblaDirection,
    required this.accuracy,
    required this.distanceInKm,
    required this.locationName,
    this.onBack,
  });

  @override
  State<_CompassUI> createState() => _CompassUIState();
}

class _CompassUIState extends State<_CompassUI> {
  bool _showRawData = false;
  DateTime _lastHaptic = DateTime.now();

  void _checkAlignment() {
    final diff = (widget.qiblaDirection - widget.heading);
    double normalizedDiff = (diff + 180) % 360 - 180;
    
    if (normalizedDiff.abs() < 2.0) {
      final now = DateTime.now();
      if (now.difference(_lastHaptic) > const Duration(milliseconds: 1000)) {
        HapticFeedback.mediumImpact();
        _lastHaptic = now;
      }
    }
  }
  
  @override
  void didUpdateWidget(covariant _CompassUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAlignment();
  }

  @override
  Widget build(BuildContext context) {
    // Rotation Logic
    final dialRotation = -widget.heading * (math.pi / 180);
    final needleRotation = (widget.qiblaDirection - widget.heading) * (math.pi / 180);
    final mediaQuery = MediaQuery.of(context);

    // Strict Palette Enforcements
    const isDark = true;
    const backgroundColor = Color(0xFF202124);
    const textColor = Color(0xFFF1F3F4);
    const secondaryTextColor = Color(0xFF9AA0A6); // Muted Text for dark mode

    // Accuracy Logic (Lower is better usually for cross platform, but verify. iOS: degrees err. Android: Status 0-3)
    // Assuming degrees error. >15 is bad.
    bool interference = widget.accuracy > 15; 
    
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrow_left, color: textColor),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          children: [
            Text(
              "Qibla Compass",
              style: GoogleFonts.outfit(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
             Text(
              widget.locationName,
              style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(LucideIcons.info, color: _showRawData ? AppColors.primary : textColor),
            onPressed: () {
              setState(() {
                _showRawData = !_showRawData;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Background: Strictly #202124 (Raisin Black)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF202124),
            ),
          ),

           SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // 1. Digital Heading Display: Surfaces/Cards Strictly #35363A
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                     decoration: BoxDecoration(
                       color: const Color(0xFF35363A),
                       borderRadius: BorderRadius.circular(24),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withValues(alpha: 0.2),
                           blurRadius: 10,
                           offset: const Offset(0, 4),
                         ),
                       ],
                     ),
                     child: Text(
                       "${widget.heading.toStringAsFixed(0)}° ${getCardinalDirection(widget.heading)}",
                       style: GoogleFonts.sourceCodePro(
                         color: const Color(0xFFF1F3F4), // Strictly #F1F3F4
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   const SizedBox(height: 40),

                   // 2. The Compass
                   SizedBox(
                     height: 320,
                     width: 320,
                     child: Stack(
                       alignment: Alignment.center,
                       children: [
                         // Dial (North Card)
                         Transform.rotate(
                           angle: dialRotation,
                           child: Image.asset(
                             'assets/images/compass_dial.png', // Fallback handled?
                             errorBuilder: (c,e,s) => _buildFallbackDial(),
                           ),
                         ),
                         
                         // Qibla Needle
                         Transform.rotate(
                           angle: needleRotation,
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               const Icon(LucideIcons.map_pin, color: AppColors.primary, size: 40), // The tip
                               Container(width: 4, height: 60, 
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 10)]
                                ),
                               ), // The shaft
                               const SizedBox(height: 60), // Counterbalance length
                             ],
                           ),
                         ),

                         // Center Pivot
                         Container(
                           width: 12, height: 12,
                           decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
                         ),
                       ],
                     ),
                   ),
                   
                   const SizedBox(height: 40),

                   // 3. Info Cards
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Flexible(child: _buildInfoBadge("QIBLA", "${widget.qiblaDirection.toStringAsFixed(0)}°")),
                         Flexible(child: _buildInfoBadge("DISTANCE", "${widget.distanceInKm.round()} km")),
                         Flexible(child: _buildSignalIndicator(widget.accuracy)),
                       ],
                     ),
                   )
                ],
              ),
            ),
            
            // Interference Warning
            if (interference && !_showRawData)
              _buildInterferenceOverlay(),

            // Raw Data Overlay
            if (_showRawData)
               _buildRawDataOverlay(),
        ],
      ),
    ),
  );
}

  Widget _buildInterferenceOverlay() {
      // Strict Card Color
      return Container(
        color: const Color(0xFF35363A).withOpacity(0.95),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.infinity, color: Colors.orange, size: 80)
              .animate(onPlay: (c) => c.repeat()).rotate(duration: 2000.ms), // Rotate visually simulates "Figure 8"
              const SizedBox(height: 24),
              Text("Calibrate Compass", style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Tilt phone in a figure-8 motion", style: GoogleFonts.inter(color: AppColors.getTextSecondary(context))),
            ],
          ),
        ),
      );
  }

  Widget _buildRawDataOverlay() {
      return Container(
         margin: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(
           color: const Color(0xFF35363A).withOpacity(0.95),
           borderRadius: BorderRadius.circular(16),
         ),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text("SENSOR DIAGNOSTICS", style: GoogleFonts.sourceCodePro(color: AppColors.primary, fontWeight: FontWeight.bold)),
               const Divider(color: Colors.white24),
               _buildRawRow("Heading", "${widget.heading.toStringAsFixed(4)}°"),
               _buildRawRow("Accuracy", "${widget.accuracy.toStringAsFixed(2)}"),
               _buildRawRow("Qibla Angle", "${widget.qiblaDirection.toStringAsFixed(4)}°"),
               _buildRawRow("Distance", "${widget.distanceInKm.toStringAsFixed(2)} km"),
               _buildRawRow("Lat/Long", widget.locationName),
             ],
           ),
         ),
      );
  }

  Widget _buildRawRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.sourceCodePro(color: Colors.white70, fontSize: 12)),
          Text(value, style: GoogleFonts.sourceCodePro(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFallbackDial() {
    final textColor = AppColors.getTextPrimary(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: textColor.withValues(alpha: 0.1), width: 2),
        color: textColor.withValues(alpha: 0.05),
      ),
      child: Stack(
         children: [
           const Positioned(top: 10, left: 0, right: 0, child: Center(child: Text("N", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))),
           Positioned(bottom: 10, left: 0, right: 0, child: Center(child: Text("S", style: TextStyle(color: textColor)))),
           Positioned(top: 0, bottom: 0, right: 10, child: Center(child: Text("E", style: TextStyle(color: textColor)))),
           Positioned(top: 0, bottom: 0, left: 10, child: Center(child: Text("W", style: TextStyle(color: textColor)))),
         ],
      ),
    );
  }

  String getCardinalDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return "N";
    if (heading >= 22.5 && heading < 67.5) return "NE";
    if (heading >= 67.5 && heading < 112.5) return "E";
    if (heading >= 112.5 && heading < 157.5) return "SE";
    if (heading >= 157.5 && heading < 202.5) return "S";
    if (heading >= 202.5 && heading < 247.5) return "SW";
    if (heading >= 247.5 && heading < 292.5) return "W";
    if (heading >= 292.5 && heading < 337.5) return "NW";
    return "";
  }
  
  Widget _buildInfoBadge(String label, String value) {
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final textColor = AppColors.getTextPrimary(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label, 
          style: GoogleFonts.outfit(color: secondaryTextColor.withValues(alpha: 0.5), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: GoogleFonts.outfit(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSignalIndicator(double accuracy) {
    // Visualization: 3 Bars.
    // If acc < 15: 3 Green Bars
    // If acc < 45: 2 Orange Bars
    // Else: 1 Red Bar
    
    int strength = 0;
    Color color = Colors.red;
    if (accuracy < 15) {
      strength = 3;
      color = AppColors.primary;
    } else if (accuracy < 45) {
      strength = 2;
      color = Colors.orange;
    } else {
      strength = 1;
      color = Colors.red;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
         const Text("SIGNAL", style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w600, color: Colors.grey)),
         const SizedBox(height: 6),
         Row(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.end, // Align bottom
           children: [
             _bar(1, strength, color, 12),
             const SizedBox(width: 2),
             _bar(2, strength, color, 16),
             const SizedBox(width: 2),
             _bar(3, strength, color, 20),
           ],
         )
      ],
    );
  }

  Widget _bar(int index, int strength, Color color, double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: index <= strength ? color : color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
