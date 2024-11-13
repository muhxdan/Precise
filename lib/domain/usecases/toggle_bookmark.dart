// class ToggleBookmark {
//   final ArticleRepository repository;

//   ToggleBookmark(this.repository);

//   Future<Either<Failure, bool>> call(Article article) async {
//     return await repository.toggleBookmark(article);
//   }
// }

// class ToggleArticleBookmark {
//   final ArticleRepository repository;

//   ToggleArticleBookmark(this.repository);

//   Future<void> execute(Article article) {
//     return repository.toggleBookmark(article);
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/repositories/article_repository.dart';

// class ToggleBookmark implements UseCase<Article, Article> {
//   final ArticleRepository repository;

//   ToggleBookmark(this.repository);

//   @override
//   Future<Either<Failure, Article>> call(Article article) {
//     return repository.toggleBookmark(article);
//   }
// }

class ToggleArticleBookmarkUseCase
    implements UseCase<Article, ToggleBookmarkParams> {
  final ArticleRepository repository;

  ToggleArticleBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, Article>> call(ToggleBookmarkParams params) {
    return repository.toggleBookmark(params.article);
  }
}

class ToggleBookmarkParams {
  final Article article;

  ToggleBookmarkParams({required this.article});
}
