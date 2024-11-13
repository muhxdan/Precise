import 'package:precise/core/errors/exceptions.dart';
import 'package:precise/data/models/settings_model.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<ThemeModel> getThemeSetting();
  Future<void> setThemeSetting(ThemeModel theme);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String themeKey = 'theme_setting';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeModel> getThemeSetting() async {
    try {
      final value = sharedPreferences.getString(themeKey);
      final themeSetting = ThemeSetting.values.firstWhere(
        (setting) => setting.toString() == value,
        orElse: () => ThemeSetting.system,
      );
      return ThemeModel(themeSetting);
    } catch (e) {
      throw CacheException(
          'Failed to get theme setting from SharedPreferences');
    }
  }

  @override
  Future<void> setThemeSetting(ThemeModel setting) async {
    try {
      await sharedPreferences.setString(themeKey, setting.setting.toString());
    } catch (e) {
      throw CacheException('Failed to save theme setting to SharedPreferences');
    }
  }
}
