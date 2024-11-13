import 'package:precise/domain/entities/theme.dart';

class ThemeModel extends Theme {
  const ThemeModel(super.setting);

  factory ThemeModel.fromEntity(Theme entity) {
    return ThemeModel(entity.setting);
  }
}
