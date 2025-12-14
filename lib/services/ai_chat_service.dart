import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AiService {
  // --- Dynamic Base URL ---
  String get _baseUrl => ApiConfig.baseUrl;

  // --- Static Cache (Session Level) ---
  static Map<String, dynamic>? _cachedInsight;

  // --- Insight Function (Horeen) ---
  Future<Map<String, dynamic>> generateInsight(String event, Map<String, dynamic> data) async {
    // 1. Check Cache
    if (_cachedInsight != null) {
      debugPrint("AiService: Returning Cached Insight.");
      return _cachedInsight!;
    }

    // 2. Fetch from API
    final response = await _postToFunction("generateInsight", {
      "event": event,
      "data": data,
    });

    // 3. Store in Cache (only if valid)
    if (response["type"] == "insight") {
      debugPrint("AiService: Caching Insight.");
      _cachedInsight = response;
    }

    return response;
  }

  // --- Chat Function (Noor) ---
  Future<String> sendMessage(String message) async {
      final response = await _postToFunction("aiChat", {
        "message": message,
        "uid": FirebaseAuth.instance.currentUser?.uid ?? "anonymous", 
      });

      return response["reply"] ?? "No response received.";
  }

  // --- Helper ---
  Future<Map<String, dynamic>> _postToFunction(String functionName, Map<String, dynamic> body) async {
    final url = "$_baseUrl/$functionName";
    debugPrint("AiService: ENTRY - Calling $url");

    final user = FirebaseAuth.instance.currentUser;
    String? token;
    
    if (user != null) {
      debugPrint("AiService: Fetching ID Token for user ${user.uid}...");
      try {
        // Enforce a timeout on token fetching to prevent indefinite hangs
        token = await user.getIdToken().timeout(const Duration(seconds: 2));
        debugPrint("AiService: ID Token fetched.");
      } catch (e) {
        debugPrint("AiService: WARNING - Failed to get ID token: $e");
        // We proceed without token (or could abort depending on security rules)
        // For now, let's proceed and let the backend decide if it wants to reject unauthenticated requests.
      }
    } else {
      debugPrint("AiService: User is null (Anonymous call)");
    }

    debugPrint("AiService: Executing HTTP POST...");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30)); // Update API timeout to 30s

      debugPrint("AiService: Response ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
           return jsonDecode(response.body);
        } catch (e) {
           debugPrint("AiService: JSON Decode Error - $e");
           return {"reply": response.body, "message": response.body, "type": "error"};
        }
      } else {
        debugPrint("AiService: Server Error - ${response.body}");
        return {
          "title": "Error",
          "message": "Error ${response.statusCode}",
          "reply": "Error ${response.statusCode}",
          "type": "error"
        };
      }
    } catch (e) {
      debugPrint("AiService: Network/Logic Error - $e");
      return {
        "title": "Connection Error",
        "message": "Network error: $e",
        "reply": "Connection Error",
        "type": "error"
      };
    }
  }
}
