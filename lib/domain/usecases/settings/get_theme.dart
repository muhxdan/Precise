import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:precise/domain/repositories/settings_repository.dart';

class GetTheme implements UseCase<Theme, NoParams> {
  final SettingsRepository repository;

  GetTheme(this.repository);

  @override
  Future<Either<Failure, Theme>> call(NoParams params) async {
    return await repository.getThemeSetting();
  }
}
