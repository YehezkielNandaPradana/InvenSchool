import 'package:flutter/foundation.dart';

class LoggerUtils {
  static void d(Object? message) {
    debugPrint('[DEBUG] ${message?.toString()}');
  }

  static void i(Object? message) {
    debugPrint('[INFO] ${message?.toString()}');
  }

  static void w(Object? message) {
    debugPrint('[WARN] ${message?.toString()}');
  }

  static void e(Object? message, dynamic error) {
    debugPrint('[ERROR] ${message?.toString()}');
    if (error != null) debugPrint(error.toString());
  }
}
