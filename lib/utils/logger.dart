import 'package:logger/logger.dart';

class AppLogger {
  static final _logger = Logger();

  static void i(String message) {
    _logger.i(message);
  }

  static void d(String message) {
    _logger.d(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message) {
    _logger.e(message);
  }
}
