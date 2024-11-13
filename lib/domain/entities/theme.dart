import 'package:equatable/equatable.dart';

enum ThemeSetting { system, light, dark }

class Theme extends Equatable {
  final ThemeSetting setting;

  const Theme(this.setting);

  @override
  List<Object> get props => [setting];
}
