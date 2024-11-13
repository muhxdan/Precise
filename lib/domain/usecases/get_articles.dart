import 'package:dartz/dartz.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/repositories/article_repository.dart';

class GetArticlesUseCase implements UseCase<List<Article>, GetArticlesParams> {
  final ArticleRepository repository;

  GetArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(GetArticlesParams params) {
    return repository.getArticles(
      category: params.category,
      page: params.page,
      forceRefresh: params.forceRefresh,
      shouldCache: params.shouldCache,
    );
  }
}

class GetArticlesParams {
  final String? category;
  final bool forceRefresh;
  final int page;
  final bool shouldCache;

  GetArticlesParams({
    this.category,
    required this.forceRefresh,
    this.page = 1,
    this.shouldCache = true,
  });
}


// class GetArticles implements UseCase<List<Article>, GetArticlesParams> {
//   final ArticleRepository repository;

//   GetArticles(this.repository);

//   @override
//   Future<Either<Failure, List<Article>>> call(GetArticlesParams params) {
//     return repository.getArticles(
//       category: params.category,
//       forceRefresh: params.forceRefresh,
//       page: params.page,
//       pageSize: params.pageSize,
//     );
//   }
// }

// class GetArticlesParams extends Equatable {
//   final String? category;
//   final int page;
//   final int pageSize;
//   final bool forceRefresh; // Add forceRefresh parameter

//   const GetArticlesParams({
//     this.category,
//     this.page = 1,
//     this.pageSize = 20,
//     this.forceRefresh = false, // Default to false
//   });

//   @override
//   List<Object?> get props => [category, page, pageSize, forceRefresh];
// }

// class GetArticles {
//   final ArticleRepository repository;

//   GetArticles(this.repository);

//   Future<List<Article>> execute({
//     required int page,
//     required int pageSize,
//     String? category,
//     String? query,
//   }) {
//     return repository.getArticles(
//       page: page,
//       pageSize: pageSize,
//       category: category,
//       query: query,
//     );
//   }
// }

// class GetArticles {
//   final NewsRepository repository;

//   GetArticles(this.repository);

//   Future<Either<Failure, List<Article>>> call({bool refresh = false}) {
//     return repository.getArticles(refresh: refresh);
//   }
// }

// class GetArticles {
//   final ArticleRepository repository;

//   GetArticles(this.repository);

//   Future<Either<Failure, List<Article>>> call(String category) async {
//     return await repository.getArticles(category);
//   }
// }

// class GetArticles {
//   final ArticleRepository repository;

//   GetArticles(this.repository);

//   Future<Either<Failure, List<Article>>> call(ArticleParams params) async {
//     return await repository.getArticles(
//       page: params.page,
//       pageSize: params.pageSize,
//       category: params.category,
//       query: params.query,
//     );
//   }
// }

// class ArticleParams extends Equatable {
//   final int page;
//   final int pageSize;
//   final String? category;
//   final String? query;

//   const ArticleParams({
//     required this.page,
//     required this.pageSize,
//     this.category,
//     this.query,
//   });

//   @override
//   List<Object?> get props => [page, pageSize, category, query];
// }
