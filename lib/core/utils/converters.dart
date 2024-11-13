import 'dart:convert';

class Converters {
  static Map<String, dynamic> jsonToMap(String jsonString) {
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  static int toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // New method to parse a date string to DateTime
  static DateTime parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now(); // or handle it as needed
    }
  }

  static int currentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
