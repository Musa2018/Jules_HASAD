import 'dart:convert';
import 'package:flutter/foundation.dart';

class DebugLogger {
  static const bool ENABLE_SYNC_DEBUG = true;

  static void log(String message) {
    if (ENABLE_SYNC_DEBUG) {
      if (kDebugMode) {
        print(message);
      }
    }
  }

  static void logHeader(String title) {
    log('==================================================');
    log(title.toUpperCase());
    log('==================================================');
  }

  static void logJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      log(encoder.convert(json));
    } catch (e) {
      log('Error pretty-printing JSON: $e');
      log(json.toString());
    }
  }

  static void logFooter() {
    log('==================================================\n');
  }
}
