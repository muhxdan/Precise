import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/domain/entities/theme.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Theme>> getThemeSetting();
  Future<Either<Failure, Unit>> setThemeSetting(Theme setting);
}
