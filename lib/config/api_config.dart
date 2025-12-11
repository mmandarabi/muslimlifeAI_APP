import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Toggle this for Production vs Development
  static const bool isProduction = false; 

  // --- Configuration ---
  static const String _emulatorProjectId = "muslimlifeai-fcb93";
  static const String _prodProjectId = "muslimlifeai-fcb93"; 
  static const String _region = "us-central1";

  // --- Base URL Logic ---
  static String get baseUrl {
    if (isProduction) {
      return "https://$_region-$_prodProjectId.cloudfunctions.net";
    }

    // Emulator Logic
    if (kIsWeb) {
      // Web (Chrome) -> localhost
      return "http://127.0.0.1:5001/$_emulatorProjectId/$_region";
    } else if (Platform.isAndroid) {
      // Android Emulator -> 10.0.2.2
      return "http://10.0.2.2:5001/$_emulatorProjectId/$_region";
    } else {
      // iOS Simulator -> localhost
      return "http://127.0.0.1:5001/$_emulatorProjectId/$_region";
    }
  }
}
