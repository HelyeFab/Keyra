
/// Logger utility class for handling logging throughout the app.
/// In release mode, it will silently handle logs but still throw exceptions when needed.
class Logger {
  /// Log a message in production-safe way
  static void log(String message) {
    // Production logging can be implemented here if needed
    // For example, you could send to a logging service
  }

  /// Log an error in production-safe way
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool throwError = false,
    bool throwException = false,
  }) {
    // Production error logging can be implemented here
    // For example, you could send to an error tracking service
    final errorMessage = error != null ? '$message: $error' : message;
    final shouldThrow = throwError || throwException;

    if (shouldThrow) {
      throw Exception(errorMessage);
    }
  }
}
