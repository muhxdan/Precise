part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class GetThemeEvent extends SettingsEvent {}

class ChangeThemeEvent extends SettingsEvent {
  final Theme theme;

  const ChangeThemeEvent(this.theme);

  @override
  List<Object> get props => [theme];
}
