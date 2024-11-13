part of 'article_bloc.dart';

class ArticlesState extends Equatable {
  final List<Article> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;
  final String? keyword;

  const ArticlesState({
    this.articles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.keyword,
  });

  bool get hasError => error != null;
  bool get isEmpty => !isLoading && articles.isEmpty;
  bool get canLoadMore => !isLoading && !isLoadingMore && !hasReachedMax;

  ArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
    String? keyword,
  }) {
    return ArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error, // Pass null to clear error
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        isLoading,
        isLoadingMore,
        error,
        currentPage,
        hasReachedMax,
        keyword,
      ];
}

// class ArticlesState extends Equatable {
//   final List<Article> articles;
//   final bool isLoading;
//   final bool isLoadingMore;
//   final String? error;
//   final int currentPage;
//   final bool hasReachedMax;

//   const ArticlesState({
//     this.articles = const [],
//     this.isLoading = false,
//     this.isLoadingMore = false,
//     this.error,
//     this.currentPage = 1,
//     this.hasReachedMax = false,
//   });

//   ArticlesState copyWith({
//     List<Article>? articles,
//     bool? isLoading,
//     bool? isLoadingMore,
//     String? error,
//     int? currentPage,
//     bool? hasReachedMax,
//   }) {
//     return ArticlesState(
//       articles: articles ?? this.articles,
//       isLoading: isLoading ?? this.isLoading,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//       error: error,
//       currentPage: currentPage ?? this.currentPage,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         articles,
//         isLoading,
//         isLoadingMore,
//         error,
//         currentPage,
//         hasReachedMax,
//       ];
// }

// class ArticlesInitial extends ArticlesState {}

// class ArticlesLoading extends ArticlesState {}

// class ArticlesLoaded extends ArticlesState {
//   @override
//   final List<Article> articles;

//   const ArticlesLoaded(this.articles);

//   @override
//   List<Object> get props => [articles];
// }

// class ArticlesError extends ArticlesState {
//   final String message;

//   const ArticlesError(this.message);

//   @override
//   List<Object> get props => [message];
// }
