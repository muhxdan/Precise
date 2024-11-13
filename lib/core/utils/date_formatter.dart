import 'package:intl/intl.dart';

class DateFormatter {
  // Converts a DateTime object to a readable string format
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Formats a timestamp (milliseconds) to a readable date string
  static String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return formatDate(date);
  }
}
