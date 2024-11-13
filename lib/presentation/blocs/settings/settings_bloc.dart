import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:precise/domain/usecases/settings/get_theme.dart';
import 'package:precise/domain/usecases/settings/set_theme.dart';

part 'settings_event.dart';
part 'settings_state.dart';

// presentation/bloc/theme/theme_bloc.dart
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetTheme getTheme;
  final SetTheme setTheme;

  SettingsBloc({
    required this.getTheme,
    required this.setTheme,
  }) : super(SettingsInitial()) {
    on<GetThemeEvent>((event, emit) async {
      emit(SettingsLoading());
      final result = await getTheme(NoParams());
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (setting) => emit(SettingsLoaded(setting)),
      );
    });

    on<ChangeThemeEvent>((event, emit) async {
      emit(SettingsLoading());

      // If the new theme is the same as the system theme, no need to update
      if (event.theme.setting == ThemeSetting.system) {
        emit(SettingsLoaded(event.theme));
        return;
      }

      final result = await setTheme(SetThemeParams(event.theme));
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsLoaded(event.theme)),
      );
    });
  }
}
