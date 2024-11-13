import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:precise/core/errors/failures.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/repositories/article_repository.dart';

// class SearchArticles implements UseCase<List<Article>, String> {
//   final ArticleRepository repository;

//   SearchArticles(this.repository);

//   @override
//   Future<Either<Failure, List<Article>>> call(String keyword) {
//     return repository.searchArticles(keyword);
//   }
// }

class SearchArticlesUseCase implements UseCase<List<Article>, SearchParams> {
  final ArticleRepository repository;

  SearchArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(SearchParams params) {
    return repository.searchArticles(
      params.keyword,
      params.page,
    );
  }
}

class SearchParams extends Equatable {
  final String keyword;
  final int page;

  const SearchParams({
    required this.keyword,
    this.page = 1,
  });

  @override
  List<Object> get props => [keyword, page];
}
