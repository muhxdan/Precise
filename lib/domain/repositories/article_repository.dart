import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticles({
    String? category,
    bool forceRefresh,
    bool shouldCache,
    int page,
  });

  Future<Either<Failure, List<Article>>> searchArticles(
      String keyword, int page);

  Future<Either<Failure, List<Article>>> getBookmarkedArticles();

  Future<Either<Failure, Article>> toggleBookmark(Article article);
}
