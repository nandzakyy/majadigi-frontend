import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulator uses 10.0.2.2 untuk mengakses host machine
        return 'http://10.0.2.2:3000';
      default:
        // iOS simulator, desktop, dan lain-lain menggunakan localhost
        return 'http://localhost:3000';
    }
  }
}
