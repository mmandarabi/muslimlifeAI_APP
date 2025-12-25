import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  static const String _storageKey = 'cached_prayer_times';

  // Cloud Function URL
  String get _endpointUrl => '${ApiConfig.baseUrl}/getPrayerTimes';
  
  /// 1. FAST LOAD: Loads data from disk immediately (Offline-First)
  Future<PrayerTimes?> loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        debugPrint("PrayerService: Loaded offline data from disk.");
        _cachedData = PrayerTimes.fromJson(json.decode(jsonString));
        return _cachedData;
      }
    } catch (e) {
      debugPrint("PrayerService: Error loading cache: $e");
    }
    return null;
  }

  /// 2. NETWORK FETCH: Gets fresh data and saves to disk
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

      // Increased timeout to 30s to handle Cold Starts & Slow Networks
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      
      debugPrint("PrayerService: Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Offload JSON parsing to an isolate to prevent UI jank
        _cachedData = await compute(_parsePrayerTimes, response.body);
        _lastFetchTime = DateTime.now();
        
        // PERSIST TO DISK
        _saveToDisk(response.body);
        
        return _cachedData!;
      } else {
        debugPrint("PrayerService: API Error ${response.statusCode}");
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("PrayerService: Error - $e");
      // If it's a timeout, give a more specific message
      if (e.toString().contains('TimeoutException')) {
         throw Exception('Connection timed out. Please check your internet or try again.');
      }
      throw Exception('Error fetching prayer times: $e');
    }
  }
  
  Future<void> _saveToDisk(String jsonString) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonString);
      debugPrint("PrayerService: Saved fresh data to disk.");
    } catch (e) {
      debugPrint("PrayerService: Failed to save to disk: $e");
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
          // Try to use cache if GPS is off, but fetchPrayerTimes handles that earlier
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

        // 1. FAST TRACK: Try Last Known Position first (Instant)
        debugPrint("PrayerService: Fetching last known position...");
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          // If less than 1 hour old, use it immediately
          final age = DateTime.now().difference(lastKnown.timestamp);
          if (age.inHours < 1) {
             debugPrint("PrayerService: Using fresh cached GPS: ${lastKnown.latitude}, ${lastKnown.longitude}");
             return {'lat': lastKnown.latitude, 'lon': lastKnown.longitude};
          }
        }

        // 2. ACTIVE TRACK: Request current position
        debugPrint("PrayerService: Requesting current position (10s limit)...");
        try {
          LocationSettings settings;
          if (defaultTargetPlatform == TargetPlatform.android) {
            settings = AndroidSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: const Duration(seconds: 10),
              forceLocationManager: true,
            );
          } else {
            settings = AppleSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: const Duration(seconds: 10),
            );
          }

          final position = await Geolocator.getCurrentPosition(locationSettings: settings); 
              
          debugPrint("PrayerService: GPS Position Found: ${position.latitude}, ${position.longitude}");
          return {'lat': position.latitude, 'lon': position.longitude};
        } catch (e) {
          debugPrint("PrayerService: getCurrentPosition timed out or failed. Falling back to LastKnown or Default.");
          if (lastKnown != null) {
            return {'lat': lastKnown.latitude, 'lon': lastKnown.longitude};
          }
          return fallback;
        }
      } else {
        // --- WEB STRATEGY (IP Geolocation) ---
        // ... (rest of web logic remains same)
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

/// Top-level function for isolate JSON parsing
PrayerTimes _parsePrayerTimes(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  return PrayerTimes.fromJson(data);
}

