import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:precise/domain/repositories/settings_repository.dart';

class SetTheme implements UseCase<Unit, SetThemeParams> {
  final SettingsRepository repository;

  SetTheme(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SetThemeParams params) async {
    return await repository.setThemeSetting(params.setting);
  }
}

class SetThemeParams extends Equatable {
  final Theme setting;

  const SetThemeParams(this.setting);

  @override
  List<Object?> get props => [setting];
}
