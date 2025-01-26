import 'package:flutter/foundation.dart';

/// A utility class for handling logging and errors in the app.
/// In debug mode, it will print logs using debugPrint.
/// In release mode, it will silently handle logs but still throw exceptions when needed.
class Logger {
  /// Log a message in debug mode only
  static void log(String message) {
    if (kDebugMode) {
      print('LOG: $message');
    }
  }

  /// Log an error in debug mode and optionally throw an exception
  static void error(String message, {Object? error, StackTrace? stackTrace, bool throwError = false}) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) print('Details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
    
    if (throwError) {
      throw Exception(message);
    }
  }
}
