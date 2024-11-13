// abstract class NewsRepository {
//   Future<Either<Failure, List<Article>>> getArticles({bool refresh = false});
//   Future<Either<Failure, List<Article>>> getArticlesByCategory(
//       String categoryId,
//       {bool refresh = false});
// }

// abstract class ArticleRepository {
//   Future<Either<Failure, List<Article>>> getArticles(String category);
//   Future<Either<Failure, Article>> getArticleDetail(String articleId);
// }

// import 'package:precise/domain/entities/Article.dart';

// abstract class ArticleRepository {
//   Future<Either<Failure, List<Article>>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   });

//   Future<Either<Failure, List<Article>>> getBookmarkedArticles();

//   Future<Either<Failure, bool>> toggleBookmark(Article article);
// }

// abstract class ArticleRepository {
//   Future<List<Article>> getArticles({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   });

//   Future<List<Article>> getBookmarkedArticles();
//   Future<void> toggleBookmark(Article article);
// }
