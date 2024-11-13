part of 'article_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object?> get props => [];
}

class GetArticlesEvent extends ArticlesEvent {
  final String? category;
  final bool? forceRefresh;
  final bool loadMore;

  const GetArticlesEvent({
    this.category,
    this.forceRefresh,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [category];
}

class SearchArticlesEvent extends ArticlesEvent {
  final String keyword;

  const SearchArticlesEvent(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class UpdateArticleBookmarkEvent extends ArticlesEvent {
  final Article article;

  const UpdateArticleBookmarkEvent(this.article);
}

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object?> get props => [];
}

class FetchArticles extends ArticleEvent {
  final String? category;
  final bool forceRefresh;
  final int pageSize;

  const FetchArticles({
    this.category,
    this.forceRefresh = false,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [category, forceRefresh, pageSize];
}
