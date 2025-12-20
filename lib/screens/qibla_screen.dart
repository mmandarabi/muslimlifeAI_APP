import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adhan/adhan.dart';
import 'package:muslim_life_ai_demo/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:vector_math/vector_math.dart' show radians;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

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

      // 3. Get Location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5), // Prevent infinite loading
      );
      
      // 4. Calculate Qibla
      final coordinates = Coordinates(position.latitude, position.longitude);
      final qibla = Qibla(coordinates);
      
      setState(() {
        _currentPosition = position;
        _qiblaDirection = qibla.direction;
        _distanceInKm = _calculateDistance(position.latitude, position.longitude);
        _hasPermissions = true;
        _isLoading = false;
        _error = null; // Clear any previous error
      });

    } catch (e) {
      debugPrint("QiblaScreen: Location error: $e. Using fallback.");
      // Fallback: Washington DC (38.9072, -77.0369)
      final fallbackPosition = Position(
        latitude: 38.9072,
        longitude: -77.0369,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
      
      // Calculate Qibla for fallback
      final coordinates = Coordinates(fallbackPosition.latitude, fallbackPosition.longitude);
      final qibla = Qibla(coordinates);
      
      setState(() {
        _currentPosition = fallbackPosition;
        _qiblaDirection = qibla.direction;
        _distanceInKm = _calculateDistance(fallbackPosition.latitude, fallbackPosition.longitude);
        _hasPermissions = true;
        _isLoading = false;
        _error = null;
      });
    }
  }

  // Basic Haversine for "Distance to Kaaba"
  double _calculateDistance(double lat, double lon) {
    const double kaabaLat = 21.422487;
    const double kaabaLon = 39.826206;
    const double p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((kaabaLat - lat) * p) / 2 +
        math.cos(lat * p) * math.cos(kaabaLat * p) * (1 - math.cos((kaabaLon - lon) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const _WebFallbackView();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = AppColors.getBackgroundColor(context);
    final textColor = AppColors.getTextPrimary(context);

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
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final backgroundColor = AppColors.getBackgroundColor(context);
          final textColor = AppColors.getTextPrimary(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: Text("Device does not support compass", style: TextStyle(color: textColor))),
          );
        }
        
        // Logic:
        // Heading = 0 (North) -> Needle should point 0 relative to screen
        // But we want Needle to point to Qibla.
        // Screen North = 0.
        // Qibla = 58 (for example).
        // If Phone points North (0), Needle should point 58.
        // If Phone points East (90), Needle should point 58 - 90 = -32.
        
        // Final Rotation = QiblaDirection - DeviceHeading
        // We use Transform.rotate which takes Angle in Radians.
        
        // For the Compass DIAL (North Card):
        // It should rotate opposite to device heading so "N" stays North.
        // Rotation = -DeviceHeading.
        
        return _CompassUI(
          heading: heading,
          qiblaDirection: _qiblaDirection ?? 0,
          accuracy: accuracy ?? 0,
          distanceInKm: _distanceInKm ?? 0,
          locationName: "${_currentPosition?.latitude.toStringAsFixed(2)}, ${_currentPosition?.longitude.toStringAsFixed(2)}",
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

  const _CompassUI({
    required this.heading,
    required this.qiblaDirection,
    required this.accuracy,
    required this.distanceInKm,
    required this.locationName,
  });

  @override
  State<_CompassUI> createState() => _CompassUIState();
}

class _CompassUIState extends State<_CompassUI> {
  bool _showMap = false;
  DateTime _lastHaptic = DateTime.now();

  void _checkAlignment() {
    // Current Needle Rotation relative to standard Top-Centre 
    // Needle Angle = Qibla - Heading.
    // If Needle Angle is near 0, user is pointing at Qibla? 
    // Wait. 
    // If I hold phone pointing at Qibla (Heading = Qibla), then (Qibla - Heading) = 0.
    // So Needle Points UP (0 degrees relative to phone). Correct.
    
    final diff = (widget.qiblaDirection - widget.heading);
    // Normalize to -180 to 180
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
    // Dial Rotation: Opposes heading so 'N' points North.
    final dialRotation = -widget.heading * (math.pi / 180);
    
    // Needle Rotation: Points to Qibla relative to North.
    // Use the Dial as parent? No, usually distinct layers.
    // Layer 1: Dial (Rotates -Heading). 'N' is at -Heading.
    // Layer 2: Needle. The needle should be fixed relative to the DIAL (pointing at Qibla on the dial).
    // OR Layer 2: Needle relative to SCREEN.
    // Screen Up = 0.
    // Qibla relative to Screen = Qibla - Heading.
    final needleRotation = (widget.qiblaDirection - widget.heading) * (math.pi / 180);
    final mediaQuery = MediaQuery.of(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = AppColors.getBackgroundColor(context);
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final accentColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F4);

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "Qibla Compass",
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
             Text(
              widget.locationName,
              style: TextStyle(color: secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showMap ? LucideIcons.compass : LucideIcons.map, color: textColor),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    accentColor,
                    backgroundColor,
                  ],
                ),
              ),
            ),
          ),

          if (_showMap)
            Center(child: Text("Map View Placeholder", style: TextStyle(color: textColor)))
          else
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // 1. Digital Heading Display
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     decoration: BoxDecoration(
                       color: textColor.withValues(alpha: 0.05),
                       borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: textColor.withValues(alpha: 0.1)),
                     ),
                     child: Text(
                       "${widget.heading.toStringAsFixed(0)}° ${getCardinalDirection(widget.heading)}",
                       style: TextStyle(
                         color: textColor,
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                         fontFamily: 'Courier', // Monospace for stability
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
                             'assets/images/compass_dial.png', // Ensure you have a dial asset or use a shape
                             // If no asset, fallback to a drawn shape?
                             // Let's assume user might not have asset. I'll build a simple one using code if image fails?
                             // No, I will use a Container with a border and "N" text for now if image missing.
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
                               Container(width: 2, height: 60, color: AppColors.primary), // The shaft
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
                         Flexible(child: _buildInfoBadge("ACCURACY", widget.accuracy < 15 ? "High" : "Low", 
                           color: widget.accuracy < 15 ? Colors.green : Colors.orange
                         )),
                       ],
                     ),
                   )
                ],
              ),
            ),
            
            // Interference Warning
            if (widget.accuracy > 45) // Arbitrary threshold for 'bad' interference
              Container(
                color: (isDark ? Colors.black : Colors.white).withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.magnet, color: Colors.orange, size: 64),
                      const SizedBox(height: 16),
                      Text("Magnetic Interference", style: TextStyle(color: textColor, fontSize: 20)),
                      Text("Wave phone in figure-8", style: TextStyle(color: secondaryTextColor)),
                    ],
                  ),
                ),
              )
        ],
      ),
    ),
  );
}

  Widget _buildFallbackDial() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
  
  Widget _buildInfoBadge(String label, String value, {Color? color}) {
    final secondaryTextColor = AppColors.getTextSecondary(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label, 
          style: TextStyle(color: secondaryTextColor.withValues(alpha: 0.5), fontSize: 10, letterSpacing: 1.5),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value, 
            style: TextStyle(color: color ?? AppColors.getTextPrimary(context), fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _WebFallbackView extends StatelessWidget {
  const _WebFallbackView();

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.getBackgroundColor(context);
    final textColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: IconThemeData(color: textColor)),
      body: Center(
        child: GlassContainer(
           height: 200, width: 300,
           borderRadius: BorderRadius.circular(20),
           gradient: LinearGradient(colors: [textColor.withOpacity(0.05), textColor.withOpacity(0.02)]),
           borderGradient: LinearGradient(colors: [textColor.withOpacity(0.1), Colors.transparent]),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(LucideIcons.compass, size: 48, color: secondaryTextColor),
               const SizedBox(height: 16),
               Text("Compass not supported on Web", style: TextStyle(color: textColor)),
               const SizedBox(height: 8),
               Text("Please use the Mobile App", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
             ],
           ),
        ),
      ),
    );
  }
}
