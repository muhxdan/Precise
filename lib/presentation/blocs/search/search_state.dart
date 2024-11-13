part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final bool isPaginating;
  final List<Article> articles;
  final String? errorMessage;
  final bool hasMore;
  final bool isInitial; // New property

  const SearchState({
    this.isLoading = false,
    this.isPaginating = false,
    this.articles = const [],
    this.errorMessage,
    this.hasMore = false,
    this.isInitial = true, // Default to true
  });

  SearchState copyWith({
    bool? isLoading,
    bool? isPaginating,
    List<Article>? articles,
    String? errorMessage,
    bool? hasMore,
    bool? isInitial,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      articles: articles ?? this.articles,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      isInitial: isInitial ?? this.isInitial,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isPaginating, articles, errorMessage, hasMore, isInitial];
}
