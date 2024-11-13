import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/repositories/article_repository.dart';

class GetBookmarkedArticlesUseCase implements UseCase<List<Article>, NoParams> {
  final ArticleRepository repository;

  GetBookmarkedArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) {
    return repository.getBookmarkedArticles();
  }
}

// class GetBookmarkedArticles implements UseCase<List<Article>, NoParams> {
//   final ArticleRepository repository;

//   GetBookmarkedArticles(this.repository);

//   @override
//   Future<Either<Failure, List<Article>>> call(NoParams params) {
//     return repository.getBookmarkedArticles();
//   }
// }
