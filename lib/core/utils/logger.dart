import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static const String _tag = 'ToiletFinder';
  static bool _isInitialized = false;

  static void init({bool debugMode = true}) {
    _isInitialized = true;
    if (debugMode) {
      // You can add any initialization for debug mode here
    }
  }

  static void d(String message, {String? tag}) {
    if (!_isInitialized) return;
    developer.log(
      message,
      name: tag ?? _tag,
      level: 0, // Verbose
    );
  }

  static void i(String message, {String? tag}) {
    if (!_isInitialized) return;
    developer.log(
      message,
      name: tag ?? _tag,
      level: 2, // Info
    );
  }

  static void w(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_isInitialized) return;
    developer.log(
      message,
      name: tag ?? _tag,
      level: 900, // Warning
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void e(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_isInitialized) return;
    developer.log(
      message,
      name: tag ?? _tag,
      level: 1000, // Error
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Only log in debug mode
  static void debugPrint(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  // Log API requests
  static void api(
    String message, {
    String? endpoint,
    dynamic request,
    dynamic response,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_isInitialized) return;
    final buffer = StringBuffer();
    if (endpoint != null) buffer.write('[$endpoint] ');
    buffer.write(message);

    if (request != null) {
      buffer.write('\nRequest: $request');
    }

    if (response != null) {
      buffer.write('\nResponse: $response');
    }

    if (error != null) {
      buffer.write('\nError: $error');
    }

    developer.log(
      buffer.toString(),
      name: '${_tag}API',
      level: error != null ? 1000 : 2,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
