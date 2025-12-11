import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AiService {
  // --- Dynamic Base URL ---
  String get _baseUrl => ApiConfig.baseUrl;

  // --- Insight Function (Horeen) ---
  Future<Map<String, dynamic>> generateInsight(String event, Map<String, dynamic> data) async {
    return _postToFunction("generateInsight", {
      "event": event,
      "data": data,
    });
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
    final user = FirebaseAuth.instance.currentUser;
    String? token;
    if (user != null) {
      token = await user.getIdToken();
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/$functionName"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        try {
           return jsonDecode(response.body);
        } catch (e) {
           return {"reply": response.body, "message": response.body};
        }
      } else {
        return {
          "title": "Error",
          "message": "Error ${response.statusCode}: ${response.body}",
          "reply": "Error ${response.statusCode}",
          "type": "error"
        };
      }
    } catch (e) {
      return {
        "title": "Connection Error",
        "message": "Please check your internet connection.",
        "reply": "Connection Error",
        "type": "error"
      };
    }
  }
}
