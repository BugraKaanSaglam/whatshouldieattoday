import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    level: kDebugMode ? Level.debug : Level.warning,
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 8),
  );

  static void d(String message) => _logger.d(message);

  static void i(String message) => _logger.i(message);

  static void w(String message, [Object? error]) {
    _logger.w(_compose(message, error));
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(_compose(message, error), stackTrace: stackTrace);
  }

  static String _compose(String message, Object? error) {
    if (error == null) return message;
    return '$message | $error';
  }
}
