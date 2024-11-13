import 'package:logger/logger.dart';

class AppLogger {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );

  static void info(String message) => logger.i(message);
  static void warn(String message) => logger.w(message);
  static void error(String message) => logger.e(message);
}
