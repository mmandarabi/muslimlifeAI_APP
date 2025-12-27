import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hijri/hijri_calendar.dart';
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
      
      // 🛑 RELIABILITY FIX: If GPS fails completely, look for last city name in cache
      String locationName = "Current Location";
      if (lat != null && lon != null) {
          locationName = await _getAddressFromLatLng(lat, lon);
      } else {
          locationName = _cachedData?.locationName ?? "Location Unavailable";
      }

      debugPrint("PrayerService: Using coordinates: $lat, $lon ($locationName)");

      // 2. Calculate Hijri Date (Dynamic)
      final hijriDate = HijriCalendar.now();
      final dateHijri = "${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH";

      // 3. Fallback Coordination (If GPS fails, use static fallback coords but keep dynamic date)
      final double targetLat = lat ?? 38.9072; // Belmont Fallback Coords if GPS dead
      final double targetLon = lon ?? -77.0369;

      // 4. Call Cloud Function
      final Uri uri = Uri.parse('$_endpointUrl?lat=$targetLat&lon=$targetLon&method=2');
      debugPrint("PrayerService: Calling API: $uri");

      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      
      debugPrint("PrayerService: Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = json.decode(response.body);
        
        // Supplement API data with our dynamic local logic
        rawData['locationName'] = locationName;
        rawData['dateHijri'] = dateHijri;

        // Offload JSON parsing to an isolate
        _cachedData = await compute(_parsePrayerTimes, json.encode(rawData));
        _lastFetchTime = DateTime.now();
        
        // PERSIST TO DISK
        _saveToDisk(json.encode(rawData));
        
        return _cachedData!;
      } else {
        debugPrint("PrayerService: API Error ${response.statusCode}");
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("PrayerService: Error - $e");
      if (e.toString().contains('TimeoutException')) {
         throw Exception('Connection timed out. Please check your internet or try again.');
      }
      throw Exception('Error fetching prayer times: $e');
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Priority: City, Locality, SubAdministrativeArea
        final String city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? "Unknown";
        final String country = place.isoCountryCode ?? "";
        return "$city, $country".trim();
      }
    } catch (e) {
      debugPrint("PrayerService: Reverse Geocoding failed: $e");
    }
    return "Current Location";
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

  Future<Map<String, double?>> _determinePosition() async {
    try {
      if (!kIsWeb) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return {'lat': null, 'lon': null};

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) return {'lat': null, 'lon': null};
        }

        if (permission == LocationPermission.deniedForever) return {'lat': null, 'lon': null};

        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          final age = DateTime.now().difference(lastKnown.timestamp);
          if (age.inHours < 1) return {'lat': lastKnown.latitude, 'lon': lastKnown.longitude};
        }

        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 10))
        ); 
        return {'lat': position.latitude, 'lon': position.longitude};
      } else {
        // Web basic fallback or IP API
        return {'lat': null, 'lon': null};
      }
    } catch (e) {
      return {'lat': null, 'lon': null};
    }
  }
}

PrayerTimes _parsePrayerTimes(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  return PrayerTimes.fromJson(data);
}

