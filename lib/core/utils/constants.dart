import 'package:precise/core/routes/app_routes.dart';
import 'package:precise/core/utils/assets.dart';

class Constants {
  static const String appName = 'Precise';

  static const bookmarksPage = 'Bookmarks';
  static const settingsPage = 'Settings';
  static const themesPage = 'Themes';

  static const addedToBookmarks = 'Article added to bookmarks';
  static const removedFromBookmarks = 'Article removed from bookmarks';

  static const List<Map<String, String>> settings = [
    {
      'title': 'Theme',
      'subtitle': 'Select your UI Themes.',
      'leading': AssetVectors.icPaint,
      'route': "${AppRoutes.settings}/${AppRoutes.themes}",
    }
  ];

  static const List<String> categories = [
    'all',
    'technology',
    'business',
    'culture',
    'sport',
    'lifeandstyle',
  ];

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
