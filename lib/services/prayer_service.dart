import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/prayer_times.dart';
import '../config/api_config.dart';

class PrayerService {
  static final PrayerService _instance = PrayerService._internal();

  factory PrayerService() {
    return _instance;
  }

  PrayerService._internal();

  // Simple in-memory cache
  PrayerTimes? _cachedData;
  DateTime? _lastFetchTime;

  // Cloud Function URL
  String get _endpointUrl => '${ApiConfig.baseUrl}/getPrayerTimes';

  Future<PrayerTimes> fetchPrayerTimes() async {
    debugPrint("PrayerService: Fetching prayer times...");
    
    // Return cached data if valid (e.g., less than 1 hour old)
    if (_cachedData != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < const Duration(hours: 1)) {
      debugPrint("PrayerService: Returning cached data.");
      return _cachedData!;
    }

    try {
      // 1. Determine Location (3-Layer Logic)
      final position = await _determinePosition();
      final lat = position['lat'];
      final lon = position['lon'];
      
      debugPrint("PrayerService: Using coordinates: $lat, $lon");

      // 2. Call Cloud Function
      final Uri uri = Uri.parse('$_endpointUrl?lat=$lat&lon=$lon&method=2');
      debugPrint("PrayerService: Calling API: $uri");

      final response = await http.get(uri).timeout(const Duration(seconds: 10)); // Timeout added
      
      debugPrint("PrayerService: Response Status: ${response.statusCode}");
      // debugPrint("PrayerService: Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _cachedData = PrayerTimes.fromJson(data);
        _lastFetchTime = DateTime.now();
        return _cachedData!;
      } else {
        debugPrint("PrayerService: API Error ${response.statusCode}");
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("PrayerService: Error - $e");
      throw Exception('Error fetching prayer times: $e');
    }
  }

  /// Determines the location based on platform priority:
  /// 1. Mobile: GPS
  /// 2. Web: IP Geolocation
  /// 3. Fallback: Belmont, VA
  Future<Map<String, double>> _determinePosition() async {
    // Default Fallback (Belmont, VA)
    final fallback = {'lat': 38.9072, 'lon': -77.0369};

    try {
      if (!kIsWeb) {
        // --- MOBILE STRATEGY (GPS) ---
        debugPrint("PrayerService: Checking Android Location Service...");
        
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          debugPrint("PrayerService: Location Service Disabled. Using Fallback.");
          return fallback; 
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            debugPrint("PrayerService: Permission Denied. Using Fallback.");
            return fallback;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          debugPrint("PrayerService: Permission Denied Forever. Using Fallback.");
          return fallback;
        }

        debugPrint("PrayerService: Requesting current position...");
        // Added timeout to prevent hanging indefinitely
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 5)); 
            
        debugPrint("PrayerService: GPS Position Found: ${position.latitude}, ${position.longitude}");
        return {'lat': position.latitude, 'lon': position.longitude};
      } else {
        // --- WEB STRATEGY (IP Geolocation) ---
        try {
          debugPrint("PrayerService: Calling IP API...");
          final response = await http.get(Uri.parse('http://ip-api.com/json')).timeout(const Duration(seconds: 3));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['status'] == 'success') {
               return {'lat': (data['lat'] as num).toDouble(), 'lon': (data['lon'] as num).toDouble()};
            }
          }
        } catch (e) {
          debugPrint("PrayerService: Web location fetch failed: $e");
        }
        return fallback; 
      }
    } catch (e) {
      debugPrint("PrayerService: Location determination error: $e. Using Fallback.");
      return fallback;
    }
  }
}
