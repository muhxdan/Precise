import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/exceptions.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/data/datasources/local/settings_local_datasource.dart';
import 'package:precise/data/models/settings_model.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:precise/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Theme>> getThemeSetting() async {
    try {
      final model = await localDataSource.getThemeSetting();
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> setThemeSetting(Theme theme) async {
    try {
      await localDataSource.setThemeSetting(
        ThemeModel.fromEntity(theme),
      );
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
